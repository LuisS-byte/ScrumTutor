// com.scrumtutor.ScrumTutor.service.ProyectoMiembroService
package com.scrumtutor.ScrumTutor.service;

import com.scrumtutor.ScrumTutor.controller.dto.ProyectoMiembroCreateDTO;
import com.scrumtutor.ScrumTutor.controller.dto.ProyectoMiembroDto;
import com.scrumtutor.ScrumTutor.model.*;
import com.scrumtutor.ScrumTutor.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ProyectoMiembroService {

  private final ProyectoMiembroRepository miembroRepo;
  private final ProyectoRepository proyectoRepo;
  private final UsuarioRepository usuarioRepo;
  private final RolProyectoRepository rolProyectoRepo;

  /* mapper a DTO para evitar problemas de LAZY/Jackson */
  private ProyectoMiembroDto toDto(ProyectoMiembro m) {
    return new ProyectoMiembroDto(
        m.getId(),                               // idMiembro
        m.getProyecto() != null ? m.getProyecto().getId() : null,
        m.getUsuario() != null ? m.getUsuario().getId() : null,
        m.getRolProyecto() != null ? m.getRolProyecto().getId() : null,
        m.getRolProyecto() != null ? m.getRolProyecto().getDescripcion() : null,
        m.getUsuario() != null ? m.getUsuario().getNombre() : null
    );
  }

  @Transactional(readOnly = true)
  public List<ProyectoMiembroDto> listar(Long idProyecto) {
    Proyecto p = proyectoRepo.findById(idProyecto)
        .orElseThrow(() -> new RuntimeException("Proyecto no encontrado"));
    return miembroRepo.findByProyecto(p).stream().map(this::toDto).toList();
  }

  @Transactional
  public ProyectoMiembroDto agregar(Long idProyecto, ProyectoMiembroCreateDTO dto) {
    Proyecto p = proyectoRepo.findById(idProyecto)
        .orElseThrow(() -> new RuntimeException("Proyecto no encontrado"));

    Usuario u = usuarioRepo.findById(dto.idUsuario())
        .orElseThrow(() -> new RuntimeException("Usuario no encontrado"));
    if (Boolean.FALSE.equals(u.getActivo())) {
      throw new RuntimeException("Usuario inactivo");
    }

    RolProyecto rp = rolProyectoRepo.findById(dto.idRolProyecto())
        .orElseThrow(() -> new RuntimeException("Rol de proyecto no encontrado"));

    ProyectoMiembro m = ProyectoMiembro.builder()
        .proyecto(p)
        .usuario(u)
        .rolProyecto(rp)
        .build();

    return toDto(miembroRepo.save(m));
  }

  @Transactional
  public void remover(Long idMiembro) {
    if (!miembroRepo.existsById(idMiembro)) {
      throw new RuntimeException("Miembro no existe");
    }
    miembroRepo.deleteById(idMiembro);
  }

  @Transactional
public ProyectoMiembroDto actualizarInvitacion(Long idMiembro, Boolean invitacion) {
    ProyectoMiembro miembro = miembroRepo.findById(idMiembro)
            .orElseThrow(() -> new RuntimeException("Miembro no encontrado"));

    miembro.setInvitacion(invitacion);
    ProyectoMiembro actualizado = miembroRepo.save(miembro);
    return toDto(actualizado);
}

}
