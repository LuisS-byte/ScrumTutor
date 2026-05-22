package com.scrumtutor.ScrumTutor.model;

import jakarta.persistence.*;
import lombok.*;

@Entity @Table(name="prioridad_historia")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class PrioridadHistoria {
  @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
  @Column(name="id_prioridad")
  private Integer id;

  @Column(nullable=false, length=50)
  private String descripcion;
}
