// CreateHistoriaView.swift
import SwiftUI

struct CreateHistoriaView: View {

    let idProyecto: Int
    @ObservedObject var vm: BacklogViewModel
    @Environment(\.dismiss) var dismiss

    @State private var titulo: String = ""
    @State private var descripcion: String = ""
    @State private var criterios: String = ""
    @State private var idPrioridad: Int = 1
    @State private var idEstado: Int = 1

    let prioridades = ["Alta", "Media", "Baja"]
    let estados = ["Por hacer", "En progreso", "Completado"]

    var body: some View {
        NavigationStack {
            Form {
                Section("Historia de usuario") {
                    TextField("Título", text: $titulo)
                    TextField("Descripción", text: $descripcion, axis: .vertical)
                        .lineLimit(3...6)
                    TextField("Criterios de aceptación", text: $criterios, axis: .vertical)
                        .lineLimit(3...6)
                }

                Section("Configuración") {
                    Picker("Prioridad", selection: $idPrioridad) {
                        ForEach(0..<prioridades.count, id: \.self) { i in
                            Text(prioridades[i]).tag(i + 1)
                        }
                    }
                    Picker("Estado", selection: $idEstado) {
                        ForEach(0..<estados.count, id: \.self) { i in
                            Text(estados[i]).tag(i + 1)
                        }
                    }
                }

                if let error = vm.errorMessage {
                    Section {
                        Text(error).foregroundColor(.red).font(.caption)
                    }
                }
            }
            .navigationTitle("Nueva historia")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Crear") {
                        vm.crearHistoria(
                            idProyecto: idProyecto,
                            titulo: titulo,
                            descripcion: descripcion,
                            idPrioridad: idPrioridad,
                            criterios: criterios,
                            idEstado: idEstado
                        ) { ok in if ok { dismiss() } }
                    }
                    .disabled(titulo.isEmpty)
                }
            }
        }
    }
}
