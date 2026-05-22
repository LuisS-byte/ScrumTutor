import SwiftUI

struct BacklogView: View {

    let idProyecto: Int
    @StateObject private var vm = BacklogViewModel()
    @State private var mostrarCrear: Bool = false

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            if vm.isLoading {
                ProgressView("Cargando backlog...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if vm.historias.isEmpty {
                AppEmptyStateView(
                    icon: "list.bullet.clipboard",
                    title: "No hay historias de usuario",
                    message: "Crea una historia para empezar a poblar el backlog del proyecto."
                )
            } else {
                List {
                    if !vm.sinSprint.isEmpty {
                        Section("Sin sprint asignado") {
                            ForEach(vm.sinSprint) { historia in
                                NavigationLink(destination: HistoriaDetailView(historia: historia, idProyecto: idProyecto, vm: vm)) {
                                    HistoriaRowView(historia: historia)
                                }
                                .swipeActions(edge: .trailing) {
                                    Button(role: .destructive) {
                                        vm.eliminarHistoria(id: historia.id, idProyecto: idProyecto)
                                    } label: {
                                        Label("Eliminar", systemImage: "trash")
                                    }
                                }
                            }
                        }
                    }
                    if !vm.conSprint.isEmpty {
                        Section("Asignadas a sprint") {
                            ForEach(vm.conSprint) { historia in
                                NavigationLink(destination: HistoriaDetailView(historia: historia, idProyecto: idProyecto, vm: vm)) {
                                    HistoriaRowView(historia: historia)
                                }
                                .swipeActions(edge: .trailing) {
                                    Button(role: .destructive) {
                                        vm.eliminarHistoria(id: historia.id, idProyecto: idProyecto)
                                    } label: {
                                        Label("Eliminar", systemImage: "trash")
                                    }
                                }
                            }
                        }
                    }
                }
                .listStyle(.insetGrouped)
            }

            AppFloatingButton {
                mostrarCrear = true
            }
            .padding(.trailing, 24)
            .padding(.bottom, 40)
        }
        .navigationTitle("Backlog")
        .sheet(isPresented: $mostrarCrear) {
            CreateHistoriaView(idProyecto: idProyecto, vm: vm)
        }
        .onAppear {
            vm.cargarHistorias(idProyecto: idProyecto)
        }
        .appErrorAlert(message: $vm.errorMessage)
    }
}

struct HistoriaRowView: View {

    let historia: Historia

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(historia.titulo)
                .font(.headline)
            HStack(spacing: 8) {
                prioridadBadge
                estadoBadge
                if let idSprint = historia.idSprint {
                    AppBadge(
                        text: "Sprint #\(idSprint)",
                        foregroundColor: .blue,
                        backgroundColor: Color.blue.opacity(0.15)
                    )
                }
            }
        }
        .padding(.vertical, 4)
    }

    var prioridadBadge: some View {
        let color: Color
        switch historia.idPrioridad {
        case 1: color = .red
        case 2: color = .orange
        default: color = .green
        }

        return AppBadge(
            text: historia.prioridad ?? "-",
            foregroundColor: color,
            backgroundColor: color.opacity(0.15)
        )
    }

    var estadoBadge: some View {
        AppBadge(
            text: historia.estado ?? "-",
            foregroundColor: .gray,
            backgroundColor: Color.gray.opacity(0.15)
        )
    }
}
