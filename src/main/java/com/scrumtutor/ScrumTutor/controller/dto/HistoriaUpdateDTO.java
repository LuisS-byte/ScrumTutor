// com.scrumtutor.ScrumTutor.controller.dto.HistoriaUpdateDTO
package com.scrumtutor.ScrumTutor.controller.dto;

public record HistoriaUpdateDTO(
    String titulo,
    String descripcion,
    Integer idPrioridad,
    String criteriosAceptacion,
    Integer idEstado
) {}
