// com.scrumtutor.ScrumTutor.controller.NotificacionController
package com.scrumtutor.ScrumTutor.controller;

import com.scrumtutor.ScrumTutor.controller.dto.NotificacionCreateDTO;
import com.scrumtutor.ScrumTutor.controller.dto.NotificacionDTO;
import com.scrumtutor.ScrumTutor.service.NotificacionService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.util.UriComponentsBuilder;

import java.net.URI;
import java.util.List;

@RestController
@RequestMapping("/api/notificaciones")
@RequiredArgsConstructor
public class NotificacionController {

    private final NotificacionService notifService;

    // POST /api/notificaciones - Crear notificación
    @PostMapping
    public ResponseEntity<NotificacionDTO> crear(@RequestBody NotificacionCreateDTO dto,
                                                 UriComponentsBuilder uri) {
        NotificacionDTO creada = notifService.crear(dto);
        URI loc = uri.path("/api/notificaciones/{id}").buildAndExpand(creada.id()).toUri();
        return ResponseEntity.created(loc).body(creada);
    }

    // GET /api/notificaciones/{idUsuario} - Listar por usuario
    @GetMapping("/{idUsuario}")
    public ResponseEntity<List<NotificacionDTO>> listar(@PathVariable Long idUsuario) {
        return ResponseEntity.ok(notifService.listarPorUsuario(idUsuario));
    }

    // PUT /api/notificaciones/{idNotificacion}/leer - Marcar como leída
    @PutMapping("/{idNotificacion}/leer")
    public ResponseEntity<Void> marcarLeida(@PathVariable Integer idNotificacion) {
        notifService.marcarLeida(idNotificacion);
        return ResponseEntity.noContent().build();
    }

    // DELETE /api/notificaciones/{idNotificacion} - Eliminar
    @DeleteMapping("/{idNotificacion}")
    public ResponseEntity<Void> eliminar(@PathVariable Integer idNotificacion) {
        notifService.eliminar(idNotificacion);
        return ResponseEntity.noContent().build();
    }
}
