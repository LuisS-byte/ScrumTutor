// com.scrumtutor.ScrumTutor.service.SprintService
package com.scrumtutor.ScrumTutor.service;

import com.scrumtutor.ScrumTutor.controller.dto.SprintCreateDTO;
import com.scrumtutor.ScrumTutor.controller.dto.SprintDto;
import com.scrumtutor.ScrumTutor.controller.dto.SprintUpdateDTO;
import com.scrumtutor.ScrumTutor.model.EstadoSprint;
import com.scrumtutor.ScrumTutor.model.Proyecto;
import com.scrumtutor.ScrumTutor.model.Sprint;
import com.scrumtutor.ScrumTutor.repository.EstadoSprintRepository;
import com.scrumtutor.ScrumTutor.repository.ProyectoRepository;
import com.scrumtutor.ScrumTutor.repository.SprintRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class SprintService {

    private final SprintRepository sprintRepo;
    private final ProyectoRepository proyectoRepo;
    private final EstadoSprintRepository estadoRepo;

    /* ---- mapper ---- */
    private SprintDto toDto(Sprint s) {
        return new SprintDto(
                s.getId(),
                s.getProyecto() != null ? s.getProyecto().getId() : null,
                s.getNombre(),
                s.getObjetivo(),
                s.getFechaInicio(),
                s.getFechaFin(),
                s.getEstado() != null ? s.getEstado().getId() : null,
                s.getEstado() != null ? s.getEstado().getDescripcion() : null
        );
    }

    /* ---- helpers ---- */
    private Proyecto findProyecto(Long idProyecto) {
        return proyectoRepo.findById(idProyecto)
                .orElseThrow(() -> new RuntimeException("Proyecto no encontrado"));
    }

    private EstadoSprint findEstado(Integer idEstado) {
        return estadoRepo.findById(idEstado)
                .orElseThrow(() -> new RuntimeException("Estado de sprint no encontrado"));
    }

    private Sprint findSprint(Integer id) {
        return sprintRepo.findById(id)
                .orElseThrow(() -> new RuntimeException("Sprint no encontrado"));
    }

    /* ---- use cases ---- */

    @Transactional
    public SprintDto crear(SprintCreateDTO dto) {
        Proyecto proyecto = findProyecto(dto.idProyecto());
        EstadoSprint estado = findEstado(dto.idEstado());

        Sprint s = Sprint.builder()
                .proyecto(proyecto)
                .nombre(dto.nombre())
                .objetivo(dto.objetivo())
                .fechaInicio(dto.fechaInicio())
                .fechaFin(dto.fechaFin())
                .estado(estado)
                .build();

        return toDto(sprintRepo.save(s));
    }

    @Transactional(readOnly = true)
    public List<SprintDto> listarPorProyecto(Long idProyecto) {
        Proyecto p = findProyecto(idProyecto);
        return sprintRepo.findByProyectoOrderByFechaInicioAsc(p)
                .stream().map(this::toDto).toList();
    }

    @Transactional(readOnly = true)
    public SprintDto detalle(Integer idSprint) {
        return toDto(findSprint(idSprint));
    }

    @Transactional
    public SprintDto actualizar(Integer idSprint, SprintUpdateDTO dto) {
        Sprint s = findSprint(idSprint);

        if (dto.nombre() != null && !dto.nombre().isBlank()) s.setNombre(dto.nombre());
        if (dto.objetivo() != null) s.setObjetivo(dto.objetivo());
        if (dto.fechaInicio() != null) s.setFechaInicio(dto.fechaInicio());
        if (dto.fechaFin() != null) s.setFechaFin(dto.fechaFin());
        if (dto.idEstado() != null) s.setEstado(findEstado(dto.idEstado()));

        return toDto(sprintRepo.save(s));
    }

    @Transactional
    public void eliminar(Integer idSprint) {
        Sprint s = findSprint(idSprint);
        sprintRepo.delete(s);
    }
}
