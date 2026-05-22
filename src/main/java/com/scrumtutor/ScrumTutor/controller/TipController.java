// com.scrumtutor.ScrumTutor.controller.TipController
package com.scrumtutor.ScrumTutor.controller;

import com.scrumtutor.ScrumTutor.controller.dto.TipCreateDTO;
import com.scrumtutor.ScrumTutor.controller.dto.TipDTO;
import com.scrumtutor.ScrumTutor.service.TipService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.util.UriComponentsBuilder;

import java.net.URI;
import java.util.List;

@RestController
@RequestMapping("/api/tips")
@RequiredArgsConstructor
public class TipController {

    private final TipService tipService;

    // GET /api/tips - Listar todos
    @GetMapping
    public ResponseEntity<List<TipDTO>> listarTodos() {
        return ResponseEntity.ok(tipService.listarTodos());
    }

    // GET /api/tips/seccion/{nombre} - Filtrar por sección (case-insensitive)
    @GetMapping("/seccion/{nombre}")
    public ResponseEntity<List<TipDTO>> listarPorSeccion(@PathVariable String nombre) {
        return ResponseEntity.ok(tipService.listarPorSeccion(nombre));
    }

    // POST /api/tips - Crear tip
    @PostMapping
    public ResponseEntity<TipDTO> crear(@RequestBody TipCreateDTO dto, UriComponentsBuilder uriBuilder) {
        TipDTO creado = tipService.crear(dto);
        URI location = uriBuilder.path("/api/tips").build().toUri();
        return ResponseEntity.created(location).body(creado);
    }
}
