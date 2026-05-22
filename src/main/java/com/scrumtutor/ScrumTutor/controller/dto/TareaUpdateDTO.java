// com.scrumtutor.ScrumTutor.controller.dto.TareaUpdateDTO
package com.scrumtutor.ScrumTutor.controller.dto;

import java.time.LocalDate;

public record TareaUpdateDTO(
    Integer idHistoria,          // opcional
    String  titulo,
    String  descripcion,
    Integer idEstado,
    LocalDate fechaLimite,
    Long    idAsignadoA          // opcional (también puedes usar el endpoint /asignar)
) {}
