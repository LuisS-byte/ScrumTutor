// com.scrumtutor.ScrumTutor.controller.dto.ProyectoMiembroCreateDTO
package com.scrumtutor.ScrumTutor.controller.dto;

public record ProyectoMiembroCreateDTO(
    Long idUsuario,
    Long idRolProyecto
) {}
