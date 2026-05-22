import Foundation

@MainActor
final class PerfilViewModel: ObservableObject {

    @Published var usuario: Usuario?
    @Published var roles: [RolSistema] = []
    @Published var isLoading: Bool = false
    @Published var isSaving: Bool = false
    @Published var errorMessage: String? = nil

    func cargarPerfil() {
        guard let token = KeychainManager.shared.getToken(),
              let correo = JWTDecoder.getEmail(from: token),
              let correoCodificado = correo.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        else {
            errorMessage = "No se pudo obtener el usuario autenticado"
            return
        }

        isLoading = true
        errorMessage = nil

        let path = APIConstants.Usuarios.buscar + "?correo=\(correoCodificado)"

        NetworkManager.shared.request(
            path: path,
            method: "GET",
            responseType: Usuario.self
        ) { [weak self] result in
            guard let self else { return }
            self.isLoading = false

            switch result {
            case .success(let usuario):
                self.usuario = usuario
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }

    func cargarRoles() {
        NetworkManager.shared.request(
            path: APIConstants.Usuarios.roles,
            method: "GET",
            responseType: [RolSistema].self
        ) { [weak self] result in
            switch result {
            case .success(let roles):
                self?.roles = roles
            case .failure(let error):
                self?.errorMessage = error.localizedDescription
            }
        }
    }

    func actualizarPerfil(id: Int, nombre: String, idRol: Int, completion: @escaping (Bool) -> Void) {
        let nombreLimpio = nombre.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !nombreLimpio.isEmpty else {
            errorMessage = "El nombre no puede estar vacio"
            completion(false)
            return
        }

        isSaving = true
        errorMessage = nil

        let body = UpdateUserRequest(nombre: nombreLimpio, idRol: idRol)

        NetworkManager.shared.request(
            path: APIConstants.Usuarios.byId(id),
            method: "PUT",
            body: body,
            responseType: Usuario.self
        ) { [weak self] result in
            guard let self else { return }
            self.isSaving = false

            switch result {
            case .success(let usuario):
                self.usuario = usuario
                completion(true)
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                completion(false)
            }
        }
    }
}
