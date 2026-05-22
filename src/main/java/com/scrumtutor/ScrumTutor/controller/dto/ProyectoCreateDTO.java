package com.scrumtutor.ScrumTutor.controller.dto;

import java.time.LocalDate;

public record ProyectoCreateDTO(
    String nombre,
    String descripcion,
    LocalDate fechaInicio,
    LocalDate fechaFin
) {}
