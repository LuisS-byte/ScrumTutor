package com.scrumtutor.ScrumTutor.model;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity @Table(name="comentarios_tarea")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class ComentarioTarea {
  @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
  private Integer id;

  @ManyToOne(fetch=FetchType.LAZY, optional=false)
  @JoinColumn(name="id_tarea", nullable=false)
  private Tarea tarea;

  @ManyToOne(fetch=FetchType.LAZY, optional=false)
  @JoinColumn(name="id_usuario", nullable=false)
  private Usuario usuario;

  @Column(nullable=false, columnDefinition="TEXT")
  private String contenido;

  @Column(name="fecha_creacion", insertable=false, updatable=false)
  private LocalDateTime fechaCreacion;
}
