// NotificacionViewModel.swift
import Foundation

@MainActor
class NotificacionViewModel: ObservableObject {

    @Published var notificaciones: [Notificacion] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    // MARK: - Cargar notificaciones del usuario
    func cargarNotificaciones() {
        guard let token = KeychainManager.shared.getToken(),
              let userId = JWTDecoder.getUserId(from: token) else { return }

        isLoading = true
        errorMessage = nil

        NetworkManager.shared.request(
            path: APIConstants.Notificaciones.byUsuario(userId),
            method: "GET",
            responseType: [Notificacion].self
        ) { [weak self] result in
            guard let self else { return }
            self.isLoading = false
            switch result {
            case .success(let data):
                self.notificaciones = data.filter { $0.leido == false }
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }

    // MARK: - Marcar como leída
    func marcarLeida(id: Int) {
        NetworkManager.shared.requestIgnoringResponse(
            path: APIConstants.Notificaciones.leer(id),
            method: "PUT"
        ) { [weak self] _ in
            self?.cargarNotificaciones()
        }
    }

    // MARK: - Eliminar notificación
    func eliminarNotificacion(id: Int) {
        NetworkManager.shared.requestIgnoringResponse(
            path: APIConstants.Notificaciones.delete(id),
            method: "DELETE"
        ) { [weak self] _ in
            self?.cargarNotificaciones()
        }
    }

    // MARK: - Buscar miembro pendiente
    private func buscarMiembroPendiente(idProyecto: Int,
                                        userId: Int,
                                        completion: @escaping (Miembro?) -> Void) {
        NetworkManager.shared.request(
            path: APIConstants.Proyectos.miembrosPendientes(idProyecto),
            method: "GET",
            responseType: [Miembro].self
        ) { result in
            switch result {
            case .success(let miembros):
                print("✅ Pendientes: \(miembros.count)")
                miembros.forEach { print("  - idUsuario: \($0.idUsuario ?? -1), idMiembro: \($0.idMiembro)") }
                completion(miembros.first(where: { $0.idUsuario == userId }))
            case .failure(let error):
                print("❌ Error pendientes: \(error)")
                completion(nil)
            }
        }
    }

    // MARK: - Aceptar invitación
    func aceptarInvitacion(idProyecto: Int, idNotificacion: Int) {
        guard let token = KeychainManager.shared.getToken(),
              let userId = JWTDecoder.getUserId(from: token) else { return }

        buscarMiembroPendiente(idProyecto: idProyecto, userId: userId) { [weak self] miembro in
            guard let self, let miembro else {
                print("❌ No se encontró miembro pendiente")
                return
            }

            let body = InvitacionRequest(invitacion: true) // true = aceptado
            NetworkManager.shared.requestIgnoringResponse(
                path: APIConstants.Proyectos.invitacion(idProyecto, miembro.idMiembro),
                method: "PUT",
                body: body
            ) { _ in
                self.marcarLeida(id: idNotificacion)
                NotificationCenter.default.post(name: .proyectosDidChange, object: nil)
                NotificationCenter.default.post(name: .miembrosDidChange, object: nil)
            }
        }
    }

    // MARK: - Rechazar invitación
    func rechazarInvitacion(idProyecto: Int, idNotificacion: Int) {
        guard let token = KeychainManager.shared.getToken(),
              let userId = JWTDecoder.getUserId(from: token) else { return }

        buscarMiembroPendiente(idProyecto: idProyecto, userId: userId) { [weak self] miembro in
            guard let self, let miembro else {
                print("❌ No se encontró miembro pendiente")
                return
            }

            // Eliminar el miembro directamente
            NetworkManager.shared.requestIgnoringResponse(
                path: APIConstants.Proyectos.miembroById(idProyecto, miembro.idMiembro),
                method: "DELETE"
            ) { _ in
                self.eliminarNotificacion(id: idNotificacion)
            }
        }
    }
}
