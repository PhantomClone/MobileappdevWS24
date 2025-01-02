package edu.hm.mobileappdev.service;

import edu.hm.mobileappdev.entity.Player;
import edu.hm.mobileappdev.entity.Score;
import edu.hm.mobileappdev.repository.PlayerRepository;
import edu.hm.mobileappdev.repository.ScoreRepository;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import java.util.List;
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
    public void saveScore(UUID playerId, int value) {
        Score score = scoreRepository.findByPlayerId(playerId)
            .orElseGet(() -> createNewScore(playerId));

        score.setValue(value);
        scoreRepository.persist(score);
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
        score.setPlayer(playerRepository.findById(playerId));
        return score;
    }
}