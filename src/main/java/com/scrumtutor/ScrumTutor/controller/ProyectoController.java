package com.scrumtutor.ScrumTutor.controller;

import com.scrumtutor.ScrumTutor.controller.dto.ProyectoCreateDTO;
import com.scrumtutor.ScrumTutor.controller.dto.ProyectoDto;
import com.scrumtutor.ScrumTutor.controller.dto.ProyectoUpdateDTO;
import com.scrumtutor.ScrumTutor.model.Usuario;
import com.scrumtutor.ScrumTutor.security.AuthUtils;
import com.scrumtutor.ScrumTutor.service.ProyectoService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/proyectos")
@RequiredArgsConstructor
public class ProyectoController {

    private final ProyectoService proyectoService;
    private final AuthUtils authUtils;

    @GetMapping
    public ResponseEntity<List<ProyectoDto>> listarMios() {
        Usuario me = authUtils.getCurrentUserOrThrow();
        return ResponseEntity.ok(proyectoService.listarDelUsuario(me));
    }

    @PostMapping
    public ResponseEntity<ProyectoDto> crear(@RequestBody ProyectoCreateDTO dto) {
        Usuario me = authUtils.getCurrentUserOrThrow();
        return ResponseEntity.ok(proyectoService.crear(me, dto));
    }

    @GetMapping("/{id}")
    public ResponseEntity<ProyectoDto> getById(@PathVariable Long id) {
        // Cambia a "true" si quieres asegurar que el usuario venga inicializado con JOIN FETCH
        return ResponseEntity.ok(proyectoService.getDtoById(id, false));
    }

    @PutMapping("/{id}")
    public ResponseEntity<ProyectoDto> update(@PathVariable Long id, @RequestBody ProyectoUpdateDTO dto) {
        return ResponseEntity.ok(proyectoService.actualizar(id, dto));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        proyectoService.eliminar(id);
        return ResponseEntity.noContent().build();
    }
}
