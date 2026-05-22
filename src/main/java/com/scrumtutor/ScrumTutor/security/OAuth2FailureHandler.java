package com.scrumtutor.ScrumTutor.security;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.authentication.AuthenticationFailureHandler;
import org.springframework.stereotype.Component;

import jakarta.servlet.http.*;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Component
public class OAuth2FailureHandler implements AuthenticationFailureHandler {

    private static final Logger log = LoggerFactory.getLogger(OAuth2FailureHandler.class);

    @Value("${app.frontend.url}")
    private String frontendUrl;

    @Override
    public void onAuthenticationFailure(HttpServletRequest request,
                                        HttpServletResponse response,
                                        AuthenticationException exception) throws IOException {
        String msg = exception.getMessage();
        log.error("OAuth2 failure: {}", msg, exception); // <--- Verás el stacktrace en consola
        String url = frontendUrl + "/oauth2/failure?error=" +
                URLEncoder.encode(msg == null ? "unknown" : msg, StandardCharsets.UTF_8);
        response.sendRedirect(url);
    }
}
