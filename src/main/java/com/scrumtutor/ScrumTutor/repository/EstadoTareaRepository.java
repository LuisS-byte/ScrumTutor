// com.scrumtutor.ScrumTutor.repository.EstadoTareaRepository
package com.scrumtutor.ScrumTutor.repository;

import com.scrumtutor.ScrumTutor.model.EstadoTarea;
import org.springframework.data.jpa.repository.JpaRepository;

public interface EstadoTareaRepository extends JpaRepository<EstadoTarea, Integer> {}
