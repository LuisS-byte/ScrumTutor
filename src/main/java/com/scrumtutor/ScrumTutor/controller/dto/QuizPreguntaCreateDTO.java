// com.scrumtutor.ScrumTutor.controller.dto.QuizPreguntaCreateDTO
package com.scrumtutor.ScrumTutor.controller.dto;

public record QuizPreguntaCreateDTO(
    String pregunta,
    String opcionA,
    String opcionB,
    String opcionC,
    String opcionCorrecta // "A" | "B" | "C"
) {}
