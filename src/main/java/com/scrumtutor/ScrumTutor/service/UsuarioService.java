package com.scrumtutor.ScrumTutor.service;

import com.scrumtutor.ScrumTutor.model.Rol;
import com.scrumtutor.ScrumTutor.model.Usuario;
import com.scrumtutor.ScrumTutor.repository.RolRepository;
import com.scrumtutor.ScrumTutor.repository.UsuarioRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class UsuarioService {

  private final UsuarioRepository usuarioRepo;
  private final RolRepository rolRepo;

  @Transactional(readOnly = true)
    public Usuario getById(Long id) {
        return usuarioRepo.findById(id)
            .orElseThrow(() -> new RuntimeException("Usuario no encontrado"));
    }

 @Transactional
    public Usuario update(Long id, String nuevoNombre, Long idRol) {
        Usuario u = getById(id);

        if (nuevoNombre != null && !nuevoNombre.isBlank()) {
            u.setNombre(nuevoNombre);
        }
        if (idRol != null) {
            Rol r = rolRepo.findById(idRol)
                .orElseThrow(() -> new RuntimeException("Rol no existe"));
            u.setRol(r);
        }
        return usuarioRepo.save(u);
    }

  @Transactional
  public void activar(Long id) {
    Usuario u = getById(id);
    u.setActivo(true);
    usuarioRepo.save(u);
  }

  @Transactional
  public void desactivar(Long id) {
    Usuario u = getById(id);
    u.setActivo(false);
    usuarioRepo.save(u);
  }
}
