// CreateTareaView.swift
import SwiftUI

struct CreateTareaView: View {

    let idSprint: Int
    @ObservedObject var vm: TareaViewModel
    @Environment(\.dismiss) var dismiss

    @State private var titulo: String = ""
    @State private var descripcion: String = ""
    @State private var idEstado: Int = 1
    @State private var fechaLimite: Date = Date()
    @State private var usarFechaLimite: Bool = false

    let estados = ["Por hacer", "En progreso", "Completado"]

    private let formatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        return f
    }()

    var body: some View {
        NavigationStack {
            Form {
                Section("Tarea") {
                    TextField("Título", text: $titulo)
                    TextField("Descripción", text: $descripcion, axis: .vertical)
                        .lineLimit(3...6)
                }

                Section("Configuración") {
                    Picker("Estado inicial", selection: $idEstado) {
                        ForEach(0..<estados.count, id: \.self) { i in
                            Text(estados[i]).tag(i + 1)
                        }
                    }
                    Toggle("Agregar fecha límite", isOn: $usarFechaLimite)
                    if usarFechaLimite {
                        DatePicker("Fecha límite", selection: $fechaLimite,
                                   displayedComponents: .date)
                    }
                }

                if let error = vm.error_message {
                    Section {
                        Text(error).foregroundColor(.red).font(.caption)
                    }
                }
            }
            .navigationTitle("Nueva tarea")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Crear") {
                        vm.crearTarea(
                            idSprint: idSprint,
                            titulo: titulo,
                            descripcion: descripcion,
                            idEstado: idEstado,
                            idAsignadoA: nil,
                            fechaLimite: usarFechaLimite ? formatter.string(from: fechaLimite) : nil
                        ) { ok in if ok { dismiss() } }
                    }
                    .disabled(titulo.isEmpty)
                }
            }
        }
    }
}
