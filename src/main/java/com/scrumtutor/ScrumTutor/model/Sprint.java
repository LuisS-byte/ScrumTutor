package com.scrumtutor.ScrumTutor.model;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDate;

@Entity @Table(name="sprints")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class Sprint {
  @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
  @Column(name="id_sprint")
  private Integer id;

  @ManyToOne(fetch=FetchType.LAZY, optional=false)
  @JoinColumn(name="id_proyecto", nullable=false)
  private Proyecto proyecto;

  @Column(nullable=false, length=100)
  private String nombre;

  @Column(columnDefinition="TEXT") private String objetivo;

  private LocalDate fechaInicio;
  private LocalDate fechaFin;

  @ManyToOne(fetch=FetchType.LAZY, optional=false)
  @JoinColumn(name="id_estado", nullable=false)
  private EstadoSprint estado;
}
