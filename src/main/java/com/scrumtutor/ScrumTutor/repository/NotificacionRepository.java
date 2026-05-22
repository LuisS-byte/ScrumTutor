// com.scrumtutor.ScrumTutor.repository.NotificacionRepository
package com.scrumtutor.ScrumTutor.repository;

import com.scrumtutor.ScrumTutor.model.Notificacion;
import com.scrumtutor.ScrumTutor.model.Usuario;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface NotificacionRepository extends JpaRepository<Notificacion, Integer> {
    List<Notificacion> findByUsuarioOrderByFechaCreacionDesc(Usuario usuario);
}
