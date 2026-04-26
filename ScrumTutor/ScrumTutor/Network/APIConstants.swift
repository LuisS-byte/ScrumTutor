// APIConstants.swift
// ScrumTutor

import Foundation

enum APIConstants {
    static let baseURL = "https://nonimplemental-frowningly-victor.ngrok-free.dev"

    enum Auth {
        static let login    = "/api/auth/login"
        static let register = "/api/auth/register"
        static let google   = "/api/auth/google"
    }

    enum Usuarios {
        static let buscar = "/api/usuarios/buscar"
        static func byId(_ id: Int) -> String { "/api/usuarios/\(id)" }
        static let roles  = "/api/roles"
    }

    enum Proyectos {
        static let base = "/api/proyectos"
        static func byId(_ id: Int) -> String { "/api/proyectos/\(id)" }
        static func sprints(_ id: Int) -> String { "/api/proyectos/\(id)/sprints" }
        static func historias(_ id: Int) -> String { "/api/proyectos/\(id)/historias" }
        static func miembros(_ id: Int) -> String { "/api/proyectos/\(id)/miembros" }
        static func miembroById(_ pId: Int, _ mId: Int) -> String { "/api/proyectos/\(pId)/miembros/\(mId)" }
        static func invitacion(_ pId: Int, _ mId: Int) -> String { "/api/proyectos/\(pId)/miembros/\(mId)/invitacion" }
        static func miembrosPendientes(_ id: Int) -> String { "/api/proyectos/\(id)/miembros/pendientes" }
    }

    enum Sprints {
        static let base = "/api/sprints"
        static func byId(_ id: Int) -> String { "/api/sprints/\(id)" }
        static func tareas(_ id: Int) -> String { "/api/sprints/\(id)/tareas" }
        static func historias(_ id: Int) -> String { "/api/sprints/\(id)/historias" }
    }

    enum Historias {
        static let base = "/api/historias"
        static func byId(_ id: Int) -> String { "/api/historias/\(id)" }
        static func asignarSprint(_ hId: Int, _ sId: Int) -> String { "/api/historias/\(hId)/asignar-sprint/\(sId)" }
    }

    enum Tareas {
        static let base = "/api/tareas"
        static func byId(_ id: Int) -> String { "/api/tareas/\(id)" }
        static func asignar(_ id: Int) -> String { "/api/tareas/\(id)/asignar" }
        static func comentarios(_ id: Int) -> String { "/api/tareas/\(id)/comentarios" }
    }

    enum Quizzes {
        static let base = "/api/quizzes"
        static func byId(_ id: Int) -> String { "/api/quizzes/\(id)" }
        static func progreso(_ id: Int) -> String { "/api/quizzes/\(id)/progreso" }
    }

    enum Tips {
        static let base = "/api/tips"
    }

    enum Notificaciones {
        static let base = "/api/notificaciones"
        static func byUsuario(_ id: Int) -> String { "/api/notificaciones/\(id)" }
        static func leer(_ id: Int) -> String { "/api/notificaciones/\(id)/leer" }
        static func delete(_ id: Int) -> String { "/api/notificaciones/\(id)" }
    }

    enum RolesProyecto {
        static let base = "/api/roles-proyecto"
    }
}
