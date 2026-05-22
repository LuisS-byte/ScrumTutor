package com.scrumtutor.ScrumTutor.model;

import jakarta.persistence.*;
import lombok.*;

@Entity @Table(name="estado_historia")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class EstadoHistoria {
  @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
  @Column(name="id_estado")
  private Integer id;

  @Column(nullable=false, length=50)
  private String descripcion;
}
