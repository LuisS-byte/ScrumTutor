// ProyectosViewModel.swift
import Foundation

@MainActor
class ProyectosViewModel: ObservableObject {

    @Published var proyectos: [Proyecto] = []
    @Published var is_loading: Bool = false
    @Published var error_message: String? = nil

    // ---------------------------------------------------------------
    // Entradas     : Ninguna (utiliza el token JWT del Keychain)
    // Salidas      : is_loading: Bool — estado de actividad de red
    //                proyectos: [Proyecto] — lista actualizada del servidor
    //                error_message: String? — descripción del error si falla
    // Valor retorno: Void
    // Función      : Consulta GET /api/proyectos para obtener los proyectos
    //                del usuario autenticado y actualiza las propiedades
    //                publicadas del ViewModel.
    // Variables    : is_loading: Bool, proyectos: [Proyecto],
    //                error_message: String?
    // Fecha        : 2026-04-25
    // Autor        : Ernesto
    // Rutinas anexas: NetworkManager.shared.request,
    //                 APIConstants.Proyectos.base
    // ---------------------------------------------------------------
    func cargarProyectos() {
        is_loading = true
        error_message = nil

        NetworkManager.shared.request(
            path: APIConstants.Proyectos.base,
            method: "GET",
            responseType: [Proyecto].self
        ) { [weak self] result in
            guard let self else { return }
            self.is_loading = false
            switch result {
            case .success(let data): self.proyectos = data
            case .failure(let error): self.error_message = error.localizedDescription
            }
        }
    }

    // MARK: - Crear proyecto
    func crearProyecto(nombre: String, descripcion: String,
                       fechaInicio: String, fechaFin: String,
                       completion: @escaping (Bool) -> Void) {
        let body = CreateProjectRequest(
            nombre: nombre,
            descripcion: descripcion,
            fechaInicio: fechaInicio,
            fechaFin: fechaFin
        )

        NetworkManager.shared.request(
            path: APIConstants.Proyectos.base,
            method: "POST",
            body: body,
            responseType: Proyecto.self
        ) { [weak self] result in
            switch result {
            case .success:
                self?.cargarProyectos()
                completion(true)
            case .failure(let error):
                self?.error_message = error.localizedDescription
                completion(false)
            }
        }
    }

    // MARK: - Editar proyecto
    func editarProyecto(id: Int, nombre: String, descripcion: String,
                        fechaInicio: String, fechaFin: String,
                        completion: @escaping (Bool) -> Void) {
        let body = UpdateProjectRequest(
            nombre: nombre,
            descripcion: descripcion,
            fechaInicio: fechaInicio,
            fechaFin: fechaFin
        )

        NetworkManager.shared.request(
            path: APIConstants.Proyectos.byId(id),
            method: "PUT",
            body: body,
            responseType: Proyecto.self
        ) { [weak self] result in
            switch result {
            case .success:
                self?.cargarProyectos()
                completion(true)
            case .failure(let error):
                self?.error_message = error.localizedDescription
                completion(false)
            }
        }
    }

    // MARK: - Eliminar proyecto
    func eliminarProyecto(id: Int) {
        NetworkManager.shared.requestEmpty(
            path: APIConstants.Proyectos.byId(id),
            method: "DELETE"
        ) { [weak self] result in
            switch result {
            case .success: self?.cargarProyectos()
            case .failure(let error): self?.error_message = error.localizedDescription
            }
        }
    }

    // MARK: - ¿El usuario actual es el creador?
    func esCreador(proyecto: Proyecto) -> Bool {
        guard let token = KeychainManager.shared.getToken() else { return false }
        guard let userId = JWTDecoder.getUserId(from: token) else { return false }
        return proyecto.idUsuario == userId
    }
}
