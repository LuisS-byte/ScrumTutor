package com.scrumtutor.ScrumTutor.security;

import com.scrumtutor.ScrumTutor.model.Usuario;
import com.scrumtutor.ScrumTutor.repository.UsuarioRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class AuthUtils {
  private final UsuarioRepository usuarioRepo;

  public Usuario getCurrentUserOrThrow() {
    Authentication auth = SecurityContextHolder.getContext().getAuthentication();
    if (auth == null || auth.getName() == null) System.out.println("➡️ Usuario actual en contexto: " + auth.getName());


    return usuarioRepo.findByCorreo(auth.getName())
        .orElseThrow(() -> new RuntimeException("Usuario no encontrado por correo: " + auth.getName()));

  }
}
