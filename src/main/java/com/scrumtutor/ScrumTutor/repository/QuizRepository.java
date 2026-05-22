// com.scrumtutor.ScrumTutor.repository.QuizRepository
package com.scrumtutor.ScrumTutor.repository;

import com.scrumtutor.ScrumTutor.model.Quiz;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface QuizRepository extends JpaRepository<Quiz, Integer> {

    // Carga el quiz con sus preguntas
    @EntityGraph(attributePaths = "preguntas")
    Optional<Quiz> findById(Integer id);
}
