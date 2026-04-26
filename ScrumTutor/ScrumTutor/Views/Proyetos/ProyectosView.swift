// ProyectosView.swift
import SwiftUI

struct ProyectosView: View {

    @StateObject private var vm = ProyectosViewModel()
    @State private var mostrarCrear: Bool = false

    var body: some View {
        NavigationStack {
            Group {
                if vm.is_loading {
                    ProgressView("Cargando proyectos...")
                } else if vm.proyectos.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "folder.badge.plus")
                            .font(.system(size: 50))
                            .foregroundColor(.secondary)
                        Text("No tienes proyectos aún")
                            .foregroundColor(.secondary)
                    }
                } else {
                    List {
                        ForEach(vm.proyectos) { proyecto in
                            NavigationLink(destination: ProyectoDetailView(proyecto: proyecto)) {
                                ProyectoRowView(proyecto: proyecto, vm: vm)
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("Proyectos")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        mostrarCrear = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $mostrarCrear) {
                CreateProjectView(vm: vm)
            }
            .onAppear {
                vm.cargarProyectos()
            }
            .onReceive(NotificationCenter.default.publisher(for: .proyectosDidChange)) { _ in
                vm.cargarProyectos()
            }
            .alert("Error", isPresented: .constant(vm.error_message != nil)) {
                Button("OK") { vm.error_message = nil }
            } message: {
                Text(vm.error_message ?? "")
            }
        }
    }
}

// MARK: - Fila de proyecto
struct ProyectoRowView: View {

    let proyecto: Proyecto
    let vm: ProyectosViewModel
    @State private var mostrarEditar: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(proyecto.nombre)
                .font(.headline)
            if let desc = proyecto.descripcion, !desc.isEmpty {
                Text(desc)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            if let inicio = proyecto.fechaInicio, let fin = proyecto.fechaFin {
                Text("\(inicio) → \(fin)")
                    .font(.caption2)
                    .foregroundColor(.blue)
            }
        }
        .padding(.vertical, 4)
        .swipeActions(edge: .trailing) {
            if vm.esCreador(proyecto: proyecto) {
                Button(role: .destructive) {
                    vm.eliminarProyecto(id: proyecto.id)
                } label: {
                    Label("Eliminar", systemImage: "trash")
                }
                Button {
                    mostrarEditar = true
                } label: {
                    Label("Editar", systemImage: "pencil")
                }
                .tint(.orange)
            }
        }
        .sheet(isPresented: $mostrarEditar) {
            EditProjectView(vm: vm, proyecto: proyecto)
        }
    }
}
