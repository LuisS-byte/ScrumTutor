// com.scrumtutor.ScrumTutor.repository.SprintRepository
package com.scrumtutor.ScrumTutor.repository;

import com.scrumtutor.ScrumTutor.model.Proyecto;
import com.scrumtutor.ScrumTutor.model.Sprint;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface SprintRepository extends JpaRepository<Sprint, Integer> {
    List<Sprint> findByProyectoOrderByFechaInicioAsc(Proyecto proyecto);
}
