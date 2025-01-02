package edu.hm.mobileappdev.resource;

import edu.hm.mobileappdev.entity.Score;
import edu.hm.mobileappdev.service.PlayerService;
import jakarta.inject.Inject;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import java.util.List;
import java.util.UUID;

@Path("/players")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class PlayerResource {
    @Inject
    PlayerService playerService;

    @POST
    @Path("/create")
    public UUID createPlayer(String name) {
        return playerService.createPlayer(name);
    }

    @POST
    @Path("/{id}/score")
    public void saveScore(@PathParam("id") UUID playerId, int score) {
        playerService.saveScore(playerId, score);
    }

    @GET
    @Path("/ranking")
    public List<Score> getRanking(@QueryParam("limit") int limit) {
        return playerService.getTopScores(limit);
    }
}