package edu.hm.mobileappdev.service;

import edu.hm.mobileappdev.dto.GameDTO;
import edu.hm.mobileappdev.proto.Game.*;
import edu.hm.mobileappdev.proto.KniffelGame;
import edu.hm.mobileappdev.repository.PlayerRepository;
import io.quarkus.grpc.GrpcService;
import io.smallrye.mutiny.Uni;
import io.smallrye.mutiny.Multi;

import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

@GrpcService
public class KniffelGameService implements KniffelGame {

  private final Map<String, GameDTO> games = new ConcurrentHashMap<>();
  private final ScheduledExecutorService scheduler = Executors.newScheduledThreadPool(1);
  @Inject
  PlayerRepository playerRepository;

  @Override
  @Transactional
  public Uni<GameId> createGame(Player request) {
    String gameId = generateGameCode();
    return playerRepository.findByName(request.getPlayerName())
        .map(player -> new GameDTO(gameId, player))
        .map(game -> {
          games.put(gameId, game);
          return Uni.createFrom().item(GameId.newBuilder().setId(gameId).build());
        })
        .orElseGet(() -> Uni.createFrom().failure(new RuntimeException("Player not found")));
  }

  @Override
  @Transactional
  public Uni<Ack> joinGame(JoinRequest request) {
    GameDTO game = games.get(request.getGameId());
    if (game == null) {
      return Uni.createFrom().failure(new RuntimeException("Game not found"));
    }

    Optional<edu.hm.mobileappdev.entity.Player> optionalPlayer = playerRepository.findByName(request.getPlayer().getPlayerName());
    if (optionalPlayer.isEmpty()) {
      return Uni.createFrom().failure(new RuntimeException("Player not found"));
    }

    if (!game.addPlayer(optionalPlayer.get())) {
      return Uni.createFrom().failure(new RuntimeException("Could not join"));
    }

    scheduler.schedule(() -> game.broadcastState(), 1, TimeUnit.SECONDS);

    return Uni.createFrom().item(Ack.newBuilder().setMessage("Joined successfully").build());
  }

  @Override
  public Uni<Ack> startGame(GameId request) {
    GameDTO game = games.get(request.getId());
    if (game == null) {
      return Uni.createFrom().item(Ack.newBuilder().setMessage("Game not found").build());
    }

    game.startGame();
    return Uni.createFrom().item(Ack.newBuilder().setMessage("Game started").build());
  }

  @Override
  public Uni<GameState> sendMove(PlayerMove request) {
    GameDTO game = games.get(request.getGameId());
    if (game == null) {
      return Uni.createFrom().item(GameState.newBuilder().setGameStarted(false).build());
    }

    game.processMove(request);
    return Uni.createFrom().item(game.toGameState());
  }

  @Override
  public Multi<GameState> listenForGameUpdates(GameId request) {
    GameDTO game = games.get(request.getId());
    if (game == null) {
      return Multi.createFrom().failure(new RuntimeException("Game not found"));
    }

    return game.getUpdates();
  }

  private String generateGameCode() {
    return String.format(Locale.GERMAN, "%05d", (int) (Math.random() * 100000));
  }
}
