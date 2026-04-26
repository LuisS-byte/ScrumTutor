// AuthModels.swift
import Foundation

struct LoginRequest: Encodable {
    let correo: String
    let contrasena: String
}

struct RegisterRequest: Encodable {
    let nombre: String
    let correo: String
    let contrasena: String
}

struct GoogleAuthRequest: Encodable {
    let idToken: String
}

struct AuthResponse: Decodable {
    let jwt: String
    let email: String?
    let nombre: String?
    let rol: String?
    let message: String?
}
