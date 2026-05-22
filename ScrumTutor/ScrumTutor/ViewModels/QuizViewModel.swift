import Foundation

@MainActor
final class QuizViewModel: ObservableObject {

    @Published var tips: [Tip] = []
    @Published var quizzes: [Quiz] = []
    @Published var quizDetalle: Quiz?
    @Published var isLoading: Bool = false
    @Published var isSubmitting: Bool = false
    @Published var errorMessage: String? = nil
    @Published var preguntaActualIndex: Int = 0
    @Published var opcionSeleccionada: String? = nil
    @Published var quizFinalizado: Bool = false
    @Published var resultadoTexto: String? = nil

    private var respuestasCorrectas: Int = 0

    func cargarContenido() {
        isLoading = true
        errorMessage = nil

        let group = DispatchGroup()

        group.enter()
        NetworkManager.shared.request(
            path: APIConstants.Tips.base,
            method: "GET",
            responseType: [Tip].self
        ) { [weak self] result in
            switch result {
            case .success(let tips):
                self?.tips = tips
            case .failure(let error):
                self?.errorMessage = error.localizedDescription
            }
            group.leave()
        }

        group.enter()
        NetworkManager.shared.request(
            path: APIConstants.Quizzes.base,
            method: "GET",
            responseType: [Quiz].self
        ) { [weak self] result in
            switch result {
            case .success(let quizzes):
                self?.quizzes = quizzes
            case .failure(let error):
                self?.errorMessage = error.localizedDescription
            }
            group.leave()
        }

        group.notify(queue: .main) { [weak self] in
            self?.isLoading = false
        }
    }

    func iniciarQuiz(id: Int) {
        reiniciarEstadoQuiz()
        isLoading = true
        errorMessage = nil

        NetworkManager.shared.request(
            path: APIConstants.Quizzes.byId(id),
            method: "GET",
            responseType: Quiz.self
        ) { [weak self] result in
            guard let self else { return }
            self.isLoading = false

            switch result {
            case .success(let quiz):
                self.quizDetalle = quiz
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }

    func seleccionarOpcion(_ opcion: String) {
        opcionSeleccionada = opcion
    }

    func avanzarQuiz() {
        guard let preguntas = quizDetalle?.preguntas,
              preguntaActualIndex < preguntas.count,
              let opcionSeleccionada
        else { return }

        let preguntaActual = preguntas[preguntaActualIndex]
        if opcionSeleccionada.caseInsensitiveCompare(preguntaActual.opcionCorrecta) == .orderedSame {
            respuestasCorrectas += 1
        }

        if preguntaActualIndex == preguntas.count - 1 {
            finalizarQuiz(totalPreguntas: preguntas.count)
        } else {
            preguntaActualIndex += 1
            self.opcionSeleccionada = nil
        }
    }

    private func finalizarQuiz(totalPreguntas: Int) {
        quizFinalizado = true
        opcionSeleccionada = nil

        let puntaje = totalPreguntas == 0 ? 0 : (Double(respuestasCorrectas) / Double(totalPreguntas)) * 100
        resultadoTexto = String(
            format: "Obtuviste %.0f%% (%d/%d correctas)",
            puntaje,
            respuestasCorrectas,
            totalPreguntas
        )

        guard let quizId = quizDetalle?.id else { return }

        isSubmitting = true
        let body = ProgresoRequest(puntaje: puntaje)

        NetworkManager.shared.requestIgnoringResponse(
            path: APIConstants.Quizzes.progreso(quizId),
            method: "POST",
            body: body
        ) { [weak self] result in
            self?.isSubmitting = false

            if case .failure(let error) = result {
                self?.errorMessage = error.localizedDescription
            }
        }
    }

    private func reiniciarEstadoQuiz() {
        quizDetalle = nil
        preguntaActualIndex = 0
        opcionSeleccionada = nil
        quizFinalizado = false
        resultadoTexto = nil
        respuestasCorrectas = 0
    }
}
