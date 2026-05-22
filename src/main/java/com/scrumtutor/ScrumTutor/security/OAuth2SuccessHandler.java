package com.scrumtutor.ScrumTutor.security;

import com.scrumtutor.ScrumTutor.model.Rol;
import com.scrumtutor.ScrumTutor.model.Usuario;
import com.scrumtutor.ScrumTutor.repository.RolRepository;
import com.scrumtutor.ScrumTutor.repository.UsuarioRepository;
import jakarta.servlet.http.*;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.Authentication;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Component;
import org.springframework.web.util.UriComponentsBuilder;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Map;

@Component
@RequiredArgsConstructor
public class OAuth2SuccessHandler implements org.springframework.security.web.authentication.AuthenticationSuccessHandler {

    private final JwtUtil jwtUtil;
    private final UsuarioRepository usuarioRepo;
    private final RolRepository rolRepo;

    @Value("${app.frontend.url}")
    private String frontendUrl;

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request,
                                        HttpServletResponse response,
                                        Authentication authentication) throws IOException {

        OAuth2User oauth = (OAuth2User) authentication.getPrincipal();
        String email = (String) oauth.getAttributes().get("email");
        String name  = (String) oauth.getAttributes().getOrDefault("name", email);

        if (email == null || email.isBlank()) {
            response.sendRedirect(frontendUrl + "/oauth2/failure?error=" +
                    URLEncoder.encode("missing_email_scope", StandardCharsets.UTF_8));
            return;
        }

        // Busca o crea (rol por defecto: DESARROLLADOR)
        Usuario u = usuarioRepo.findByCorreo(email).orElseGet(() -> {
            Rol rol = rolRepo.findByNombre("DESARROLLADOR")
                    .orElseThrow(() -> new RuntimeException("Rol DESARROLLADOR no existe"));
            return usuarioRepo.save(Usuario.builder()
                    .nombre(name != null ? name : email)
                    .correo(email)
                    .contrasena("GOOGLE")
                    .rol(rol)
                    .activo(true)
                    .build());
        });

        // Refresca nombre por si cambió en Google
        if (name != null && !name.equals(u.getNombre())) {
            u.setNombre(name);
            usuarioRepo.save(u);
        }

        String token = jwtUtil.generate(u.getCorreo(), Map.of(
                "uid", u.getId(),
                "rol", u.getRol().getNombre(),
                "nombre", u.getNombre()
        ));

        String redirect = UriComponentsBuilder
                .fromUriString(frontendUrl + "/oauth2/success")
                .queryParam("token", token)
                .build().toUriString();

        response.sendRedirect(redirect);
    }
}
