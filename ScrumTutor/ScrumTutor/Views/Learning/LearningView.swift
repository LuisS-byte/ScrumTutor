import SwiftUI

struct LearningView: View {

    @StateObject private var vm = QuizViewModel()

    var body: some View {
        Group {
            if vm.isLoading {
                ProgressView("Cargando contenido...")
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Tips")
                                .font(.title2.bold())

                            if vm.tips.isEmpty {
                                Text("No hay tips disponibles por ahora.")
                                    .foregroundColor(.secondary)
                            } else {
                                ForEach(vm.tips) { tip in
                                    NavigationLink {
                                        DetalleTemaView(
                                            titulo: tip.seccion ?? "Tema Scrum",
                                            contenido: tip.mensaje ?? ""
                                        )
                                    } label: {
                                        LearningCardView(
                                            titulo: tip.seccion ?? "Tema Scrum",
                                            subtitulo: tip.mensaje ?? "",
                                            color: .blue,
                                            icono: "lightbulb.fill"
                                        )
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }

                        VStack(alignment: .leading, spacing: 12) {
                            Text("Quizzes")
                                .font(.title2.bold())

                            if vm.quizzes.isEmpty {
                                Text("No hay quizzes disponibles por ahora.")
                                    .foregroundColor(.secondary)
                            } else {
                                ForEach(vm.quizzes) { quiz in
                                    NavigationLink {
                                        QuizView(quizID: quiz.id, quizTitulo: quiz.titulo)
                                    } label: {
                                        LearningCardView(
                                            titulo: quiz.titulo,
                                            subtitulo: quiz.descripcion ?? "Pone a prueba tus conocimientos de Scrum.",
                                            color: .green,
                                            icono: "checkmark.seal.fill"
                                        )
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("Learning")
        .onAppear {
            if vm.tips.isEmpty && vm.quizzes.isEmpty {
                vm.cargarContenido()
            }
        }
        .appErrorAlert(message: $vm.errorMessage)
    }
}

private struct LearningCardView: View {

    let titulo: String
    let subtitulo: String
    let color: Color
    let icono: String

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icono)
                .font(.title2)
                .foregroundColor(color)
                .frame(width: 44, height: 44)
                .background(color.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 12))

            VStack(alignment: .leading, spacing: 6) {
                Text(titulo)
                    .font(.headline)
                    .foregroundColor(.primary)
                Text(subtitulo)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption.weight(.semibold))
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
