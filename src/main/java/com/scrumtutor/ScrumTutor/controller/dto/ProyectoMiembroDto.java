// com.scrumtutor.ScrumTutor.controller.dto.ProyectoMiembroDto
package com.scrumtutor.ScrumTutor.controller.dto;

public record ProyectoMiembroDto(
        Long idMiembro,
        Long idProyecto,
        Long idUsuario,
        Long idRolProyecto,
        String rolDescripcion,
        String usuarioNombre
// Si quieres enriquecer: String usuarioNombre, String rolProyectoDesc
) {
}
