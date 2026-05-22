// com.scrumtutor.ScrumTutor.service.TareaService
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
public class TareaService {

  private final TareaRepository tareaRepo;
  private final SprintRepository sprintRepo;
  private final EstadoTareaRepository estadoRepo;
  private final UsuarioRepository usuarioRepo;
  private final HistoriaUsuarioRepository historiaRepo;

  /* ---- mapper ---- */
  private TareaDto toDto(Tarea t) {
    return new TareaDto(
        t.getId(),
        t.getSprint() != null ? t.getSprint().getId() : null,
        t.getHistoria() != null ? t.getHistoria().getId() : null,
        t.getTitulo(),
        t.getDescripcion(),
        t.getEstado() != null ? t.getEstado().getId() : null,
        t.getEstado() != null ? t.getEstado().getDescripcion() : null,
        t.getAsignadoA() != null ? t.getAsignadoA().getId() : null,
        t.getAsignadoA() != null ? t.getAsignadoA().getNombre() : null,
        t.getFechaLimite(),
        t.getFechaCreacion()
    );
  }

  /* ---- helpers ---- */
  private Sprint findSprint(Integer id) {
    return sprintRepo.findById(id)
        .orElseThrow(() -> new RuntimeException("Sprint no encontrado"));
  }

  private EstadoTarea findEstado(Integer id) {
    return estadoRepo.findById(id)
        .orElseThrow(() -> new RuntimeException("Estado de tarea no encontrado"));
  }

  private Usuario findUsuario(Long id) {
    return usuarioRepo.findById(id)
        .orElseThrow(() -> new RuntimeException("Usuario no encontrado"));
  }

  private HistoriaUsuario findHistoria(Integer id) {
    return historiaRepo.findById(id)
        .orElseThrow(() -> new RuntimeException("Historia de usuario no encontrada"));
  }

  private Tarea getById(Integer id) {
    return tareaRepo.findById(id)
        .orElseThrow(() -> new RuntimeException("Tarea no encontrada"));
  }

  /* ---- use-cases ---- */

  @Transactional
  public TareaDto crear(TareaCreateDTO dto) {
    Sprint sprint = findSprint(dto.idSprint());
    EstadoTarea estado = findEstado(dto.idEstado());

    Tarea t = Tarea.builder()
        .sprint(sprint)
        .titulo(dto.titulo())
        .descripcion(dto.descripcion())
        .estado(estado)
        .fechaLimite(dto.fechaLimite())
        .build();

    if (dto.idHistoria() != null) {
      t.setHistoria(findHistoria(dto.idHistoria()));
    }
    if (dto.idAsignadoA() != null) {
      t.setAsignadoA(findUsuario(dto.idAsignadoA()));
    }
    return toDto(tareaRepo.save(t));
  }

  @Transactional(readOnly = true)
  public List<TareaDto> listarPorSprint(Integer idSprint) {
    Sprint s = findSprint(idSprint);
    return tareaRepo.findBySprint(s).stream().map(this::toDto).toList();
  }

  @Transactional(readOnly = true)
  public TareaDto detalle(Integer idTarea) {
    return toDto(getById(idTarea));
  }

  @Transactional
  public TareaDto actualizar(Integer idTarea, TareaUpdateDTO dto) {
    Tarea t = getById(idTarea);

    if (dto.titulo() != null && !dto.titulo().isBlank()) t.setTitulo(dto.titulo());
    if (dto.descripcion() != null) t.setDescripcion(dto.descripcion());
    if (dto.idEstado() != null) t.setEstado(findEstado(dto.idEstado()));
    if (dto.fechaLimite() != null) t.setFechaLimite(dto.fechaLimite());
    if (dto.idHistoria() != null) t.setHistoria(findHistoria(dto.idHistoria()));
    if (dto.idAsignadoA() != null) t.setAsignadoA(findUsuario(dto.idAsignadoA()));

    return toDto(tareaRepo.save(t));
  }

  @Transactional
  public TareaDto asignarUsuario(Integer idTarea, Long idUsuario) {
    Tarea t = getById(idTarea);
    Usuario u = findUsuario(idUsuario);
    if (Boolean.FALSE.equals(u.getActivo())) {
      throw new RuntimeException("No se puede asignar: el usuario está inactivo");
    }
    t.setAsignadoA(u);
    return toDto(tareaRepo.save(t));
  }

  @Transactional
  public void eliminar(Integer idTarea) {
    Tarea t = getById(idTarea);
    tareaRepo.delete(t);
  }
}
