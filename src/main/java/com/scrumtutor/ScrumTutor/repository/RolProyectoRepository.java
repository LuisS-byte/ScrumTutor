package com.scrumtutor.ScrumTutor.repository;

import com.scrumtutor.ScrumTutor.model.RolProyecto;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface RolProyectoRepository extends JpaRepository<RolProyecto, Long> {
  Optional<RolProyecto> findByDescripcion(String descripcion);
}
