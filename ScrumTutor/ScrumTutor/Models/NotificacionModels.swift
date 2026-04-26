// NotificacionModels.swift
import Foundation

struct Notificacion: Decodable, Identifiable {
    let id: Int
    let idUsuario: Int?
    let idTipo: Int?
    let tipo: String?
    let idProyecto: Int?
    let mensaje: String?
    let leido: Bool?
    let fechaCreacion: String?
}

struct CreateNotificacionRequest: Encodable {
    let idUsuario: Int
    let idTipo: Int
    let idProyecto: Int?
    let mensaje: String
}
