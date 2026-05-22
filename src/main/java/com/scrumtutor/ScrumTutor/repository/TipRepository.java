// com.scrumtutor.ScrumTutor.repository.TipRepository
package com.scrumtutor.ScrumTutor.repository;

import com.scrumtutor.ScrumTutor.model.Tip;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface TipRepository extends JpaRepository<Tip, Integer> {
    List<Tip> findBySeccionIgnoreCase(String seccion);
}
