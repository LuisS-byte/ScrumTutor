package com.scrumtutor.ScrumTutor.security;

import com.scrumtutor.ScrumTutor.model.Rol;
import com.scrumtutor.ScrumTutor.model.Usuario;
import com.scrumtutor.ScrumTutor.repository.RolRepository;
import com.scrumtutor.ScrumTutor.repository.UsuarioRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.oauth2.client.userinfo.DefaultOAuth2UserService;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserRequest;
import org.springframework.security.oauth2.core.OAuth2AuthenticationException;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class CustomOAuth2UserService extends DefaultOAuth2UserService {

    private final UsuarioRepository usuarioRepo;
    private final RolRepository rolRepo;

    @Override
    public OAuth2User loadUser(OAuth2UserRequest req) throws OAuth2AuthenticationException {
        OAuth2User user = super.loadUser(req);

        String email = (String) user.getAttributes().get("email");
        String name  = (String) user.getAttributes().getOrDefault("name", email);

        Usuario u = usuarioRepo.findByCorreo(email).orElseGet(() -> {
            // rol por defecto DESARROLLADOR (asegúrate que exista en BD)
            Rol rol = rolRepo.findByNombre("DESARROLLADOR")
                    .orElseThrow(() -> new RuntimeException("Rol DESARROLLADOR no existe"));
            return Usuario.builder()
                    .nombre(name)
                    .correo(email)
                    .contrasena("GOOGLE")   // no se usa para login
                    .rol(rol)
                    .activo(true)
                    .build();
        });

        // Si ya existe, actualiza solo nombre si viene distinto
        if (!name.equals(u.getNombre())) u.setNombre(name);

        usuarioRepo.save(u);
        return user;
    }
}
