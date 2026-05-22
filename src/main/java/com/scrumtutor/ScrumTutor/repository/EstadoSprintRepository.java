// com.scrumtutor.ScrumTutor.repository.EstadoSprintRepository
package com.scrumtutor.ScrumTutor.repository;

import com.scrumtutor.ScrumTutor.model.EstadoSprint;
import org.springframework.data.jpa.repository.JpaRepository;

public interface EstadoSprintRepository extends JpaRepository<EstadoSprint, Integer> {}
