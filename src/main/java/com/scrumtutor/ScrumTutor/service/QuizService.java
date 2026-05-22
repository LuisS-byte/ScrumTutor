// com.scrumtutor.ScrumTutor.service.QuizService
package com.scrumtutor.ScrumTutor.service;

import com.scrumtutor.ScrumTutor.controller.dto.*;
import com.scrumtutor.ScrumTutor.model.*;
import com.scrumtutor.ScrumTutor.repository.*;
import com.scrumtutor.ScrumTutor.security.AuthUtils;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.List;

@Service
@RequiredArgsConstructor
public class QuizService {

    private final QuizRepository quizRepo;
    private final QuizPreguntaRepository preguntaRepo;
    private final QuizProgresoUsuarioRepository progresoRepo;
    private final AuthUtils authUtils;

    /* ---------- Mapping ---------- */

    private QuizDTO toDto(Quiz q) {
        return new QuizDTO(q.getId(), q.getTitulo(), q.getDescripcion());
    }

    private QuizPreguntaDTO toDto(QuizPregunta p) {
        return new QuizPreguntaDTO(
            p.getId(),
            p.getPregunta(),
            p.getOpcionA(),
            p.getOpcionB(),
            p.getOpcionC(),
            p.getOpcionCorrecta()
        );
    }

    private QuizWithPreguntasDTO toFullDto(Quiz q) {
        List<QuizPreguntaDTO> preguntas = q.getPreguntas()
                .stream().map(this::toDto).toList();
        return new QuizWithPreguntasDTO(q.getId(), q.getTitulo(), q.getDescripcion(), preguntas);
    }

    /* ---------- Use cases ---------- */

    @Transactional(readOnly = true)
    public List<QuizDTO> listar() {
        return quizRepo.findAll().stream().map(this::toDto).toList();
    }

    @Transactional(readOnly = true)
    public QuizWithPreguntasDTO getConPreguntas(Integer idQuiz) {
        Quiz q = quizRepo.findById(idQuiz)
                .orElseThrow(() -> new RuntimeException("Quiz no encontrado"));
        return toFullDto(q);
    }

    @Transactional
    public QuizDTO crear(QuizCreateDTO dto) {
        if (dto == null || dto.titulo() == null || dto.titulo().isBlank()) {
            throw new RuntimeException("El título es obligatorio");
        }
        Quiz q = Quiz.builder()
                .titulo(dto.titulo().trim())
                .descripcion(dto.descripcion() != null ? dto.descripcion().trim() : null)
                .build();
        return toDto(quizRepo.save(q));
    }

    @Transactional
    public QuizPreguntaDTO agregarPregunta(Integer idQuiz, QuizPreguntaCreateDTO dto) {
        Quiz q = quizRepo.findById(idQuiz)
                .orElseThrow(() -> new RuntimeException("Quiz no encontrado"));

        if (dto == null || dto.pregunta() == null || dto.pregunta().isBlank()) {
            throw new RuntimeException("La pregunta es obligatoria");
        }
        String oc = (dto.opcionCorrecta() != null) ? dto.opcionCorrecta().trim().toUpperCase() : "";
        if (!(oc.equals("A") || oc.equals("B") || oc.equals("C"))) {
            throw new RuntimeException("opcionCorrecta debe ser A, B o C");
        }

        QuizPregunta p = QuizPregunta.builder()
                .quiz(q)
                .pregunta(dto.pregunta().trim())
                .opcionA(dto.opcionA())
                .opcionB(dto.opcionB())
                .opcionC(dto.opcionC())
                .opcionCorrecta(oc)
                .build();

        return toDto(preguntaRepo.save(p));
    }

    @Transactional
    public void guardarProgreso(Integer idQuiz, BigDecimal puntaje) {
        if (puntaje == null) throw new RuntimeException("El puntaje es obligatorio");

        Usuario me = authUtils.getCurrentUserOrThrow();
        Quiz q = quizRepo.findById(idQuiz)
                .orElseThrow(() -> new RuntimeException("Quiz no encontrado"));

        QuizProgresoUsuario prog = QuizProgresoUsuario.builder()
                .usuario(me)
                .quiz(q)
                .puntaje(puntaje)
                .build();

        progresoRepo.save(prog);
    }
}
