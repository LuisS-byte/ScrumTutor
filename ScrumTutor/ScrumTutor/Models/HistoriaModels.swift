// HistoriaModels.swift
import Foundation

struct Historia: Decodable, Identifiable {
    let id: Int
    let idProyecto: Int?
    let idSprint: Int?
    let titulo: String
    let descripcion: String?
    let idPrioridad: Int?
    let prioridad: String?
    let criteriosAceptacion: String?
    let idEstado: Int?
    let estado: String?
    let fechaCreacion: String?
}

struct CreateHistoriaRequest: Encodable {
    let idProyecto: Int
    let idSprint: Int?
    let titulo: String
    let descripcion: String
    let idPrioridad: Int
    let criteriosAceptacion: String
    let idEstado: Int
}

struct UpdateHistoriaRequest: Encodable {
    let titulo: String
    let descripcion: String
    let idSprint: Int?
    let idPrioridad: Int
    let criteriosAceptacion: String
    let idEstado: Int
}
