// ProjectModels.swift
import Foundation

struct Proyecto: Decodable, Identifiable {
    let id: Int
    let nombre: String
    let descripcion: String?
    let fechaInicio: String?
    let fechaFin: String?
    let idUsuario: Int?
}

struct CreateProjectRequest: Encodable {
    let nombre: String
    let descripcion: String
    let fechaInicio: String
    let fechaFin: String
}

struct UpdateProjectRequest: Encodable {
    let nombre: String
    let descripcion: String
    let fechaInicio: String
    let fechaFin: String
}
