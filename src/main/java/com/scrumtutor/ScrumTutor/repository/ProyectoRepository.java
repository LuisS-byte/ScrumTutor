// com.scrumtutor.ScrumTutor.repository.ProyectoRepository
package com.scrumtutor.ScrumTutor.repository;

import com.scrumtutor.ScrumTutor.model.Proyecto;
import com.scrumtutor.ScrumTutor.model.Usuario;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;
import java.util.Optional;

public interface ProyectoRepository extends JpaRepository<Proyecto, Long> {

    List<Proyecto> findByUsuario(Usuario usuario);

    @Query("""
           select p from Proyecto p
           join fetch p.usuario
           where p.id = :id
           """)
    Optional<Proyecto> findByIdWithUsuario(Long id);
}
