package com.scrumtutor.ScrumTutor.model;

import jakarta.persistence.*;
import lombok.*;

@Entity @Table(name="proyecto_miembros")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class ProyectoMiembro {
  @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
  @Column(name="id_miembro")
  private Long id;

  @ManyToOne(fetch=FetchType.LAZY, optional=false)
  @JoinColumn(name="id_proyecto", nullable=false)
  private Proyecto proyecto;

@Column(nullable = false)
private Boolean invitacion = false;


  @ManyToOne(fetch=FetchType.LAZY, optional=false)
  @JoinColumn(name="id_usuario", nullable=false)
  private Usuario usuario;

  @ManyToOne(fetch=FetchType.LAZY, optional=false)
  @JoinColumn(name="id_rol_proyecto", nullable=false)
  private RolProyecto rolProyecto;


}
