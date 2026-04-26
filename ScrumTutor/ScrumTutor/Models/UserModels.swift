// UserModels.swift
import Foundation

struct Usuario: Decodable, Identifiable {
    let id: Int
    let nombre: String
    let correo: String
    let activo: Bool?
    let rol: RolSistema?
}

struct RolSistema: Decodable, Identifiable {
    let id: Int
    let nombre: String
}

struct UpdateUserRequest: Encodable {
    let nombre: String
    let idRol: Int
}
