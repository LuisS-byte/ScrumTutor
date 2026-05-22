// com.scrumtutor.ScrumTutor.service.NotificacionService
package com.scrumtutor.ScrumTutor.service;

import com.scrumtutor.ScrumTutor.controller.dto.NotificacionCreateDTO;
import com.scrumtutor.ScrumTutor.controller.dto.NotificacionDTO;
import com.scrumtutor.ScrumTutor.model.Notificacion;
import com.scrumtutor.ScrumTutor.model.TipoNotificacion;
import com.scrumtutor.ScrumTutor.model.Usuario;
import com.scrumtutor.ScrumTutor.repository.NotificacionRepository;
import com.scrumtutor.ScrumTutor.repository.TipoNotificacionRepository;
import com.scrumtutor.ScrumTutor.repository.UsuarioRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class NotificacionService {

    private final NotificacionRepository notifRepo;
    private final UsuarioRepository usuarioRepo;
    private final TipoNotificacionRepository tipoRepo;

    /* ------- mapping ------- */
    private NotificacionDTO toDto(Notificacion n) {
        return new NotificacionDTO(
            n.getId(),
            n.getUsuario() != null ? n.getUsuario().getId() : null,
            n.getTipo() != null ? n.getTipo().getId() : null,
            n.getTipo() != null ? n.getTipo().getDescripcion() : null,
            n.getMensaje(),
            n.getLeido(),
            n.getFechaCreacion()
        );
    }

    /* ------- use cases ------- */

    @Transactional
    public NotificacionDTO crear(NotificacionCreateDTO dto) {
        if (dto == null || dto.idUsuario() == null || dto.idTipo() == null || dto.mensaje() == null || dto.mensaje().isBlank()) {
            throw new RuntimeException("idUsuario, idTipo y mensaje son obligatorios");
        }
        Usuario u = usuarioRepo.findById(dto.idUsuario())
                .orElseThrow(() -> new RuntimeException("Usuario no encontrado"));
        if (Boolean.FALSE.equals(u.getActivo())) {
            throw new RuntimeException("Usuario inactivo");
        }
        TipoNotificacion t = tipoRepo.findById(dto.idTipo())
                .orElseThrow(() -> new RuntimeException("Tipo de notificación no encontrado"));

        Notificacion n = Notificacion.builder()
                .usuario(u)
                .tipo(t)
                .mensaje(dto.mensaje().trim())
                .leido(false)
                .build();

        return toDto(notifRepo.save(n));
    }

    @Transactional(readOnly = true)
    public List<NotificacionDTO> listarPorUsuario(Long idUsuario) {
        Usuario u = usuarioRepo.findById(idUsuario)
                .orElseThrow(() -> new RuntimeException("Usuario no encontrado"));
        return notifRepo.findByUsuarioOrderByFechaCreacionDesc(u)
                .stream()
                .map(this::toDto)
                .toList();
    }

    @Transactional
    public void marcarLeida(Integer idNotificacion) {
        Notificacion n = notifRepo.findById(idNotificacion)
                .orElseThrow(() -> new RuntimeException("Notificación no encontrada"));
        if (!Boolean.TRUE.equals(n.getLeido())) {
            n.setLeido(true);
            notifRepo.save(n);
        }
    }

    @Transactional
    public void eliminar(Integer idNotificacion) {
        if (!notifRepo.existsById(idNotificacion)) {
            throw new RuntimeException("Notificación no encontrada");
        }
        notifRepo.deleteById(idNotificacion);
    }
}
