// ComentarioViewModel.swift
import Foundation

@MainActor
class ComentarioViewModel: ObservableObject {

    @Published var comentarios: [Comentario] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    // MARK: - Cargar comentarios de una tarea
    func cargarComentarios(idTarea: Int) {
        isLoading = true
        errorMessage = nil

        NetworkManager.shared.request(
            path: APIConstants.Tareas.comentarios(idTarea),
            method: "GET",
            responseType: [Comentario].self
        ) { [weak self] result in
            guard let self else { return }
            self.isLoading = false
            switch result {
            case .success(let data): self.comentarios = data
            case .failure(let error): self.errorMessage = error.localizedDescription
            }
        }
    }

    // MARK: - Agregar comentario
    func agregarComentario(idTarea: Int, contenido: String,
                           completion: @escaping (Bool) -> Void) {
        guard !contenido.trimmingCharacters(in: .whitespaces).isEmpty else {
            completion(false)
            return
        }

        let body = CreateComentarioRequest(contenido: contenido)

        NetworkManager.shared.request(
            path: APIConstants.Tareas.comentarios(idTarea),
            method: "POST",
            body: body,
            responseType: Comentario.self
        ) { [weak self] result in
            switch result {
            case .success:
                self?.cargarComentarios(idTarea: idTarea)
                completion(true)
            case .failure(let error):
                self?.errorMessage = error.localizedDescription
                completion(false)
            }
        }
    }
}
