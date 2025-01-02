package edu.hm.mobileappdev.resource;

import edu.hm.mobileappdev.dto.PlayerDTO;
import edu.hm.mobileappdev.entity.Score;
import edu.hm.mobileappdev.service.PlayerService;
import jakarta.inject.Inject;
import jakarta.validation.Valid;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
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
    public UUID createPlayer(@Valid PlayerDTO playerDTO) {
        return playerService.getOrCreatePlayer(playerDTO.getName());
    }

    @POST
    @Path("/{id}/score")
    public Response saveScore(@PathParam("id") UUID playerId, @QueryParam("score") int score) {
        if (playerService.saveScore(playerId, score) == null) {
            return Response.status(Response.Status.NOT_FOUND)
                .entity("PlayerId not found.")
                .build();
        }

        return Response.status(Response.Status.NO_CONTENT).build();
    }

    @GET
    @Path("/ranking")
    public List<Score> getRanking(@QueryParam("limit") int limit) {
        return playerService.getTopScores(limit);
    }
}