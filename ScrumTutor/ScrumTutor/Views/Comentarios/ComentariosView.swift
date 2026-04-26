// ComentariosView.swift
import SwiftUI

struct ComentariosView: View {

    let idTarea: Int
    @StateObject private var vm = ComentarioViewModel()
    @State private var nuevoComentario: String = ""
    @FocusState private var tecladoActivo: Bool

    var body: some View {
        VStack(spacing: 0) {

            // Lista de comentarios
            Group {
                if vm.isLoading {
                    ProgressView("Cargando comentarios...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if vm.comentarios.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "bubble.left.and.bubble.right")
                            .font(.system(size: 50))
                            .foregroundColor(.secondary)
                        Text("No hay comentarios aún")
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollViewReader { proxy in
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(vm.comentarios) { comentario in
                                    ComentarioRowView(comentario: comentario)
                                        .id(comentario.id)
                                }
                            }
                            .padding()
                        }
                        .onChange(of: vm.comentarios.count) { _ in
                            if let ultimo = vm.comentarios.last {
                                withAnimation {
                                    proxy.scrollTo(ultimo.id, anchor: .bottom)
                                }
                            }
                        }
                    }
                }
            }

            Divider()

            // Input nuevo comentario
            HStack(spacing: 12) {
                TextField("Escribe un comentario...", text: $nuevoComentario, axis: .vertical)
                    .lineLimit(1...4)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(20)
                    .focused($tecladoActivo)

                Button {
                    let texto = nuevoComentario.trimmingCharacters(in: .whitespaces)
                    guard !texto.isEmpty else { return }
                    vm.agregarComentario(idTarea: idTarea, contenido: texto) { ok in
                        if ok {
                            nuevoComentario = ""
                            tecladoActivo = false
                        }
                    }
                } label: {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(nuevoComentario.trimmingCharacters(in: .whitespaces).isEmpty
                                         ? .gray : .blue)
                        .font(.title3)
                }
                .disabled(nuevoComentario.trimmingCharacters(in: .whitespaces).isEmpty)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(Color(.systemBackground))
        }
        .navigationTitle("Comentarios")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            vm.cargarComentarios(idTarea: idTarea)
        }
        .alert("Error", isPresented: .constant(vm.errorMessage != nil)) {
            Button("OK") { vm.errorMessage = nil }
        } message: {
            Text(vm.errorMessage ?? "")
        }
    }
}

// MARK: - Fila de comentario
struct ComentarioRowView: View {

    let comentario: Comentario

    private let displayFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        f.locale = Locale(identifier: "es_SV")
        return f
    }()

    private let outputFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .medium
        f.timeStyle = .short
        f.locale = Locale(identifier: "es_SV")
        return f
    }()

    var fechaFormateada: String {
        guard let fechaStr = comentario.fechaCreacion,
              let fecha = displayFormatter.date(from: fechaStr)
        else { return comentario.fechaCreacion ?? "" }
        return outputFormatter.string(from: fecha)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                // Avatar inicial
                Text(String(comentario.autorNombre?.prefix(1) ?? "?").uppercased())
                    .font(.caption.bold())
                    .foregroundColor(.white)
                    .frame(width: 30, height: 30)
                    .background(Color.blue)
                    .clipShape(Circle())

                VStack(alignment: .leading, spacing: 2) {
                    Text(comentario.autorNombre ?? "Usuario")
                        .font(.subheadline.bold())
                    Text(fechaFormateada)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }

                Spacer()
            }

            Text(comentario.contenido)
                .font(.body)
                .padding(.leading, 38)
        }
        .padding(12)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
}
