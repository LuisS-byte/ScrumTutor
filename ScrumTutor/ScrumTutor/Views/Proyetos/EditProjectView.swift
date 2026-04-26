// EditProjectView.swift
import SwiftUI

struct EditProjectView: View {

    @ObservedObject var vm: ProyectosViewModel
    let proyecto: Proyecto
    @Environment(\.dismiss) var dismiss

    @State private var nombre: String = ""
    @State private var descripcion: String = ""
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
                Section("Información del proyecto") {
                    TextField("Nombre", text: $nombre)
                    TextField("Descripción", text: $descripcion, axis: .vertical)
                        .lineLimit(3...6)
                }
                Section("Fechas") {
                    DatePicker("Fecha inicio", selection: $fechaInicio, displayedComponents: .date)
                    DatePicker("Fecha fin", selection: $fechaFin, displayedComponents: .date)
                }

                if let error = vm.error_message {
                    Section {
                        Text(error).foregroundColor(.red).font(.caption)
                    }
                }
            }
            .navigationTitle("Editar proyecto")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Guardar") {
                        vm.editarProyecto(
                            id: proyecto.id,
                            nombre: nombre,
                            descripcion: descripcion,
                            fechaInicio: formatter.string(from: fechaInicio),
                            fechaFin: formatter.string(from: fechaFin)
                        ) { ok in
                            if ok { dismiss() }
                        }
                    }
                    .disabled(nombre.isEmpty)
                }
            }
            .onAppear {
                nombre = proyecto.nombre
                descripcion = proyecto.descripcion ?? ""
                if let fi = proyecto.fechaInicio {
                    fechaInicio = formatter.date(from: fi) ?? Date()
                }
                if let ff = proyecto.fechaFin {
                    fechaFin = formatter.date(from: ff) ?? Date()
                }
            }
        }
    }
}
