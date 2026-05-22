// com.scrumtutor.ScrumTutor.controller.dto.QuizPreguntaDTO
package com.scrumtutor.ScrumTutor.controller.dto;

public record QuizPreguntaDTO(
    Integer id,
    String pregunta,
    String opcionA,
    String opcionB,
    String opcionC,
    String opcionCorrecta
) {}
