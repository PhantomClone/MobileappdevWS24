package edu.hm.mobileappdev.repository;

import edu.hm.mobileappdev.entity.Player;
import io.quarkus.hibernate.orm.panache.PanacheRepository;
import jakarta.enterprise.context.ApplicationScoped;
import java.util.Optional;
import java.util.UUID;

@ApplicationScoped
public class PlayerRepository implements PanacheRepository<Player> {
    public Player findById(UUID id) {
        return find("id", id).firstResult();
    }
    public Optional<Player> findByName(String playerName) {
        return find("name", playerName).firstResultOptional();
    }
}