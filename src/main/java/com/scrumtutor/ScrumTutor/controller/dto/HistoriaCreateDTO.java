// com.scrumtutor.ScrumTutor.controller.dto.HistoriaCreateDTO
package com.scrumtutor.ScrumTutor.controller.dto;

public record HistoriaCreateDTO(
    Long idProyecto,
    String titulo,
    String descripcion,
    Integer idPrioridad,
    String criteriosAceptacion,
    Integer idEstado
) {}
