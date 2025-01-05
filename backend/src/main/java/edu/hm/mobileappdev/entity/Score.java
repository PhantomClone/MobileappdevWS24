package edu.hm.mobileappdev.entity;

import jakarta.persistence.*;
import java.util.UUID;
import lombok.Getter;
import lombok.Setter;

@Entity
@Getter
@Setter
public class Score {

  @Id
  @GeneratedValue
  private Long id;

  @OneToOne(fetch = FetchType.LAZY)
  @JoinColumn(name = "player_id", referencedColumnName = "id")
  private Player player;

  private int value;

}