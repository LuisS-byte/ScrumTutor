package com.scrumtutor.ScrumTutor.controller;

import com.scrumtutor.ScrumTutor.model.Rol;
import com.scrumtutor.ScrumTutor.model.Usuario;
import com.scrumtutor.ScrumTutor.repository.RolRepository;
import com.scrumtutor.ScrumTutor.repository.UsuarioRepository;
import com.scrumtutor.ScrumTutor.security.JwtUtil;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdTokenVerifier;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.jackson2.JacksonFactory;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Collections;
import java.util.Map;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class GoogleAuthController {

    private final UsuarioRepository usuarioRepository;
    private final RolRepository rolRepository;
    private final JwtUtil jwtUtil;

    @Value("${spring.security.oauth2.client.registration.google.client-id}")
    private String googleClientId;

    @PostMapping("/google")
    public ResponseEntity<?> loginConGoogle(@RequestBody Map<String, String> body) {
        try {
            String idTokenString = body.get("idToken");
            System.out.println(">>> [DEBUG] Token recibido desde Android: " + idTokenString);

            if (idTokenString == null || idTokenString.isBlank()) {
                System.out.println(">>> [ERROR] idToken no recibido o vacío");
                return ResponseEntity.badRequest().body(Map.of("error", "Falta el idToken en la petición"));
            }

            // 1️⃣ Verificar el token con Google
            GoogleIdTokenVerifier verifier = new GoogleIdTokenVerifier.Builder(
                    new NetHttpTransport(),
                    JacksonFactory.getDefaultInstance()
            ).setAudience(Collections.singletonList(googleClientId)).build();

            GoogleIdToken idToken = verifier.verify(idTokenString);
            if (idToken == null) {
                System.out.println(">>> [ERROR] Token inválido o no verificable con el clientId " + googleClientId);
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(Map.of("error", "Token de Google inválido"));
            }

            GoogleIdToken.Payload payload = idToken.getPayload();
            String email = payload.getEmail();
            String nombre = (String) payload.get("name");

            System.out.println(">>> [DEBUG] Token válido de Google:");
            System.out.println(">>> Email: " + email);
            System.out.println(">>> Nombre: " + nombre);

            // 2️⃣ Buscar o crear usuario
            Usuario usuario = usuarioRepository.findByCorreo(email).orElseGet(() -> {
                Rol rol = rolRepository.findByNombre("DESARROLLADOR")
                        .orElseThrow(() -> new RuntimeException("Rol DESARROLLADOR no existe"));
                return usuarioRepository.save(Usuario.builder()
                        .correo(email)
                        .nombre(nombre)
                        .contrasena("GOOGLE")
                        .rol(rol)
                        .activo(true)
                        .build());
            });

            // 3️⃣ Actualizar nombre si cambió
            if (!usuario.getNombre().equals(nombre)) {
                usuario.setNombre(nombre);
                usuarioRepository.save(usuario);
            }

            // 4️⃣ Generar JWT
            String jwt = jwtUtil.generate(usuario.getCorreo(), Map.of(
                    "uid", usuario.getId(),
                    "rol", usuario.getRol().getNombre(),
                    "nombre", usuario.getNombre()
            ));

            System.out.println(">>> [DEBUG] JWT generado correctamente.");

            return ResponseEntity.ok(Map.of(
                    "jwt", jwt,
                    "email", email,
                    "nombre", nombre,
                    "message", "Login con Google OK"
            ));

        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.internalServerError().body(Map.of(
                    "error", "Error procesando token: " + e.getMessage()
            ));
        }
    }
}
