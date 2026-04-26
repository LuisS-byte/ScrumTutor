// EditSprintView.swift
import SwiftUI

struct EditSprintView: View {

    let sprint: Sprint
    let idProyecto: Int
    @ObservedObject var vm: SprintViewModel
    @Environment(\.dismiss) var dismiss

    @State private var nombre: String = ""
    @State private var objetivo: String = ""
    @State private var fechaInicio: Date = Date()
    @State private var fechaFin: Date = Date()
    @State private var idEstado: Int = 1

    let estados = ["Planeación", "Activo", "Completado"]

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
                Section("Estado") {
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
            .navigationTitle("Editar sprint")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Guardar") {
                        vm.editarSprint(
                            id: sprint.id,
                            idProyecto: idProyecto,
                            nombre: nombre,
                            objetivo: objetivo,
                            fechaInicio: formatter.string(from: fechaInicio),
                            fechaFin: formatter.string(from: fechaFin),
                            idEstado: idEstado
                        ) { ok in if ok { dismiss() } }
                    }
                    .disabled(nombre.isEmpty)
                }
            }
            .onAppear {
                nombre = sprint.nombre
                objetivo = sprint.objetivo ?? ""
                if let fi = sprint.fechaInicio {
                    fechaInicio = formatter.date(from: fi) ?? Date()
                }
                if let ff = sprint.fechaFin {
                    fechaFin = formatter.date(from: ff) ?? Date()
                }
                idEstado = sprint.idEstado ?? 1
            }
        }
    }
}
