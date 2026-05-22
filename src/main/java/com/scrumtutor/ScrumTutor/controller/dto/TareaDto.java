// com.scrumtutor.ScrumTutor.controller.dto.TareaDto
package com.scrumtutor.ScrumTutor.controller.dto;

import java.time.LocalDate;
import java.time.LocalDateTime;

public record TareaDto(
    Integer id,
    Integer idSprint,
    Integer idHistoria,
    String  titulo,
    String  descripcion,
    Integer idEstado,
    String  estado,
    Long    idAsignadoA,
    String  asignadoANombre,
    LocalDate fechaLimite,
    LocalDateTime fechaCreacion
) {}
