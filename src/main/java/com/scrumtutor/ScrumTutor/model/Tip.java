package com.scrumtutor.ScrumTutor.model;

import jakarta.persistence.*;
import lombok.*;

@Entity @Table(name="tips")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class Tip {
  @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
  private Integer id;

  @Column(nullable=false, length=100)
  private String seccion;

  @Column(nullable=false, columnDefinition="TEXT")
  private String mensaje;
}
