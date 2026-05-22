// com.scrumtutor.ScrumTutor.controller.dto.SprintCreateDTO
package com.scrumtutor.ScrumTutor.controller.dto;

import java.time.LocalDate;

public record SprintCreateDTO(
        Long idProyecto,
        String nombre,
        String objetivo,
        LocalDate fechaInicio,
        LocalDate fechaFin,
        Integer idEstado
) {}
