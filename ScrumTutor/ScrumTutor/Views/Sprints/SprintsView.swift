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
                    AppEmptyStateView(
                        icon: "bolt.circle",
                        title: "No hay sprints creados",
                        message: "Defini un sprint para empezar a planificar entregas."
                    )
                } else {
                    List {
                        ForEach(vm.sprints) { sprint in
                            NavigationLink(destination: SprintDetailView(sprint: sprint, idProyecto: idProyecto)) {
                                SprintRowView(sprint: sprint)
                            }
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    vm.eliminarSprint(id: sprint.id, idProyecto: idProyecto)
                                } label: {
                                    Label("Eliminar", systemImage: "trash")
                                }

                                Button {
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

            AppFloatingButton {
                mostrarCrear = true
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
        .appErrorAlert(message: $vm.errorMessage)
    }
}

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
                AppBadge(
                    text: sprint.estadoDescripcion ?? "-",
                    foregroundColor: estadoColor,
                    backgroundColor: estadoColor.opacity(0.15)
                )
            }
            if let objetivo = sprint.objetivo, !objetivo.isEmpty {
                Text(objetivo)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            if let inicio = sprint.fechaInicio, let fin = sprint.fechaFin {
                Text("\(inicio) -> \(fin)")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}
