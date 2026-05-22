// com.scrumtutor.ScrumTutor.controller.SprintController
package com.scrumtutor.ScrumTutor.controller;

import com.scrumtutor.ScrumTutor.controller.dto.SprintCreateDTO;
import com.scrumtutor.ScrumTutor.controller.dto.SprintDto;
import com.scrumtutor.ScrumTutor.controller.dto.SprintUpdateDTO;
import com.scrumtutor.ScrumTutor.service.SprintService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequiredArgsConstructor
public class SprintController {

    private final SprintService sprintService;

    /* POST /api/sprints */
    @PostMapping("/api/sprints")
    public ResponseEntity<SprintDto> crear(@RequestBody SprintCreateDTO dto) {
        return ResponseEntity.ok(sprintService.crear(dto));
    }

    /* GET /api/proyectos/{idProyecto}/sprints */
    @GetMapping("/api/proyectos/{idProyecto}/sprints")
    public ResponseEntity<List<SprintDto>> listarPorProyecto(@PathVariable Long idProyecto) {
        return ResponseEntity.ok(sprintService.listarPorProyecto(idProyecto));
    }

    /* GET /api/sprints/{idSprint} */
    @GetMapping("/api/sprints/{idSprint}")
    public ResponseEntity<SprintDto> detalle(@PathVariable Integer idSprint) {
        return ResponseEntity.ok(sprintService.detalle(idSprint));
    }

    /* PUT /api/sprints/{idSprint} */
    @PutMapping("/api/sprints/{idSprint}")
    public ResponseEntity<SprintDto> actualizar(@PathVariable Integer idSprint,
                                                @RequestBody SprintUpdateDTO dto) {
        return ResponseEntity.ok(sprintService.actualizar(idSprint, dto));
    }

    /* DELETE /api/sprints/{idSprint} */
    @DeleteMapping("/api/sprints/{idSprint}")
    public ResponseEntity<Void> eliminar(@PathVariable Integer idSprint) {
        sprintService.eliminar(idSprint);
        return ResponseEntity.noContent().build();
    }
}
