package com.scrumtutor.ScrumTutor.security;

import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpHeaders;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.List;

@Component
public class JwtAuthFilter extends OncePerRequestFilter {

    private final byte[] secret;

    public JwtAuthFilter(@Value("${app.jwt.secret}") String secret) {
        this.secret = secret.getBytes(StandardCharsets.UTF_8);
    }

    @Override
    protected void doFilterInternal(HttpServletRequest req, HttpServletResponse res, FilterChain chain)
            throws ServletException, IOException {

        String path = req.getRequestURI();
        if (path.startsWith("/oauth2") || path.startsWith("/login")) {
            chain.doFilter(req, res);
            return;
        }

        String auth = req.getHeader(HttpHeaders.AUTHORIZATION);
        if (auth != null && auth.startsWith("Bearer ")) {
            String token = auth.substring(7);
            try {
                var parser = Jwts.parser()
                        .verifyWith(Keys.hmacShaKeyFor(secret))
                        .build();

                var claims = parser.parseSignedClaims(token).getPayload();

                String subject = claims.getSubject();
                String rol = (String) claims.get("rol");

                if (subject != null) {
                    var authTok = new UsernamePasswordAuthenticationToken(
                            subject, null, List.of(new SimpleGrantedAuthority("ROLE_" + rol))
                    );
                    SecurityContextHolder.getContext().setAuthentication(authTok);
                }
                System.out.println("✅ JWT recibido de Android: " + subject);

            } catch (io.jsonwebtoken.ExpiredJwtException e) {
                System.out.println("⚠️ Token expirado: " + e.getMessage());
                SecurityContextHolder.clearContext(); // limpia sesión inválida

            } catch (io.jsonwebtoken.JwtException e) {
                System.out.println("⚠️ Token inválido: " + e.getMessage());
                SecurityContextHolder.clearContext();

            } catch (Exception e) {
                System.out.println("⚠️ Error procesando JWT: " + e.getMessage());
                SecurityContextHolder.clearContext();
            }

        }
        chain.doFilter(req, res);
    }
}
