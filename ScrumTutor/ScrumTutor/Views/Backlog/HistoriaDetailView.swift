// HistoriaDetailView.swift
import SwiftUI

struct HistoriaDetailView: View {

    let historia: Historia
    let idProyecto: Int
    @ObservedObject var vm: BacklogViewModel
    @State private var mostrarEditar: Bool = false

    var body: some View {
        List {
            Section("Información") {
                LabeledContent("Título", value: historia.titulo)
                if let desc = historia.descripcion, !desc.isEmpty {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Descripción").font(.caption).foregroundColor(.secondary)
                        Text(desc)
                    }
                }
                if let criterios = historia.criteriosAceptacion, !criterios.isEmpty {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Criterios de aceptación").font(.caption).foregroundColor(.secondary)
                        Text(criterios)
                    }
                }
            }

            Section("Estado") {
                LabeledContent("Prioridad", value: historia.prioridad ?? "—")
                LabeledContent("Estado", value: historia.estado ?? "—")
                if let idSprint = historia.idSprint {
                    LabeledContent("Sprint asignado", value: "Sprint #\(idSprint)")
                } else {
                    LabeledContent("Sprint", value: "Sin asignar")
                }
            }

            if let fecha = historia.fechaCreacion {
                Section {
                    LabeledContent("Creada", value: fecha)
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Detalle")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    mostrarEditar = true
                } label: {
                    Image(systemName: "pencil")
                }
            }
        }
        .sheet(isPresented: $mostrarEditar) {
            EditHistoriaView(historia: historia, idProyecto: idProyecto, vm: vm)
        }
    }
}
