package com.scrumtutor.ScrumTutor.model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.*;

import java.util.List;

@Entity @Table(name="quizzes")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class Quiz {
  @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
  private Integer id;

  @Column(nullable=false, length=150) private String titulo;

  @Column(columnDefinition="TEXT") private String descripcion;

  @OneToMany(mappedBy="quiz", fetch=FetchType.LAZY) @JsonIgnore
  private List<QuizPregunta> preguntas;
}
