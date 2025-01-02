package edu.hm.mobileappdev.resource;

import edu.hm.mobileappdev.dto.PlayerDTO;
import edu.hm.mobileappdev.repository.PlayerRepository;
import edu.hm.mobileappdev.repository.ScoreRepository;
import io.quarkus.test.junit.QuarkusTest;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import java.util.UUID;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import static io.restassured.RestAssured.given;
import static org.hamcrest.Matchers.is;
import static org.junit.jupiter.api.Assertions.assertNotNull;

@QuarkusTest
public class PlayerResourceTest {

  @Inject
  PlayerRepository playerRepository;

  @Inject
  ScoreRepository scoreRepository;

  @BeforeEach
  @Transactional
  public void beforeEach() {
    scoreRepository.deleteAll();
    playerRepository.deleteAll();
  }

  @Test
  public void testCreatePlayer() {
    String name = "Alice";
    UUID playerId = createPlayer(name);

    assertNotNull(playerId);
  }

  @Test
  public void testSaveScore() {
    String name = "Bob";
    UUID playerId = createPlayer(name);

    assertNotNull(playerId);

    int score = 100;
    setScoreForPlayer(playerId, score);
  }

  @Test
  public void testGetRanking() {
    setScoreForPlayer(createPlayer("Max"), 200);
    setScoreForPlayer(createPlayer("Lisa"), 100);
    setScoreForPlayer(createPlayer("Musterman"), 150);

    given()
        .header("Content-Type", "application/json")
        .queryParam("limit", 2)
        .when().get("/players/ranking")
        .then()
        .statusCode(200)
        .body("size()", is(2));
  }

  private static UUID createPlayer(String name) {
    PlayerDTO playerDTO = new PlayerDTO();
    playerDTO.setName(name);
    return given()
        .body(playerDTO)
        .header("Content-Type", "application/json")
        .when().post("/players/create")
        .then()
        .statusCode(200)
        .extract()
        .as(UUID.class);
  }

  private static void setScoreForPlayer(UUID playerId, int score) {
    given()
        .header("Content-Type", "application/json")
        .queryParam("score", score)
        .when().post("/players/{id}/score", playerId)
        .then()
        .statusCode(204);
  }

}
