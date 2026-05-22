// com.scrumtutor.ScrumTutor.controller.dto.TareaCreateDTO
package com.scrumtutor.ScrumTutor.controller.dto;

import java.time.LocalDate;

public record TareaCreateDTO(
    Integer idSprint,
    Integer idHistoria,          // opcional
    String  titulo,
    String  descripcion,
    Integer idEstado,
    LocalDate fechaLimite,       // opcional
    Long    idAsignadoA          // opcional
) {}
