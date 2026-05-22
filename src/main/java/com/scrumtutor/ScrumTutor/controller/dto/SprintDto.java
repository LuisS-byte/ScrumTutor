// com.scrumtutor.ScrumTutor.controller.dto.SprintDto
package com.scrumtutor.ScrumTutor.controller.dto;

import java.time.LocalDate;

public record SprintDto(
        Integer id,
        Long idProyecto,
        String nombre,
        String objetivo,
        LocalDate fechaInicio,
        LocalDate fechaFin,
        Integer idEstado,
        String estadoDescripcion
) {}
