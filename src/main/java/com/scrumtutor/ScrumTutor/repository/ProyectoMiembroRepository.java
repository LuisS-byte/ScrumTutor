package com.scrumtutor.ScrumTutor.repository;

import com.scrumtutor.ScrumTutor.model.ProyectoMiembro;
import com.scrumtutor.ScrumTutor.model.Proyecto;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ProyectoMiembroRepository extends JpaRepository<ProyectoMiembro, Long> {
  List<ProyectoMiembro> findByProyecto(Proyecto proyecto);
}
