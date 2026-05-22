// com.scrumtutor.ScrumTutor.controller.TareaController
package com.scrumtutor.ScrumTutor.controller;

import com.scrumtutor.ScrumTutor.controller.dto.*;
import com.scrumtutor.ScrumTutor.service.TareaService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequiredArgsConstructor
public class TareaController {

  private final TareaService tareaService;

  // POST /api/tareas - Crear tarea
  @PostMapping("/api/tareas")
  public ResponseEntity<TareaDto> crear(@RequestBody TareaCreateDTO dto) {
    return ResponseEntity.ok(tareaService.crear(dto));
  }

  // GET /api/sprints/{idSprint}/tareas - Listar tareas de un sprint
  @GetMapping("/api/sprints/{idSprint}/tareas")
  public ResponseEntity<List<TareaDto>> listar(@PathVariable Integer idSprint) {
    return ResponseEntity.ok(tareaService.listarPorSprint(idSprint));
  }

  // GET /api/tareas/{idTarea} - Detalle
  @GetMapping("/api/tareas/{idTarea}")
  public ResponseEntity<TareaDto> detalle(@PathVariable Integer idTarea) {
    return ResponseEntity.ok(tareaService.detalle(idTarea));
  }

  // PUT /api/tareas/{idTarea} - Editar
  @PutMapping("/api/tareas/{idTarea}")
  public ResponseEntity<TareaDto> actualizar(@PathVariable Integer idTarea,
                                             @RequestBody TareaUpdateDTO dto) {
    return ResponseEntity.ok(tareaService.actualizar(idTarea, dto));
  }

  // PUT /api/tareas/{idTarea}/asignar - Asignar usuario
  @PutMapping("/api/tareas/{idTarea}/asignar")
  public ResponseEntity<TareaDto> asignar(@PathVariable Integer idTarea,
                                          @RequestBody TareaAssignDTO dto) {
    return ResponseEntity.ok(tareaService.asignarUsuario(idTarea, dto.idUsuario()));
  }

  // DELETE /api/tareas/{idTarea} - Eliminar
  @DeleteMapping("/api/tareas/{idTarea}")
  public ResponseEntity<Void> eliminar(@PathVariable Integer idTarea) {
    tareaService.eliminar(idTarea);
    return ResponseEntity.noContent().build();
  }
}
