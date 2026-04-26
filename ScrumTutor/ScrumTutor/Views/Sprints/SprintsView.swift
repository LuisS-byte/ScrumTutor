// SprintsView.swift
import SwiftUI

struct SprintsView: View {

    let idProyecto: Int
    @StateObject private var vm = SprintViewModel()
    @State private var mostrarCrear: Bool = false

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Group {
                if vm.isLoading {
                    ProgressView("Cargando sprints...")
                } else if vm.sprints.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "bolt.circle")
                            .font(.system(size: 50))
                            .foregroundColor(.secondary)
                        Text("No hay sprints creados")
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        ForEach(vm.sprints) { sprint in
                            NavigationLink(destination: SprintDetailView(
                                sprint: sprint,
                                idProyecto: idProyecto
                            )) {
                                SprintRowView(sprint: sprint)
                            }
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    vm.eliminarSprint(id: sprint.id, idProyecto: idProyecto)
                                } label: {
                                    Label("Eliminar", systemImage: "trash")
                                }

                                Button {
                                    // editar — se maneja desde SprintDetailView
                                } label: {
                                    Label("Editar", systemImage: "pencil")
                                }
                                .tint(.orange)
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }

            // Botón flotante +
            Button {
                mostrarCrear = true
            } label: {
                Image(systemName: "plus")
                    .font(.title2.bold())
                    .foregroundColor(.white)
                    .padding(18)
                    .background(Color.blue)
                    .clipShape(Circle())
                    .shadow(radius: 4)
            }
            .padding(.trailing, 24)
            .padding(.bottom, 24)
        }
        .navigationTitle("Sprints")
        .sheet(isPresented: $mostrarCrear) {
            CreateSprintView(idProyecto: idProyecto, vm: vm)
        }
        .onAppear {
            vm.cargarSprints(idProyecto: idProyecto)
        }
        .alert("Error", isPresented: .constant(vm.errorMessage != nil)) {
            Button("OK") { vm.errorMessage = nil }
        } message: {
            Text(vm.errorMessage ?? "")
        }
    }
}

// MARK: - Fila de sprint
struct SprintRowView: View {

    let sprint: Sprint

    var estadoColor: Color {
        switch sprint.idEstado {
        case 1: return .gray
        case 2: return .blue
        case 3: return .green
        default: return .gray
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(sprint.nombre)
                    .font(.headline)
                Spacer()
                Text(sprint.estadoDescripcion ?? "—")
                    .font(.caption2)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(estadoColor.opacity(0.15))
                    .foregroundColor(estadoColor)
                    .cornerRadius(6)
            }
            if let objetivo = sprint.objetivo, !objetivo.isEmpty {
                Text(objetivo)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            if let inicio = sprint.fechaInicio, let fin = sprint.fechaFin {
                Text("\(inicio) → \(fin)")
                    .font(.caption2)
                    .foregroundColor(.blue)
            }
        }
        .padding(.vertical, 4)
    }
}
