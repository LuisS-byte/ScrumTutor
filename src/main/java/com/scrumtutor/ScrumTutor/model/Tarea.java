package com.scrumtutor.ScrumTutor.model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@Entity @Table(name="tareas")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class Tarea {
  @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
  @Column(name="id_tarea")
  private Integer id;

  @ManyToOne(fetch=FetchType.LAZY) @JoinColumn(name="id_historia")
  private HistoriaUsuario historia;

  @ManyToOne(fetch=FetchType.LAZY) @JoinColumn(name="id_sprint")
  private Sprint sprint;

  @Column(nullable=false, length=150)
  private String titulo;

  @Column(columnDefinition="TEXT")
  private String descripcion;

  @ManyToOne(fetch=FetchType.LAZY) @JoinColumn(name="asignado_a")
  private Usuario asignadoA;

  @ManyToOne(fetch=FetchType.LAZY, optional=false)
  @JoinColumn(name="id_estado", nullable=false)
  private EstadoTarea estado;

  private LocalDate fechaLimite;

  @Column(name="fecha_creacion", insertable=false, updatable=false)
  private LocalDateTime fechaCreacion;

  @OneToMany(mappedBy="tarea", fetch=FetchType.LAZY) @JsonIgnore
  private List<ComentarioTarea> comentarios;
}
