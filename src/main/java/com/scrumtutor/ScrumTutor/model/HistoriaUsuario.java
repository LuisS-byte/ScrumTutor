package com.scrumtutor.ScrumTutor.model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "historias_usuario")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class HistoriaUsuario {

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  @Column(name = "id_historia")
  private Integer id;

  @ManyToOne(fetch = FetchType.LAZY, optional = false)
  @JoinColumn(name = "id_proyecto", nullable = false)
  private Proyecto proyecto;

  @Column(nullable = false, length = 150)
  private String titulo;

  @Column(columnDefinition = "TEXT")
  private String descripcion;

  @ManyToOne(fetch = FetchType.LAZY, optional = false)
  @JoinColumn(name = "id_prioridad", nullable = false)
  private PrioridadHistoria prioridad;

  @Column(name = "criterios_aceptacion", columnDefinition = "TEXT")
  private String criteriosAceptacion;

  @ManyToOne(fetch = FetchType.LAZY, optional = false)
  @JoinColumn(name = "id_estado", nullable = false)
  private EstadoHistoria estado;

  @Column(name = "fecha_creacion", insertable = false, updatable = false)
  private LocalDateTime fechaCreacion;

  @OneToMany(mappedBy = "historia", fetch = FetchType.LAZY)
  @JsonIgnore
  private List<Tarea> tareas;
}
