// com.scrumtutor.ScrumTutor.controller.ProyectoMiembroController
package com.scrumtutor.ScrumTutor.controller;

import com.scrumtutor.ScrumTutor.controller.dto.ProyectoMiembroCreateDTO;
import com.scrumtutor.ScrumTutor.controller.dto.ProyectoMiembroDto;
import com.scrumtutor.ScrumTutor.controller.dto.ProyectoMiembroInvitacionDTO;
import com.scrumtutor.ScrumTutor.service.ProyectoMiembroService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/proyectos/{idProyecto}/miembros")
@RequiredArgsConstructor
public class ProyectoMiembroController {

  private final ProyectoMiembroService miembroService;

@PutMapping("/{idMiembro}/invitacion")
public ResponseEntity<ProyectoMiembroDto> actualizarInvitacion(
        @PathVariable Long idProyecto,
        @PathVariable Long idMiembro,
        @RequestBody ProyectoMiembroInvitacionDTO dto) {

    ProyectoMiembroDto actualizado = miembroService.actualizarInvitacion(idMiembro, dto.invitacion());
    return ResponseEntity.ok(actualizado);
}


  @GetMapping
  public ResponseEntity<List<ProyectoMiembroDto>> listar(@PathVariable Long idProyecto) {
    return ResponseEntity.ok(miembroService.listar(idProyecto));
  }

  @PostMapping
  public ResponseEntity<ProyectoMiembroDto> agregar(@PathVariable Long idProyecto,
                                                    @RequestBody ProyectoMiembroCreateDTO dto) {
    return ResponseEntity.ok(miembroService.agregar(idProyecto, dto));
  }

  @DeleteMapping("/{idMiembro}")
  public ResponseEntity<Void> remover(@PathVariable Long idProyecto, @PathVariable Long idMiembro) {
    miembroService.remover(idMiembro);
    return ResponseEntity.noContent().build();
  }
}
