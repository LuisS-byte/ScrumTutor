package com.scrumtutor.ScrumTutor.service;

import com.scrumtutor.ScrumTutor.controller.dto.ProyectoCreateDTO;
import com.scrumtutor.ScrumTutor.controller.dto.ProyectoDto;
import com.scrumtutor.ScrumTutor.controller.dto.ProyectoUpdateDTO;
import com.scrumtutor.ScrumTutor.model.Proyecto;
import com.scrumtutor.ScrumTutor.model.Usuario;
import com.scrumtutor.ScrumTutor.repository.ProyectoRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ProyectoService {

  private final ProyectoRepository proyectoRepo;

  /* ---------- Mapping ---------- */
  public ProyectoDto toDto(Proyecto p) {
    Long idOwner = (p.getUsuario() != null) ? p.getUsuario().getId() : null;
    return new ProyectoDto(
        p.getId(),
        p.getNombre(),
        p.getDescripcion(),
        p.getFechaInicio(),
        p.getFechaFin(),
        idOwner
    );
  }

  /* ---------- Queries ---------- */

  @Transactional(readOnly = true)
  public List<ProyectoDto> listarDelUsuario(Usuario owner) {
    return proyectoRepo.findByUsuario(owner)
        .stream().map(this::toDto).toList();
  }

  @Transactional
  public ProyectoDto crear(Usuario owner, ProyectoCreateDTO dto) {
    Proyecto p = Proyecto.builder()
        .usuario(owner)
        .nombre(dto.nombre())
        .descripcion(dto.descripcion())
        .fechaInicio(dto.fechaInicio())
        .fechaFin(dto.fechaFin())
        .build();
    return toDto(proyectoRepo.save(p));
  }

  @Transactional(readOnly = true)
  public Proyecto getByIdOrThrow(Long id) {
    return proyectoRepo.findById(id)
        .orElseThrow(() -> new RuntimeException("Proyecto no encontrado"));
  }

  @Transactional(readOnly = true)
  public ProyectoDto getDtoById(Long id, boolean withUsuario) {
    Proyecto p = withUsuario
        ? proyectoRepo.findByIdWithUsuario(id)
            .orElseThrow(() -> new RuntimeException("Proyecto no encontrado"))
        : getByIdOrThrow(id);
    return toDto(p);
  }

  @Transactional
  public ProyectoDto actualizar(Long id, ProyectoUpdateDTO dto) {
    Proyecto p = getByIdOrThrow(id);

    if (dto.nombre() != null && !dto.nombre().isBlank()) p.setNombre(dto.nombre());
    if (dto.descripcion() != null) p.setDescripcion(dto.descripcion());
    if (dto.fechaInicio() != null) p.setFechaInicio(dto.fechaInicio());
    if (dto.fechaFin() != null) p.setFechaFin(dto.fechaFin());

    return toDto(proyectoRepo.save(p));
  }

  @Transactional
  public void eliminar(Long id) {
    Proyecto p = getByIdOrThrow(id);
    proyectoRepo.delete(p);
  }
}
