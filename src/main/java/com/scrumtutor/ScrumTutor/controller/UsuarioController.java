package com.scrumtutor.ScrumTutor.controller;

import com.scrumtutor.ScrumTutor.controller.dto.UsuarioUpdateDTO;
import com.scrumtutor.ScrumTutor.model.Usuario;
import com.scrumtutor.ScrumTutor.service.UsuarioService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/usuarios")
@RequiredArgsConstructor
public class UsuarioController {

  private final UsuarioService usuarioService;

  @GetMapping("/{id}")
  public ResponseEntity<Usuario> get(@PathVariable Long id) {
    return ResponseEntity.ok(usuarioService.getById(id));
  }

  @PutMapping("/{id}")
  public ResponseEntity<Usuario> update(@PathVariable Long id, @RequestBody UsuarioUpdateDTO dto) {
    Usuario u = usuarioService.update(id, dto.nombre(), dto.idRol());
    return ResponseEntity.ok(u);
  }

  @PutMapping("/{id}/activar")
  public ResponseEntity<Void> activar(@PathVariable Long id) {
    usuarioService.activar(id);
    return ResponseEntity.noContent().build();
  }

  @PutMapping("/{id}/desactivar")
  public ResponseEntity<Void> desactivar(@PathVariable Long id) {
    usuarioService.desactivar(id);
    return ResponseEntity.noContent().build();
  }
}
