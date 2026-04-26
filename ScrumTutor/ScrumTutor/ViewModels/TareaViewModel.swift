// TareaViewModel.swift
import Foundation

@MainActor
class TareaViewModel: ObservableObject {

    @Published var tareas: [Tarea] = []
    @Published var is_loading: Bool = false
    @Published var error_message: String? = nil

    var por_hacer: [Tarea]   { tareas.filter { $0.idEstado == 1 } }
    var en_progreso: [Tarea] { tareas.filter { $0.idEstado == 2 } }
    var completadas: [Tarea] { tareas.filter { $0.idEstado == 3 } }

    // ---------------------------------------------------------------
    // Entradas     : idSprint: Int — ID del sprint propietario
    // Salidas      : is_loading: Bool — estado de actividad de red
    //                tareas: [Tarea] — lista actualizada del servidor
    //                error_message: String? — descripción del error si falla
    // Valor retorno: Void
    // Función      : Consulta GET /api/sprints/{id}/tareas y actualiza
    //                la lista publicada; las propiedades computadas
    //                por_hacer, en_progreso y completadas se actualizan
    //                automáticamente al cambiar tareas.
    // Variables    : is_loading: Bool, tareas: [Tarea],
    //                error_message: String?
    // Fecha        : 2026-04-25
    // Autor        : Ernesto
    // Rutinas anexas: NetworkManager.shared.request,
    //                 APIConstants.Sprints.tareas
    // ---------------------------------------------------------------
    func cargarTareas(idSprint: Int) {
        is_loading = true
        error_message = nil

        NetworkManager.shared.request(
            path: APIConstants.Sprints.tareas(idSprint),
            method: "GET",
            responseType: [Tarea].self
        ) { [weak self] result in
            guard let self else { return }
            self.is_loading = false
            switch result {
            case .success(let data): self.tareas = data
            case .failure(let error): self.error_message = error.localizedDescription
            }
        }
    }

    // MARK: - Crear tarea
    func crearTarea(idSprint: Int, titulo: String, descripcion: String,
                    idEstado: Int, idAsignadoA: Int?, fechaLimite: String?,
                    completion: @escaping (Bool) -> Void) {
        let body = CreateTareaRequest(
            idSprint: idSprint,
            idHistoria: nil,
            titulo: titulo,
            descripcion: descripcion,
            idEstado: idEstado,
            idAsignadoA: idAsignadoA,
            fechaLimite: fechaLimite
        )

        NetworkManager.shared.request(
            path: APIConstants.Tareas.base,
            method: "POST",
            body: body,
            responseType: Tarea.self
        ) { [weak self] result in
            switch result {
            case .success:
                self?.cargarTareas(idSprint: idSprint)
                completion(true)
            case .failure(let error):
                self?.error_message = error.localizedDescription
                completion(false)
            }
        }
    }

    // MARK: - Editar tarea
    func editarTarea(id: Int, idSprint: Int, titulo: String, descripcion: String,
                     idEstado: Int, idAsignadoA: Int?, fechaLimite: String?,
                     completion: @escaping (Bool) -> Void) {
        let body = UpdateTareaRequest(
            titulo: titulo,
            descripcion: descripcion,
            idEstado: idEstado,
            idAsignadoA: idAsignadoA,
            fechaLimite: fechaLimite
        )

        NetworkManager.shared.request(
            path: APIConstants.Tareas.byId(id),
            method: "PUT",
            body: body,
            responseType: Tarea.self
        ) { [weak self] result in
            switch result {
            case .success:
                self?.cargarTareas(idSprint: idSprint)
                completion(true)
            case .failure(let error):
                self?.error_message = error.localizedDescription
                completion(false)
            }
        }
    }

    // ---------------------------------------------------------------
    // Entradas     : tarea: Tarea — objeto con todos los datos actuales
    //                nuevoEstado: Int — estado destino
    //                              (1=Por hacer, 2=En progreso, 3=Completado)
    //                idSprint: Int — ID del sprint para recargar la lista
    // Salidas      : tareas: [Tarea] — lista actualizada tras el cambio
    //                error_message: String? — descripción del error si falla
    // Valor retorno: Void
    // Función      : Envía PUT /api/tareas/{id} conservando todos los campos
    //                existentes de la tarea y reemplazando únicamente
    //                idEstado con nuevoEstado. Usado por el tablero Kanban
    //                al mover una tarjeta entre columnas.
    // Variables    : body: UpdateTareaRequest, error_message: String?
    // Fecha        : 2026-04-25
    // Autor        : Ernesto
    // Rutinas anexas: NetworkManager.shared.request,
    //                 APIConstants.Tareas.byId, cargarTareas
    // ---------------------------------------------------------------
    func cambiarEstado(tarea: Tarea, nuevoEstado: Int, idSprint: Int) {
        let body = UpdateTareaRequest(
            titulo: tarea.titulo,
            descripcion: tarea.descripcion ?? "",
            idEstado: nuevoEstado,
            idAsignadoA: tarea.idAsignadoA,
            fechaLimite: tarea.fechaLimite
        )

        NetworkManager.shared.request(
            path: APIConstants.Tareas.byId(tarea.id),
            method: "PUT",
            body: body,
            responseType: Tarea.self
        ) { [weak self] result in
            switch result {
            case .success: self?.cargarTareas(idSprint: idSprint)
            case .failure(let error): self?.error_message = error.localizedDescription
            }
        }
    }

    // MARK: - Eliminar tarea
    func eliminarTarea(id: Int, idSprint: Int) {
        NetworkManager.shared.requestEmpty(
            path: APIConstants.Tareas.byId(id),
            method: "DELETE"
        ) { [weak self] result in
            switch result {
            case .success: self?.cargarTareas(idSprint: idSprint)
            case .failure(let error): self?.error_message = error.localizedDescription
            }
        }
    }
}
