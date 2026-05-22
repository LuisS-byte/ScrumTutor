// com.scrumtutor.ScrumTutor.service.ComentarioService
package com.scrumtutor.ScrumTutor.service;

import com.scrumtutor.ScrumTutor.controller.dto.ComentarioCreateDTO;
import com.scrumtutor.ScrumTutor.controller.dto.ComentarioDTO;
import com.scrumtutor.ScrumTutor.model.ComentarioTarea;
import com.scrumtutor.ScrumTutor.model.Tarea;
import com.scrumtutor.ScrumTutor.model.Usuario;
import com.scrumtutor.ScrumTutor.repository.ComentarioTareaRepository;
import com.scrumtutor.ScrumTutor.repository.TareaRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ComentarioService {

    private final ComentarioTareaRepository comentarioRepo;
    private final TareaRepository tareaRepo;

    private ComentarioDTO toDto(ComentarioTarea c) {
        return new ComentarioDTO(
            c.getId(),
            c.getTarea().getId(),
            c.getUsuario().getId(),
            c.getUsuario().getNombre(),
            c.getContenido(),
            c.getFechaCreacion()
        );
    }

    @Transactional(readOnly = true)
    public List<ComentarioDTO> listarPorTarea(Integer idTarea) {
        Tarea t = tareaRepo.findById(idTarea)
            .orElseThrow(() -> new RuntimeException("Tarea no encontrada"));
        return comentarioRepo.findByTareaOrderByFechaCreacionAsc(t)
                .stream().map(this::toDto).toList();
    }

    @Transactional
    public ComentarioDTO agregar(Integer idTarea, Usuario autor, ComentarioCreateDTO dto) {
        if (dto == null || dto.contenido() == null || dto.contenido().isBlank()) {
            throw new RuntimeException("El contenido del comentario es obligatorio");
        }
        if (Boolean.FALSE.equals(autor.getActivo())) {
            throw new RuntimeException("Usuario inactivo, no puede comentar");
        }
        Tarea t = tareaRepo.findById(idTarea)
            .orElseThrow(() -> new RuntimeException("Tarea no encontrada"));

        ComentarioTarea c = ComentarioTarea.builder()
                .tarea(t)
                .usuario(autor)
                .contenido(dto.contenido().trim())
                .build();

        return toDto(comentarioRepo.save(c));
    }
}
