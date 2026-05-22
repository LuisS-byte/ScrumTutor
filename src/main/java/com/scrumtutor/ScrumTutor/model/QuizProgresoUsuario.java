package com.scrumtutor.ScrumTutor.model;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity @Table(name="quiz_progreso_usuario")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class QuizProgresoUsuario {
  @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
  private Integer id;

  @ManyToOne(fetch=FetchType.LAZY, optional=false)
  @JoinColumn(name="id_usuario", nullable=false)
  private Usuario usuario;

  @ManyToOne(fetch=FetchType.LAZY, optional=false)
  @JoinColumn(name="id_quiz", nullable=false)
  private Quiz quiz;

  @Column(precision=5, scale=2) private java.math.BigDecimal puntaje;

  @Column(name="fecha_completado", insertable=false, updatable=false)
  private LocalDateTime fechaCompletado;
}
