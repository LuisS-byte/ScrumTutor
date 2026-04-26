// TareaDetailView.swift
import SwiftUI

struct TareaDetailView: View {

    let tarea: Tarea
    let idSprint: Int
    @ObservedObject var vm: TareaViewModel
    @Environment(\.dismiss) var dismiss
    @State private var mostrarEditar: Bool = false

    var estadoColor: Color {
        switch tarea.idEstado {
        case 1: return .gray
        case 2: return .blue
        case 3: return .green
        default: return .gray
        }
    }

    var body: some View {
        NavigationStack {
            List {
                Section("Información") {
                    LabeledContent("Título", value: tarea.titulo)
                    if let desc = tarea.descripcion, !desc.isEmpty {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Descripción")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(desc)
                        }
                    }
                }

                Section("Estado y asignación") {
                    LabeledContent("Estado") {
                        Text(tarea.estado ?? "—")
                            .foregroundColor(estadoColor)
                    }
                    LabeledContent("Asignado a", value: tarea.asignadoANombre ?? "Sin asignar")
                    if let fecha = tarea.fechaLimite {
                        LabeledContent("Fecha límite", value: fecha)
                    }
                }

                Section {
                    NavigationLink(destination: ComentariosView(idTarea: tarea.id)) {
                        Label("Ver comentarios", systemImage: "bubble.left.and.bubble.right")
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Detalle tarea")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        mostrarEditar = true
                    } label: {
                        Image(systemName: "pencil")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cerrar") { dismiss() }
                }
            }
            .sheet(isPresented: $mostrarEditar) {
                EditTareaView(tarea: tarea, idSprint: idSprint, vm: vm)
            }
        }
    }
}
