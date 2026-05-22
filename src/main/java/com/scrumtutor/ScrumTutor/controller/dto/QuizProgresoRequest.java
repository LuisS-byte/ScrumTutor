// com.scrumtutor.ScrumTutor.controller.dto.QuizProgresoRequest
package com.scrumtutor.ScrumTutor.controller.dto;

import java.math.BigDecimal;

public record QuizProgresoRequest(
    BigDecimal puntaje
) {}
