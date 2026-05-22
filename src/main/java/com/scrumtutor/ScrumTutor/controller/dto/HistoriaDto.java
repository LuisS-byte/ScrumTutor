// com.scrumtutor.ScrumTutor.controller.dto.HistoriaDto
package com.scrumtutor.ScrumTutor.controller.dto;

import java.time.LocalDateTime;

public record HistoriaDto(
    Integer id,
    Long idProyecto,
    String titulo,
    String descripcion,
    Integer idPrioridad,
    String prioridad,
    String criteriosAceptacion,
    Integer idEstado,
    String estado,
    LocalDateTime fechaCreacion
) {}
