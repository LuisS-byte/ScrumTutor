// SprintModels.swift
import Foundation

struct Sprint: Decodable, Identifiable {
    let id: Int
    let idProyecto: Int?
    let nombre: String
    let objetivo: String?
    let fechaInicio: String?
    let fechaFin: String?
    let idEstado: Int?
    let estadoDescripcion: String?
}

struct CreateSprintRequest: Encodable {
    let idProyecto: Int
    let nombre: String
    let objetivo: String
    let fechaInicio: String
    let fechaFin: String
    let idEstado: Int
}

struct UpdateSprintRequest: Encodable {
    let nombre: String
    let objetivo: String
    let fechaInicio: String
    let fechaFin: String
    let idEstado: Int
}
