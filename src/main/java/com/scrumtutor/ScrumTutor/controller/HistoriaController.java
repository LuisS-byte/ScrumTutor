// com.scrumtutor.ScrumTutor.controller.HistoriaController
package com.scrumtutor.ScrumTutor.controller;

import com.scrumtutor.ScrumTutor.controller.dto.*;
import com.scrumtutor.ScrumTutor.service.HistoriaService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequiredArgsConstructor
public class HistoriaController {

  private final HistoriaService historiaService;

  /* POST /api/historias - Crear historia */
  @PostMapping("/api/historias")
  public ResponseEntity<HistoriaDto> crear(@RequestBody HistoriaCreateDTO dto) {
    return ResponseEntity.ok(historiaService.crear(dto));
  }

  /* GET /api/proyectos/{idProyecto}/historias - Listar */
  @GetMapping("/api/proyectos/{idProyecto}/historias")
  public ResponseEntity<List<HistoriaDto>> listar(@PathVariable Long idProyecto) {
    return ResponseEntity.ok(historiaService.listarPorProyecto(idProyecto));
  }

  /* GET /api/historias/{idHistoria} - Detalle */
  @GetMapping("/api/historias/{idHistoria}")
  public ResponseEntity<HistoriaDto> detalle(@PathVariable Integer idHistoria) {
    return ResponseEntity.ok(historiaService.getDtoById(idHistoria));
  }

  /* PUT /api/historias/{idHistoria} - Editar */
  @PutMapping("/api/historias/{idHistoria}")
  public ResponseEntity<HistoriaDto> actualizar(@PathVariable Integer idHistoria,
                                                @RequestBody HistoriaUpdateDTO dto) {
    return ResponseEntity.ok(historiaService.actualizar(idHistoria, dto));
  }

  /* DELETE /api/historias/{idHistoria} - Eliminar */
  @DeleteMapping("/api/historias/{idHistoria}")
  public ResponseEntity<Void> eliminar(@PathVariable Integer idHistoria) {
    historiaService.eliminar(idHistoria);
    return ResponseEntity.noContent().build();
  }
}
