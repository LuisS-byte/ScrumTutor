// TareaCardView.swift
import SwiftUI

struct TareaCardView: View {

    let tarea: Tarea
    let idSprint: Int
    @ObservedObject var vm: TareaViewModel
    @State private var mostrarDetalle: Bool = false

    var estadoColor: Color {
        switch tarea.idEstado {
        case 1: return .gray
        case 2: return .blue
        case 3: return .green
        default: return .gray
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(tarea.titulo)
                .font(.subheadline.bold())
                .lineLimit(2)

            if let desc = tarea.descripcion, !desc.isEmpty {
                Text(desc)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }

            if let asignado = tarea.asignadoANombre {
                HStack(spacing: 4) {
                    Image(systemName: "person.fill")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    Text(asignado)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }

            if let fecha = tarea.fechaLimite {
                HStack(spacing: 4) {
                    Image(systemName: "calendar")
                        .font(.caption2)
                        .foregroundColor(.orange)
                    Text(fecha)
                        .font(.caption2)
                        .foregroundColor(.orange)
                }
            }

            // Botones mover estado
            HStack(spacing: 8) {
                if tarea.idEstado ?? 1 > 1 {
                    Button {
                        vm.cambiarEstado(
                            tarea: tarea,
                            nuevoEstado: (tarea.idEstado ?? 1) - 1,
                            idSprint: idSprint
                        )
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.caption)
                            .padding(6)
                            .background(Color.gray.opacity(0.15))
                            .cornerRadius(6)
                    }
                }

                Spacer()

                Button {
                    mostrarDetalle = true
                } label: {
                    Image(systemName: "info.circle")
                        .font(.caption)
                        .foregroundColor(.blue)
                }

                Spacer()

                if tarea.idEstado ?? 1 < 3 {
                    Button {
                        vm.cambiarEstado(
                            tarea: tarea,
                            nuevoEstado: (tarea.idEstado ?? 1) + 1,
                            idSprint: idSprint
                        )
                    } label: {
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .padding(6)
                            .background(Color.blue.opacity(0.15))
                            .foregroundColor(.blue)
                            .cornerRadius(6)
                    }
                }
            }
        }
        .padding(12)
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.06), radius: 3, x: 0, y: 2)
        .sheet(isPresented: $mostrarDetalle) {
            TareaDetailView(tarea: tarea, idSprint: idSprint, vm: vm)
        }
    }
}
