// com.scrumtutor.ScrumTutor.repository.ComentarioTareaRepository
package com.scrumtutor.ScrumTutor.repository;

import com.scrumtutor.ScrumTutor.model.ComentarioTarea;
import com.scrumtutor.ScrumTutor.model.Tarea;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ComentarioTareaRepository extends JpaRepository<ComentarioTarea, Integer> {
    List<ComentarioTarea> findByTareaOrderByFechaCreacionAsc(Tarea tarea);
}
