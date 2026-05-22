// com.scrumtutor.ScrumTutor.controller.dto.ComentarioDTO
package com.scrumtutor.ScrumTutor.controller.dto;

import java.time.LocalDateTime;

public record ComentarioDTO(
    Integer id,
    Integer idTarea,
    Long idUsuario,
    String autorNombre,
    String contenido,
    LocalDateTime fechaCreacion
) {}
