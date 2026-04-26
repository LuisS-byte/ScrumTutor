// EditTareaView.swift
import SwiftUI

struct EditTareaView: View {

    let tarea: Tarea
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
                    Picker("Estado", selection: $idEstado) {
                        ForEach(0..<estados.count, id: \.self) { i in
                            Text(estados[i]).tag(i + 1)
                        }
                    }
                    Toggle("Fecha límite", isOn: $usarFechaLimite)
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
            .navigationTitle("Editar tarea")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Guardar") {
                        vm.editarTarea(
                            id: tarea.id,
                            idSprint: idSprint,
                            titulo: titulo,
                            descripcion: descripcion,
                            idEstado: idEstado,
                            idAsignadoA: tarea.idAsignadoA,
                            fechaLimite: usarFechaLimite ? formatter.string(from: fechaLimite) : nil
                        ) { ok in if ok { dismiss() } }
                    }
                    .disabled(titulo.isEmpty)
                }
            }
            .onAppear {
                titulo = tarea.titulo
                descripcion = tarea.descripcion ?? ""
                idEstado = tarea.idEstado ?? 1
                if let fl = tarea.fechaLimite,
                   let fecha = formatter.date(from: fl) {
                    usarFechaLimite = true
                    fechaLimite = fecha
                }
            }
        }
    }
}
