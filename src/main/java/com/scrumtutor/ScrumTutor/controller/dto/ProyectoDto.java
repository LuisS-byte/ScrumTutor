// com.scrumtutor.ScrumTutor.controller.dto.ProyectoDto
package com.scrumtutor.ScrumTutor.controller.dto;

import java.time.LocalDate;

public record ProyectoDto(
    Long id,
    String nombre,
    String descripcion,
    LocalDate fechaInicio,
    LocalDate fechaFin,
    Long idUsuario
) {}
