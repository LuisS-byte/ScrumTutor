// ComentarioModels.swift
import Foundation

struct Comentario: Decodable, Identifiable {
    let id: Int
    let idTarea: Int?
    let idUsuario: Int?
    let autorNombre: String?
    let contenido: String
    let fechaCreacion: String?
}

struct CreateComentarioRequest: Encodable {
    let contenido: String
}
