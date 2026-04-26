// CalendarioView.swift
import SwiftUI

struct CalendarioView: View {

    let sprint: Sprint

    private let formatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        return f
    }()

    private let displayFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .long
        f.locale = Locale(identifier: "es_SV")
        return f
    }()

    var fechaInicioDate: Date? {
        guard let fi = sprint.fechaInicio else { return nil }
        return formatter.date(from: fi)
    }

    var fechaFinDate: Date? {
        guard let ff = sprint.fechaFin else { return nil }
        return formatter.date(from: ff)
    }

    var duracionDias: Int? {
        guard let inicio = fechaInicioDate, let fin = fechaFinDate else { return nil }
        return Calendar.current.dateComponents([.day], from: inicio, to: fin).day
    }

    var body: some View {
        List {
            Section("Fechas del sprint") {
                if let inicio = fechaInicioDate {
                    LabeledContent("Inicio") {
                        Text(displayFormatter.string(from: inicio))
                            .foregroundColor(.blue)
                    }
                }
                if let fin = fechaFinDate {
                    LabeledContent("Fin") {
                        Text(displayFormatter.string(from: fin))
                            .foregroundColor(.blue)
                    }
                }
                if let dias = duracionDias {
                    LabeledContent("Duración") {
                        Text("\(dias) días")
                            .foregroundColor(.secondary)
                    }
                }
            }

            Section("Estado") {
                LabeledContent("Estado actual") {
                    Text(sprint.estadoDescripcion ?? "—")
                        .foregroundColor(colorEstado)
                }
            }

            Section("Sprint") {
                LabeledContent("Nombre", value: sprint.nombre)
                if let objetivo = sprint.objetivo, !objetivo.isEmpty {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Objetivo")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(objetivo)
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Calendario")
    }

    var colorEstado: Color {
        switch sprint.idEstado {
        case 1: return .gray
        case 2: return .blue
        case 3: return .green
        default: return .gray
        }
    }
}
