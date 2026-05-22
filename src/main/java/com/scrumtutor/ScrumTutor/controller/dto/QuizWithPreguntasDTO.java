// com.scrumtutor.ScrumTutor.controller.dto.QuizWithPreguntasDTO
package com.scrumtutor.ScrumTutor.controller.dto;

import java.util.List;

public record QuizWithPreguntasDTO(
    Integer id,
    String titulo,
    String descripcion,
    List<QuizPreguntaDTO> preguntas
) {}
