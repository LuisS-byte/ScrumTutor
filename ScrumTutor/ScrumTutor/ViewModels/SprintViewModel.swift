// SprintViewModel.swift
import Foundation

@MainActor
class SprintViewModel: ObservableObject {

    @Published var sprints: [Sprint] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    // ---------------------------------------------------------------
    // Entradas     : idProyecto: Int — ID del proyecto propietario
    // Salidas      : isLoading: Bool — estado de actividad de red
    //                sprints: [Sprint] — lista actualizada del servidor
    //                errorMessage: String? — descripción del error si falla
    // Valor retorno: Void
    // Función      : Consulta GET /api/proyectos/{id}/sprints y actualiza
    //                la lista publicada de sprints del proyecto indicado.
    // Variables    : isLoading: Bool, sprints: [Sprint],
    //                errorMessage: String?
    // Fecha        : 2026-04-25
    // Autor        : Ernesto
    // Rutinas anexas: NetworkManager.shared.request,
    //                 APIConstants.Proyectos.sprints
    // ---------------------------------------------------------------
    func cargarSprints(idProyecto: Int) {
        isLoading = true
        errorMessage = nil

        NetworkManager.shared.request(
            path: APIConstants.Proyectos.sprints(idProyecto),
            method: "GET",
            responseType: [Sprint].self
        ) { [weak self] result in
            guard let self else { return }
            self.isLoading = false
            switch result {
            case .success(let data): self.sprints = data
            case .failure(let error): self.errorMessage = error.localizedDescription
            }
        }
    }

    // ---------------------------------------------------------------
    // Entradas     : idProyecto: Int — ID del proyecto al que pertenece
    //                nombre: String — nombre del sprint
    //                objetivo: String — meta del sprint
    //                fechaInicio: String — fecha de inicio (yyyy-MM-dd)
    //                fechaFin: String — fecha de finalización (yyyy-MM-dd)
    //                completion: (Bool) -> Void — resultado de la operación
    // Salidas      : sprints: [Sprint] — lista recargada tras éxito
    //                errorMessage: String? — descripción del error si falla
    // Valor retorno: Void (resultado asíncrono vía completion)
    // Función      : Construye CreateSprintRequest con idEstado = 1
    //                (Planificado) y lo envía vía POST /api/sprints.
    //                Al tener éxito recarga la lista de sprints.
    // Variables    : body: CreateSprintRequest, idEstado: Int = 1
    // Fecha        : 2026-04-25
    // Autor        : Ernesto
    // Rutinas anexas: NetworkManager.shared.request,
    //                 APIConstants.Sprints.base, cargarSprints
    // ---------------------------------------------------------------
    func crearSprint(idProyecto: Int, nombre: String, objetivo: String,
                     fechaInicio: String, fechaFin: String,
                     completion: @escaping (Bool) -> Void) {
        let body = CreateSprintRequest(
            idProyecto: idProyecto,
            nombre: nombre,
            objetivo: objetivo,
            fechaInicio: fechaInicio,
            fechaFin: fechaFin,
            idEstado: 1
        )

        NetworkManager.shared.request(
            path: APIConstants.Sprints.base,
            method: "POST",
            body: body,
            responseType: Sprint.self
        ) { [weak self] result in
            switch result {
            case .success:
                self?.cargarSprints(idProyecto: idProyecto)
                completion(true)
            case .failure(let error):
                self?.errorMessage = error.localizedDescription
                completion(false)
            }
        }
    }

    // MARK: - Editar sprint
    func editarSprint(id: Int, idProyecto: Int, nombre: String, objetivo: String,
                      fechaInicio: String, fechaFin: String, idEstado: Int,
                      completion: @escaping (Bool) -> Void) {
        let body = UpdateSprintRequest(
            nombre: nombre,
            objetivo: objetivo,
            fechaInicio: fechaInicio,
            fechaFin: fechaFin,
            idEstado: idEstado
        )

        NetworkManager.shared.request(
            path: APIConstants.Sprints.byId(id),
            method: "PUT",
            body: body,
            responseType: Sprint.self
        ) { [weak self] result in
            switch result {
            case .success:
                self?.cargarSprints(idProyecto: idProyecto)
                completion(true)
            case .failure(let error):
                self?.errorMessage = error.localizedDescription
                completion(false)
            }
        }
    }

    // ---------------------------------------------------------------
    // Entradas     : id: Int — ID del sprint a eliminar
    //                idProyecto: Int — ID del proyecto para recargar lista
    // Salidas      : sprints: [Sprint] — lista actualizada tras eliminación
    //                errorMessage: String? — descripción del error si falla
    // Valor retorno: Void
    // Función      : Envía DELETE /api/sprints/{id} y, si tiene éxito,
    //                recarga la lista de sprints del proyecto.
    // Variables    : errorMessage: String?
    // Fecha        : 2026-04-25
    // Autor        : Ernesto
    // Rutinas anexas: NetworkManager.shared.requestEmpty,
    //                 APIConstants.Sprints.byId, cargarSprints
    // ---------------------------------------------------------------
    func eliminarSprint(id: Int, idProyecto: Int) {
        NetworkManager.shared.requestEmpty(
            path: APIConstants.Sprints.byId(id),
            method: "DELETE"
        ) { [weak self] result in
            switch result {
            case .success: self?.cargarSprints(idProyecto: idProyecto)
            case .failure(let error): self?.errorMessage = error.localizedDescription
            }
        }
    }

    // MARK: - Color según estado
    func colorEstado(_ idEstado: Int?) -> String {
        let colores: [Int: String] = [1: "gray", 2: "blue", 3: "green"]
        return colores[idEstado ?? 0] ?? "gray"
    }
}
