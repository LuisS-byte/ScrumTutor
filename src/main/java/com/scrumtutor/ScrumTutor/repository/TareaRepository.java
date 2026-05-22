// com.scrumtutor.ScrumTutor.repository.TareaRepository
package com.scrumtutor.ScrumTutor.repository;

import com.scrumtutor.ScrumTutor.model.Sprint;
import com.scrumtutor.ScrumTutor.model.Tarea;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface TareaRepository extends JpaRepository<Tarea, Integer> {
    List<Tarea> findBySprint(Sprint sprint);
}
