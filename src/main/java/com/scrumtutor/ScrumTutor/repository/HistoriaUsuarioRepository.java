// com.scrumtutor.ScrumTutor.repository.HistoriaUsuarioRepository
package com.scrumtutor.ScrumTutor.repository;

import com.scrumtutor.ScrumTutor.model.HistoriaUsuario;
import com.scrumtutor.ScrumTutor.model.Proyecto;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface HistoriaUsuarioRepository extends JpaRepository<HistoriaUsuario, Integer> {
    List<HistoriaUsuario> findByProyecto(Proyecto proyecto);
}
