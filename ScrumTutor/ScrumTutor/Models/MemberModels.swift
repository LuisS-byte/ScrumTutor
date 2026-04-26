// MemberModels.swift
import Foundation

struct Miembro: Decodable, Identifiable {
    let idMiembro: Int
    let idProyecto: Int?
    let idUsuario: Int?
    let idRolProyecto: Int?
    let rolDescripcion: String?
    let usuarioNombre: String?
    let invitacion: Bool?

    // Identifiable usa idMiembro como id
    var id: Int { idMiembro }
}

struct RolProyecto: Decodable, Identifiable {
    let id: Int
    let descripcion: String
}

struct AddMemberRequest: Encodable {
    let idUsuario: Int
    let idRolProyecto: Int
}

struct InvitacionRequest: Encodable {
    let invitacion: Bool
}
