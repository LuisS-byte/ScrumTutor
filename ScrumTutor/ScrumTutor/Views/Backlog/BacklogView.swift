// BacklogView.swift
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
                VStack(spacing: 12) {
                    Image(systemName: "list.bullet.clipboard")
                        .font(.system(size: 50))
                        .foregroundColor(.secondary)
                    Text("No hay historias de usuario")
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List {
                    if !vm.sinSprint.isEmpty {
                        Section("Sin sprint asignado") {
                            ForEach(vm.sinSprint) { historia in
                                NavigationLink(destination: HistoriaDetailView(
                                    historia: historia,
                                    idProyecto: idProyecto,
                                    vm: vm
                                )) {
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
                                NavigationLink(destination: HistoriaDetailView(
                                    historia: historia,
                                    idProyecto: idProyecto,
                                    vm: vm
                                )) {
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

            // Botón flotante
            Button {
                mostrarCrear = true
            } label: {
                Image(systemName: "plus")
                    .font(.title2.bold())
                    .foregroundColor(.white)
                    .frame(width: 56, height: 56)
                    .background(Color.blue)
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 3)
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
        .alert("Error", isPresented: .constant(vm.errorMessage != nil)) {
            Button("OK") { vm.errorMessage = nil }
        } message: {
            Text(vm.errorMessage ?? "")
        }
    }
}
// MARK: - Fila de historia
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
                    Text("Sprint #\(idSprint)")
                        .font(.caption2)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.blue.opacity(0.15))
                        .foregroundColor(.blue)
                        .cornerRadius(4)
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
        return Text(historia.prioridad ?? "—")
            .font(.caption2)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(color.opacity(0.15))
            .foregroundColor(color)
            .cornerRadius(4)
    }

    var estadoBadge: some View {
        Text(historia.estado ?? "—")
            .font(.caption2)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(Color.gray.opacity(0.15))
            .foregroundColor(.gray)
            .cornerRadius(4)
    }
}
