// com.scrumtutor.ScrumTutor.service.TipService
package com.scrumtutor.ScrumTutor.service;

import com.scrumtutor.ScrumTutor.controller.dto.TipCreateDTO;
import com.scrumtutor.ScrumTutor.controller.dto.TipDTO;
import com.scrumtutor.ScrumTutor.model.Tip;
import com.scrumtutor.ScrumTutor.repository.TipRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class TipService {

    private final TipRepository tipRepo;

    private TipDTO toDto(Tip t) {
        return new TipDTO(t.getId(), t.getSeccion(), t.getMensaje());
    }

    @Transactional(readOnly = true)
    public List<TipDTO> listarTodos() {
        return tipRepo.findAll().stream().map(this::toDto).toList();
    }

    @Transactional(readOnly = true)
    public List<TipDTO> listarPorSeccion(String seccion) {
        return tipRepo.findBySeccionIgnoreCase(seccion).stream().map(this::toDto).toList();
    }

    @Transactional
    public TipDTO crear(TipCreateDTO dto) {
        if (dto == null || dto.seccion() == null || dto.seccion().isBlank()
                || dto.mensaje() == null || dto.mensaje().isBlank()) {
            throw new RuntimeException("Sección y mensaje son obligatorios");
        }
        Tip t = Tip.builder()
                .seccion(dto.seccion().trim())
                .mensaje(dto.mensaje().trim())
                .build();
        return toDto(tipRepo.save(t));
    }
}
