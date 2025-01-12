package edu.hm.mobileappdev.dto;


import edu.hm.mobileappdev.proto.Game.*;
import java.util.Collections;
import java.util.List;

import io.smallrye.mutiny.Multi;
import io.smallrye.mutiny.operators.multi.processors.BroadcastProcessor;

import java.util.ArrayList;

public class GameDTO {
  private final String gameId;
  private final List<edu.hm.mobileappdev.entity.Player> players = new ArrayList<>();
  private final List<PlayerMove> moves = new ArrayList<>();
  private edu.hm.mobileappdev.entity.Player currentPlayer;
  private boolean gameStarted = false;
  private final BroadcastProcessor<GameState> updates = BroadcastProcessor.create();

  public GameDTO(String gameId, edu.hm.mobileappdev.entity.Player creator) {
    this.gameId = gameId;
    this.players.add(creator);
    this.currentPlayer = creator;
  }

  public boolean addPlayer(edu.hm.mobileappdev.entity.Player player) {
    if (!gameStarted && players.stream().noneMatch(player1 -> player1.getId().equals(player.getId()))) {
      players.add(player);
      Collections.shuffle(players);
      return true;
    }

    return false;
  }

  public void startGame() {
    this.gameStarted = true;
    broadcastState();
  }

  public void processMove(PlayerMove move) {
    if (!move.getPlayer().getPlayerName().equalsIgnoreCase(currentPlayer.getName())) {
      return;
    }

    moves.add(move);

    if (moves.size() > 10) {
      moves.remove(0);
    }

    if (move.getDone() != KniffelField.none) {
      updateCurrentPlayer();
    }

    broadcastState();
  }


  private void updateCurrentPlayer() {
    int currentIndex = players.indexOf(currentPlayer);
    currentPlayer = players.get((currentIndex + 1) % players.size());
  }

  public void broadcastState() {
    updates.onNext(toGameState());
  }

  public GameState toGameState() {
    return GameState.newBuilder()
        .setGameId(gameId)
        .addAllPlayers(players.stream().map(player -> Player.newBuilder().setPlayerName(player.getName()).build()).toList())
        .setCurrentPlayer(Player.newBuilder().setPlayerName(currentPlayer.getName()).build())
        .addAllMoves(moves)
        .setGameStarted(gameStarted)
        .build();
  }

  public Multi<GameState> getUpdates() {
    return updates;
  }
}
