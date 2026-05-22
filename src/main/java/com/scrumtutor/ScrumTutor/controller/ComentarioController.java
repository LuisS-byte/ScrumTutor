// com.scrumtutor.ScrumTutor.controller.ComentarioController
package com.scrumtutor.ScrumTutor.controller;

import com.scrumtutor.ScrumTutor.controller.dto.ComentarioCreateDTO;
import com.scrumtutor.ScrumTutor.controller.dto.ComentarioDTO;
import com.scrumtutor.ScrumTutor.model.Usuario;
import com.scrumtutor.ScrumTutor.security.AuthUtils;
import com.scrumtutor.ScrumTutor.service.ComentarioService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.util.UriComponentsBuilder;

import java.net.URI;
import java.util.List;

@RestController
@RequestMapping("/api/tareas/{idTarea}/comentarios")
@RequiredArgsConstructor
public class ComentarioController {

    private final ComentarioService comentarioService;
    private final AuthUtils authUtils;

    @GetMapping
    public ResponseEntity<List<ComentarioDTO>> listar(@PathVariable Integer idTarea) {
        return ResponseEntity.ok(comentarioService.listarPorTarea(idTarea));
    }

    @PostMapping
    public ResponseEntity<ComentarioDTO> crear(@PathVariable Integer idTarea,
                                               @RequestBody ComentarioCreateDTO dto,
                                               UriComponentsBuilder uriBuilder) {
        Usuario me = authUtils.getCurrentUserOrThrow();
        ComentarioDTO creado = comentarioService.agregar(idTarea, me, dto);
        URI location = uriBuilder
                .path("/api/tareas/{idTarea}/comentarios")
                .buildAndExpand(idTarea)
                .toUri();
        return ResponseEntity.created(location).body(creado);
    }
}
