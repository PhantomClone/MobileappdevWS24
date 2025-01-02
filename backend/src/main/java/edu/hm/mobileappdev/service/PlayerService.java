package edu.hm.mobileappdev.service;

import edu.hm.mobileappdev.entity.Player;
import edu.hm.mobileappdev.entity.Score;
import edu.hm.mobileappdev.repository.PlayerRepository;
import edu.hm.mobileappdev.repository.ScoreRepository;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@ApplicationScoped
public class PlayerService {
    @Inject
    PlayerRepository playerRepository;

    @Inject
    ScoreRepository scoreRepository;

    @Transactional
    public UUID getOrCreatePlayer(String name) {
        return playerRepository.findByName(name)
            .map(Player::getId)
            .orElseGet(() -> createNewPlayer(name));
    }

    @Transactional
    public Score saveScore(UUID playerId, int value) {
        Optional<Score> optionalScore = scoreRepository.findByPlayerId(playerId);

        Score score;
        if (optionalScore.isEmpty()) {
            Optional<Player> optionalPlayer = playerRepository.findById(playerId);

            if (optionalPlayer.isEmpty()) {
                return null;
            }

            score = new Score();
            score.setPlayer(optionalPlayer.get());
        } else {
            score = optionalScore.get();
        }

        score.setValue(value);
        scoreRepository.persist(score);

        return score;
    }

    public List<Score> getTopScores(int limit) {
        return scoreRepository.findTopScores(limit);
    }

    private UUID createNewPlayer(String name) {
        Player player = new Player();
        player.setName(name);
        playerRepository.persist(player);
        return player.getId();
    }

    private Score createNewScore(UUID playerId) {
        Score score = new Score();
        Optional<Player> optionalPlayer = playerRepository.findById(playerId);
        if (optionalPlayer.isEmpty()) {
            return null;
        }

        score.setPlayer(optionalPlayer.get());
        return score;
    }
}