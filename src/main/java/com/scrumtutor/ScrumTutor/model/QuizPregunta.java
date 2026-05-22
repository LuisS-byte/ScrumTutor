package com.scrumtutor.ScrumTutor.model;

import jakarta.persistence.*;
import lombok.*;

@Entity @Table(name="quiz_preguntas")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class QuizPregunta {
  @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
  private Integer id;

  @ManyToOne(fetch=FetchType.LAZY, optional=false)
  @JoinColumn(name="id_quiz", nullable=false)
  private Quiz quiz;

  @Column(nullable=false, columnDefinition="TEXT")
  private String pregunta;

  @Column(name="opcion_a", length=255) private String opcionA;
  @Column(name="opcion_b", length=255) private String opcionB;
  @Column(name="opcion_c", length=255) private String opcionC;

  @Column(name="opcion_correcta", nullable=false, length=1)
  private String opcionCorrecta;
}
