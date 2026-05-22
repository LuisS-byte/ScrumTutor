// com.scrumtutor.ScrumTutor.model.Proyecto
package com.scrumtutor.ScrumTutor.model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name="proyectos")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class Proyecto {

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  private Long id;   // <--- Long

  @Column(nullable=false, length=150)
  private String nombre;

  @Column(columnDefinition="TEXT")
  private String descripcion;

  @ManyToOne(fetch=FetchType.LAZY, optional=false)
  @JoinColumn(name="id_usuario", nullable=false)
  private Usuario usuario;

  private LocalDate fechaInicio;
  private LocalDate fechaFin;

  @Column(name="fecha_creacion", insertable=false, updatable=false)
  private LocalDateTime fechaCreacion;

  @OneToMany(mappedBy="proyecto", fetch=FetchType.LAZY) @JsonIgnore
  private List<ProyectoMiembro> miembros;

  @OneToMany(mappedBy="proyecto", fetch=FetchType.LAZY) @JsonIgnore
  private List<Sprint> sprints;

  @OneToMany(mappedBy="proyecto", fetch=FetchType.LAZY) @JsonIgnore
  private List<HistoriaUsuario> historias;
}
