// MiembrosViewModel.swift
import Foundation

@MainActor
class MiembrosViewModel: ObservableObject {

    @Published var miembros: [Miembro] = []
    @Published var roles: [RolProyecto] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil


    // MARK: - Cargar miembros del proyecto
    func cargarMiembros(idProyecto: Int) {
        isLoading = true
        errorMessage = nil

        NetworkManager.shared.request(
            path: APIConstants.Proyectos.miembros(idProyecto),
            method: "GET",
            responseType: [Miembro].self
        ) { [weak self] result in
            guard let self else { return }
            self.isLoading = false
            switch result {
            case .success(let data):
                self.miembros = data
            case .failure(let error):
                print("❌ Error miembros: \(error)")
                self.errorMessage = error.localizedDescription
            }
        }
    }

    // MARK: - Cargar roles de proyecto
    func cargarRoles() {
        NetworkManager.shared.request(
            path: APIConstants.RolesProyecto.base,
            method: "GET",
            responseType: [RolProyecto].self
        ) { [weak self] result in
            if case .success(let data) = result {
                // Filtrar Product Owner (id == 1)
                self?.roles = data.filter { $0.id != 1 }
            }
        }
    }

    // MARK: - Buscar usuario por correo
    func buscarUsuario(correo: String, completion: @escaping (Usuario?) -> Void) {
        let path = APIConstants.Usuarios.buscar + "?correo=\(correo)"

        NetworkManager.shared.request(
            path: path,
            method: "GET",
            responseType: Usuario.self
        ) { result in
            switch result {
            case .success(let usuario): completion(usuario)
            case .failure: completion(nil)
            }
        }
    }

    
    // MARK: - Invitar miembro
    func invitarMiembro(idProyecto: Int, idUsuario: Int, idRolProyecto: Int,
                        completion: @escaping (Bool) -> Void) {
        let body = AddMemberRequest(idUsuario: idUsuario, idRolProyecto: idRolProyecto)

        NetworkManager.shared.requestIgnoringResponse(
            path: APIConstants.Proyectos.miembros(idProyecto),
            method: "POST",
            body: body
        ) { [weak self] result in
            switch result {
            case .success:
                self?.enviarNotificacionInvitacion(
                    idUsuario: idUsuario,
                    idProyecto: idProyecto
                )
                self?.cargarMiembros(idProyecto: idProyecto)
                completion(true)
            case .failure(let error):
                self?.errorMessage = error.localizedDescription
                completion(false)
            }
        }
    }

    // MARK: - Enviar notificación de invitación
    private func enviarNotificacionInvitacion(idUsuario: Int, idProyecto: Int) {
        let body = CreateNotificacionRequest(
            idUsuario: idUsuario,
            idTipo: 5,
            idProyecto: idProyecto,
            mensaje: "Has sido invitado a un proyecto"
        )

        NetworkManager.shared.requestEmpty(
            path: APIConstants.Notificaciones.base,
            method: "POST",
            body: body
        ) { _ in }
    }

    // MARK: - Eliminar miembro
    func eliminarMiembro(idProyecto: Int, idMiembro: Int) {
        NetworkManager.shared.requestEmpty(
            path: APIConstants.Proyectos.miembroById(idProyecto, idMiembro),
            method: "DELETE"
        ) { [weak self] result in
            switch result {
            case .success: self?.cargarMiembros(idProyecto: idProyecto)
            case .failure(let error): self?.errorMessage = error.localizedDescription
            }
        }
    }

    // MARK: - ¿El usuario actual es Product Owner?
    func esProductOwner(idProyecto: Int) -> Bool {
        guard let token = KeychainManager.shared.getToken(),
              let userId = JWTDecoder.getUserId(from: token) else { return false }
        return miembros.first {
            $0.idUsuario == userId && $0.idRolProyecto == 1
        } != nil
    }
}
