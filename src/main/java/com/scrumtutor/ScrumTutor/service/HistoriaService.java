// com.scrumtutor.ScrumTutor.service.HistoriaService
package com.scrumtutor.ScrumTutor.service;

import com.scrumtutor.ScrumTutor.controller.dto.*;
import com.scrumtutor.ScrumTutor.model.*;
import com.scrumtutor.ScrumTutor.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class HistoriaService {

  private final ProyectoRepository proyectoRepo;
  private final HistoriaUsuarioRepository historiaRepo;
  private final EstadoHistoriaRepository estadoRepo;
  private final PrioridadHistoriaRepository prioridadRepo;

  /* mapper */
  private HistoriaDto toDto(HistoriaUsuario h) {
    return new HistoriaDto(
        h.getId(),
        h.getProyecto() != null ? h.getProyecto().getId() : null,
        h.getTitulo(),
        h.getDescripcion(),
        h.getPrioridad() != null ? h.getPrioridad().getId() : null,
        h.getPrioridad() != null ? h.getPrioridad().getDescripcion() : null,
        h.getCriteriosAceptacion(),
        h.getEstado() != null ? h.getEstado().getId() : null,
        h.getEstado() != null ? h.getEstado().getDescripcion() : null,
        h.getFechaCreacion()
    );
  }

  /* helpers */
  private Proyecto findProyecto(Long idProyecto) {
    return proyectoRepo.findById(idProyecto)
        .orElseThrow(() -> new RuntimeException("Proyecto no encontrado"));
  }

  private EstadoHistoria findEstado(Integer id) {
    return estadoRepo.findById(id)
        .orElseThrow(() -> new RuntimeException("Estado de historia no encontrado"));
  }

  private PrioridadHistoria findPrioridad(Integer id) {
    return prioridadRepo.findById(id)
        .orElseThrow(() -> new RuntimeException("Prioridad no encontrada"));
  }

  /* use-cases */
  @Transactional
  public HistoriaDto crear(HistoriaCreateDTO dto) {
    Proyecto p = findProyecto(dto.idProyecto());
    EstadoHistoria e = findEstado(dto.idEstado());
    PrioridadHistoria pr = findPrioridad(dto.idPrioridad());

    HistoriaUsuario h = HistoriaUsuario.builder()
        .proyecto(p)
        .titulo(dto.titulo())
        .descripcion(dto.descripcion())
        .prioridad(pr)
        .criteriosAceptacion(dto.criteriosAceptacion())
        .estado(e)
        .build();

    return toDto(historiaRepo.save(h));
  }

  @Transactional(readOnly = true)
  public List<HistoriaDto> listarPorProyecto(Long idProyecto) {
    Proyecto p = findProyecto(idProyecto);
    return historiaRepo.findByProyecto(p).stream().map(this::toDto).toList();
  }

  @Transactional(readOnly = true)
  public HistoriaUsuario getById(Integer id) {
    return historiaRepo.findById(id)
        .orElseThrow(() -> new RuntimeException("Historia no encontrada"));
  }

  @Transactional(readOnly = true)
  public HistoriaDto getDtoById(Integer id) {
    return toDto(getById(id));
  }

  @Transactional
  public HistoriaDto actualizar(Integer id, HistoriaUpdateDTO dto) {
    HistoriaUsuario h = getById(id);

    if (dto.titulo() != null && !dto.titulo().isBlank()) h.setTitulo(dto.titulo());
    if (dto.descripcion() != null) h.setDescripcion(dto.descripcion());
    if (dto.criteriosAceptacion() != null) h.setCriteriosAceptacion(dto.criteriosAceptacion());
    if (dto.idPrioridad() != null) h.setPrioridad(findPrioridad(dto.idPrioridad()));
    if (dto.idEstado() != null) h.setEstado(findEstado(dto.idEstado()));

    return toDto(historiaRepo.save(h));
  }

  @Transactional
  public void eliminar(Integer id) {
    HistoriaUsuario h = getById(id);
    historiaRepo.delete(h);
  }
}
