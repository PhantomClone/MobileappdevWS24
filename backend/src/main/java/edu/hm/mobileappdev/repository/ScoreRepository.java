package edu.hm.mobileappdev.repository;

import edu.hm.mobileappdev.entity.Score;
import io.quarkus.hibernate.orm.panache.PanacheRepository;
import jakarta.enterprise.context.ApplicationScoped;

import java.util.List;

@ApplicationScoped
public class ScoreRepository implements PanacheRepository<Score> {
    public List<Score> findTopScores(int limit) {
        return find("ORDER BY value DESC").page(0, limit).list();
    }
}