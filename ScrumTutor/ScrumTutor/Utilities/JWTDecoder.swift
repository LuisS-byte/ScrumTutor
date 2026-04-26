// JWTDecoder.swift
// ScrumTutor

import Foundation

enum JWTDecoder {

    // MARK: - Decodifica el payload completo del token
    static func decode(_ token: String) -> [String: Any]? {
        let parts = token.split(separator: ".")
        guard parts.count == 3 else { return nil }

        var base64 = String(parts[1])

        // JWT usa Base64url — hay que convertir a Base64 estándar
        base64 = base64
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")

        // Agregar padding si falta
        let remainder = base64.count % 4
        if remainder != 0 {
            base64 += String(repeating: "=", count: 4 - remainder)
        }

        guard let data = Data(base64Encoded: base64),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
        else { return nil }

        return json
    }

    // MARK: - Obtener el correo del usuario (claim "sub")
    static func getEmail(from token: String) -> String? {
        return decode(token)?["sub"] as? String
    }

    // MARK: - Obtener el ID del usuario (claim "uid")
    static func getUserId(from token: String) -> Int? {
        let payload = decode(token)

        // El backend puede enviarlo como Int o como Double
        if let uid = payload?["uid"] as? Int { return uid }
        if let uid = payload?["uid"] as? Double { return Int(uid) }
        return nil
    }

    // MARK: - Obtener el nombre del usuario (claim "nombre")
    static func getNombre(from token: String) -> String? {
        return decode(token)?["nombre"] as? String
    }

    // MARK: - Obtener el rol global (claim "rol")
    static func getRol(from token: String) -> String? {
        return decode(token)?["rol"] as? String
    }

    // MARK: - Verificar si el token está expirado
    static func isExpired(_ token: String) -> Bool {
        guard let payload = decode(token),
              let exp = payload["exp"] as? Double
        else {
            // Si no se puede decodificar, tratar como expirado (fail-safe)
            return true
        }

        let ahora = Date().timeIntervalSince1970
        return ahora >= exp
    }

    // MARK: - Token válido (existe y no está expirado)
    static func isValid(_ token: String) -> Bool {
        return !isExpired(token)
    }
}
