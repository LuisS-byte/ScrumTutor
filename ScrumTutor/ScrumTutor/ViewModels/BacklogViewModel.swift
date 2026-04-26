// BacklogViewModel.swift
import Foundation

@MainActor
class BacklogViewModel: ObservableObject {

    @Published var historias: [Historia] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    var sinSprint: [Historia] { historias.filter { $0.idSprint == nil } }
    var conSprint: [Historia] { historias.filter { $0.idSprint != nil } }

    // ---------------------------------------------------------------
    // Entradas     : idProyecto: Int — ID del proyecto propietario
    // Salidas      : isLoading: Bool — estado de actividad de red
    //                historias: [Historia] — lista actualizada del servidor
    //                errorMessage: String? — descripción del error si falla
    // Valor retorno: Void
    // Función      : Consulta GET /api/proyectos/{id}/historias y actualiza
    //                la lista publicada de historias del proyecto.
    // Variables    : isLoading: Bool, historias: [Historia],
    //                errorMessage: String?
    // Fecha        : 2026-04-25
    // Autor        : Ernesto
    // Rutinas anexas: NetworkManager.shared.request,
    //                 APIConstants.Proyectos.historias
    // ---------------------------------------------------------------
    func cargarHistorias(idProyecto: Int) {
        isLoading = true
        errorMessage = nil

        NetworkManager.shared.request(
            path: APIConstants.Proyectos.historias(idProyecto),
            method: "GET",
            responseType: [Historia].self
        ) { [weak self] result in
            guard let self else { return }
            self.isLoading = false
            switch result {
            case .success(let data): self.historias = data
            case .failure(let error): self.errorMessage = error.localizedDescription
            }
        }
    }

    // ---------------------------------------------------------------
    // Entradas     : idProyecto: Int — ID del proyecto al que pertenece
    //                titulo: String — título de la historia de usuario
    //                descripcion: String — descripción detallada
    //                idPrioridad: Int — nivel de prioridad (1=Alta, etc.)
    //                criterios: String — criterios de aceptación
    //                idEstado: Int — estado inicial de la historia
    //                completion: (Bool) -> Void — resultado de la operación
    // Salidas      : historias: [Historia] — lista recargada tras éxito
    //                errorMessage: String? — descripción del error si falla
    // Valor retorno: Void (resultado asíncrono vía completion)
    // Función      : Construye CreateHistoriaRequest con idSprint = nil
    //                (backlog sin asignar) y lo envía vía POST /api/historias.
    //                Al tener éxito recarga la lista de historias.
    // Variables    : body: CreateHistoriaRequest
    // Fecha        : 2026-04-25
    // Autor        : Ernesto
    // Rutinas anexas: NetworkManager.shared.request,
    //                 APIConstants.Historias.base, cargarHistorias
    // ---------------------------------------------------------------
    func crearHistoria(idProyecto: Int, titulo: String, descripcion: String,
                       idPrioridad: Int, criterios: String, idEstado: Int,
                       completion: @escaping (Bool) -> Void) {
        let body = CreateHistoriaRequest(
            idProyecto: idProyecto,
            idSprint: nil,
            titulo: titulo,
            descripcion: descripcion,
            idPrioridad: idPrioridad,
            criteriosAceptacion: criterios,
            idEstado: idEstado
        )

        NetworkManager.shared.request(
            path: APIConstants.Historias.base,
            method: "POST",
            body: body,
            responseType: Historia.self
        ) { [weak self] result in
            switch result {
            case .success:
                self?.cargarHistorias(idProyecto: idProyecto)
                completion(true)
            case .failure(let error):
                self?.errorMessage = error.localizedDescription
                completion(false)
            }
        }
    }

    // MARK: - Editar historia
    func editarHistoria(id: Int, idProyecto: Int, titulo: String, descripcion: String,
                        idSprint: Int?, idPrioridad: Int, criterios: String, idEstado: Int,
                        completion: @escaping (Bool) -> Void) {
        let body = UpdateHistoriaRequest(
            titulo: titulo,
            descripcion: descripcion,
            idSprint: idSprint,
            idPrioridad: idPrioridad,
            criteriosAceptacion: criterios,
            idEstado: idEstado
        )

        NetworkManager.shared.request(
            path: APIConstants.Historias.byId(id),
            method: "PUT",
            body: body,
            responseType: Historia.self
        ) { [weak self] result in
            switch result {
            case .success:
                self?.cargarHistorias(idProyecto: idProyecto)
                completion(true)
            case .failure(let error):
                self?.errorMessage = error.localizedDescription
                completion(false)
            }
        }
    }

    // ---------------------------------------------------------------
    // Entradas     : id: Int — ID de la historia a eliminar
    //                idProyecto: Int — ID del proyecto para recargar lista
    // Salidas      : historias: [Historia] — lista actualizada tras eliminación
    //                errorMessage: String? — descripción del error si falla
    // Valor retorno: Void
    // Función      : Envía DELETE /api/historias/{id} y, si tiene éxito,
    //                recarga la lista de historias del proyecto.
    // Variables    : errorMessage: String?
    // Fecha        : 2026-04-25
    // Autor        : Ernesto
    // Rutinas anexas: NetworkManager.shared.requestEmpty,
    //                 APIConstants.Historias.byId, cargarHistorias
    // ---------------------------------------------------------------
    func eliminarHistoria(id: Int, idProyecto: Int) {
        NetworkManager.shared.requestEmpty(
            path: APIConstants.Historias.byId(id),
            method: "DELETE"
        ) { [weak self] result in
            switch result {
            case .success: self?.cargarHistorias(idProyecto: idProyecto)
            case .failure(let error): self?.errorMessage = error.localizedDescription
            }
        }
    }
}
