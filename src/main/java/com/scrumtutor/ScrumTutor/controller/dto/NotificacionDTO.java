// com.scrumtutor.ScrumTutor.controller.dto.NotificacionDTO
package com.scrumtutor.ScrumTutor.controller.dto;

import java.time.LocalDateTime;

public record NotificacionDTO(
    Integer id,
    Long idUsuario,
    Integer idTipo,
    String tipo,          // descripción del tipo
    String mensaje,
    Boolean leido,
    LocalDateTime fechaCreacion
) {}
