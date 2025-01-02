package edu.hm.mobileappdev.dto;

import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class PlayerDTO {

    @Size(min = 3, max = 15, message = "Player name must be between 3 and 15 characters long")
    private String name;

}