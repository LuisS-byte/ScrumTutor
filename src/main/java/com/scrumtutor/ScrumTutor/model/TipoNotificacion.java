package com.scrumtutor.ScrumTutor.model;

import jakarta.persistence.*;
import lombok.*;

@Entity @Table(name="tipo_notificacion")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class TipoNotificacion {
  @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
  @Column(name="id_tipo")
  private Integer id;

  @Column(nullable=false, unique=true, length=50)
  private String descripcion;
}
