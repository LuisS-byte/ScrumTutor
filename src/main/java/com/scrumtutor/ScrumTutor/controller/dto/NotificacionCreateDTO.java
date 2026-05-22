// com.scrumtutor.ScrumTutor.controller.dto.NotificacionCreateDTO
package com.scrumtutor.ScrumTutor.controller.dto;

public record NotificacionCreateDTO(
    Long idUsuario,
    Integer idTipo,
    String mensaje
) {}
