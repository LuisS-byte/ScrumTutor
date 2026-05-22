// com.scrumtutor.ScrumTutor.controller.QuizController
package com.scrumtutor.ScrumTutor.controller;

import com.scrumtutor.ScrumTutor.controller.dto.*;
import com.scrumtutor.ScrumTutor.service.QuizService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.util.UriComponentsBuilder;

import java.math.BigDecimal;
import java.net.URI;
import java.util.List;

@RestController
@RequestMapping("/api/quizzes")
@RequiredArgsConstructor
public class QuizController {

    private final QuizService quizService;

    // GET /api/quizzes - Listar quizzes
    @GetMapping
    public ResponseEntity<List<QuizDTO>> listar() {
        return ResponseEntity.ok(quizService.listar());
    }

    // GET /api/quizzes/{idQuiz} - Ver quiz con preguntas
    @GetMapping("/{idQuiz}")
    public ResponseEntity<QuizWithPreguntasDTO> getConPreguntas(@PathVariable Integer idQuiz) {
        return ResponseEntity.ok(quizService.getConPreguntas(idQuiz));
    }

    // POST /api/quizzes - Crear quiz
    @PostMapping
    public ResponseEntity<QuizDTO> crear(@RequestBody QuizCreateDTO dto, UriComponentsBuilder uri) {
        QuizDTO creado = quizService.crear(dto);
        URI loc = uri.path("/api/quizzes/{id}").buildAndExpand(creado.id()).toUri();
        return ResponseEntity.created(loc).body(creado);
    }

    // POST /api/quizzes/{idQuiz}/preguntas - Agregar pregunta
    @PostMapping("/{idQuiz}/preguntas")
    public ResponseEntity<QuizPreguntaDTO> agregarPregunta(@PathVariable Integer idQuiz,
                                                           @RequestBody QuizPreguntaCreateDTO dto) {
        return ResponseEntity.ok(quizService.agregarPregunta(idQuiz, dto));
    }

    // POST /api/quizzes/{idQuiz}/progreso - Guardar puntaje (para el usuario autenticado)
    @PostMapping("/{idQuiz}/progreso")
    public ResponseEntity<Void> guardarProgreso(@PathVariable Integer idQuiz,
                                                @RequestBody QuizProgresoRequest req) {
        quizService.guardarProgreso(idQuiz, req.puntaje());
        return ResponseEntity.noContent().build();
    }
}
