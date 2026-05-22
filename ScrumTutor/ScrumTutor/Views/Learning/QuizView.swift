import SwiftUI

struct QuizView: View {

    let quizID: Int
    let quizTitulo: String
    @StateObject private var vm = QuizViewModel()

    var body: some View {
        Group {
            if vm.isLoading {
                ProgressView("Cargando quiz...")
            } else if let quiz = vm.quizDetalle,
                      let preguntas = quiz.preguntas,
                      !preguntas.isEmpty {
                if vm.quizFinalizado {
                    resultadoView
                } else {
                    preguntaView(preguntas: preguntas)
                }
            } else {
                VStack(spacing: 12) {
                    Image(systemName: "questionmark.circle")
                        .font(.system(size: 50))
                        .foregroundColor(.secondary)
                    Text("No hay preguntas disponibles para este quiz.")
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .navigationTitle(quizTitulo)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if vm.quizDetalle?.id != quizID {
                vm.iniciarQuiz(id: quizID)
            }
        }
        .alert("Error", isPresented: .constant(vm.errorMessage != nil)) {
            Button("OK") { vm.errorMessage = nil }
        } message: {
            Text(vm.errorMessage ?? "")
        }
    }

    @ViewBuilder
    private func preguntaView(preguntas: [QuizPregunta]) -> some View {
        let pregunta = preguntas[vm.preguntaActualIndex]

        VStack(alignment: .leading, spacing: 20) {
            Text("Pregunta \(vm.preguntaActualIndex + 1) de \(preguntas.count)")
                .font(.headline)
                .foregroundColor(.secondary)

            Text(pregunta.pregunta)
                .font(.title3.bold())

            VStack(spacing: 12) {
                opcionButton(letra: "A", texto: pregunta.opcionA)
                opcionButton(letra: "B", texto: pregunta.opcionB)
                opcionButton(letra: "C", texto: pregunta.opcionC)
            }

            Button(vm.preguntaActualIndex == preguntas.count - 1 ? "Finalizar" : "Siguiente") {
                vm.avanzarQuiz()
            }
            .buttonStyle(.borderedProminent)
            .disabled(vm.opcionSeleccionada == nil)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }

    private var resultadoView: some View {
        VStack(spacing: 16) {
            Image(systemName: "rosette")
                .font(.system(size: 56))
                .foregroundColor(.green)

            Text("Quiz completado")
                .font(.title.bold())

            Text(vm.resultadoTexto ?? "Resultado no disponible")
                .font(.title3)
                .multilineTextAlignment(.center)

            if vm.isSubmitting {
                ProgressView("Guardando progreso...")
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func opcionButton(letra: String, texto: String) -> some View {
        let seleccionada = vm.opcionSeleccionada == letra

        return Button {
            vm.seleccionarOpcion(letra)
        } label: {
            HStack(spacing: 12) {
                Image(systemName: seleccionada ? "largecircle.fill.circle" : "circle")
                    .foregroundColor(seleccionada ? .blue : .secondary)

                Text("\(letra). \(texto)")
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
            .background(seleccionada ? Color.blue.opacity(0.12) : Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .buttonStyle(.plain)
    }
}
