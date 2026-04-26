// CreateSprintView.swift
import SwiftUI

struct CreateSprintView: View {

    let idProyecto: Int
    @ObservedObject var vm: SprintViewModel
    @Environment(\.dismiss) var dismiss

    @State private var nombre: String = ""
    @State private var objetivo: String = ""
    @State private var fechaInicio: Date = Date()
    @State private var fechaFin: Date = Date()

    private let formatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        return f
    }()

    var body: some View {
        NavigationStack {
            Form {
                Section("Información del sprint") {
                    TextField("Nombre", text: $nombre)
                    TextField("Objetivo", text: $objetivo, axis: .vertical)
                        .lineLimit(3...6)
                }
                Section("Fechas") {
                    DatePicker("Fecha inicio", selection: $fechaInicio, displayedComponents: .date)
                    DatePicker("Fecha fin", selection: $fechaFin, displayedComponents: .date)
                }

                if let error = vm.errorMessage {
                    Section {
                        Text(error).foregroundColor(.red).font(.caption)
                    }
                }
            }
            .navigationTitle("Nuevo sprint")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Crear") {
                        vm.crearSprint(
                            idProyecto: idProyecto,
                            nombre: nombre,
                            objetivo: objetivo,
                            fechaInicio: formatter.string(from: fechaInicio),
                            fechaFin: formatter.string(from: fechaFin)
                        ) { ok in if ok { dismiss() } }
                    }
                    .disabled(nombre.isEmpty)
                }
            }
        }
    }
}
