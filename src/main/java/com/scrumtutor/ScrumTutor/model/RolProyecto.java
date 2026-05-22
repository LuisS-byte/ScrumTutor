package com.scrumtutor.ScrumTutor.model;

import jakarta.persistence.*;
import lombok.*;

@Entity @Table(name="rol_proyecto")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class RolProyecto {
  @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
  @Column(name="id_rol_proyecto")
  private Long id;

  @Column(nullable=false, unique=true, length=50)
  private String descripcion;
}
