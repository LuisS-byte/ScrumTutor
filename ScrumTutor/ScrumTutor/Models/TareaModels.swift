// TareaModels.swift
import Foundation

struct Tarea: Decodable, Identifiable {
    let id: Int
    let idSprint: Int?
    let idHistoria: Int?
    let titulo: String
    let descripcion: String?
    let idEstado: Int?
    let estado: String?
    let idAsignadoA: Int?
    let asignadoANombre: String?
    let fechaLimite: String?
    let fechaCreacion: String?
}

struct CreateTareaRequest: Encodable {
    let idSprint: Int
    let idHistoria: Int?
    let titulo: String
    let descripcion: String
    let idEstado: Int
    let idAsignadoA: Int?
    let fechaLimite: String?
}

struct UpdateTareaRequest: Encodable {
    let titulo: String
    let descripcion: String
    let idEstado: Int
    let idAsignadoA: Int?
    let fechaLimite: String?
}

struct AsignarTareaRequest: Encodable {
    let idUsuario: Int
}
