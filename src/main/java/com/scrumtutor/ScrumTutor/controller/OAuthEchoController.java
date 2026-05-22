package com.scrumtutor.ScrumTutor.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
public class OAuthEchoController {

    // Aquí aterriza tu SuccessHandler: .../oauth2/success?token=xxx
    @GetMapping("/oauth2/success")
    public ResponseEntity<?> success(@RequestParam String token) {
        return ResponseEntity.ok(Map.of(
            "message", "Login con Google OK. Usa este token como Bearer en tus requests.",
            "token", token
        ));
    }

    @GetMapping("/oauth2/failure")
    public ResponseEntity<?> failure(@RequestParam(required = false) String error) {
        return ResponseEntity.badRequest().body(Map.of(
            "message", "Fallo al autenticar con Google",
            "error", error == null ? "unknown" : error
        ));
    }
}
