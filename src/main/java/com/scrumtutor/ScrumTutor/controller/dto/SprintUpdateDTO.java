// com.scrumtutor.ScrumTutor.controller.dto.SprintUpdateDTO
package com.scrumtutor.ScrumTutor.controller.dto;

import java.time.LocalDate;

public record SprintUpdateDTO(
        String nombre,
        String objetivo,
        LocalDate fechaInicio,
        LocalDate fechaFin,
        Integer idEstado
) {}
