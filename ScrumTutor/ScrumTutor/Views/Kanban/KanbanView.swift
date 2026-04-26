// KanbanView.swift
import SwiftUI

struct KanbanView: View {

    let idSprint: Int
    @StateObject private var vm = TareaViewModel()
    @State private var mostrarCrear: Bool = false

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            if vm.is_loading {
                ProgressView("Cargando tareas...")
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .top, spacing: 16) {
                        KanbanColumnaView(
                            titulo: "Por hacer",
                            color: .gray,
                            tareas: vm.por_hacer,
                            idSprint: idSprint,
                            nuevoEstado: 1,
                            vm: vm
                        )
                        KanbanColumnaView(
                            titulo: "En progreso",
                            color: .blue,
                            tareas: vm.en_progreso,
                            idSprint: idSprint,
                            nuevoEstado: 2,
                            vm: vm
                        )
                        KanbanColumnaView(
                            titulo: "Completado",
                            color: .green,
                            tareas: vm.completadas,
                            idSprint: idSprint,
                            nuevoEstado: 3,
                            vm: vm
                        )
                    }
                    .padding()
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
        .navigationTitle("Kanban")
        .sheet(isPresented: $mostrarCrear) {
            CreateTareaView(idSprint: idSprint, vm: vm)
        }
        .onAppear {
            vm.cargarTareas(idSprint: idSprint)
        }
        .alert("Error", isPresented: .constant(vm.error_message != nil)) {
            Button("OK") { vm.error_message = nil }
        } message: {
            Text(vm.error_message ?? "")
        }
    }
}

// MARK: - Columna del Kanban
struct KanbanColumnaView: View {

    let titulo: String
    let color: Color
    let tareas: [Tarea]
    let idSprint: Int
    let nuevoEstado: Int
    @ObservedObject var vm: TareaViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header columna
            HStack {
                Circle()
                    .fill(color)
                    .frame(width: 10, height: 10)
                Text(titulo)
                    .font(.headline)
                Spacer()
                Text("\(tareas.count)")
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(color.opacity(0.15))
                    .foregroundColor(color)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 12)
            .padding(.top, 12)

            // Tarjetas
            VStack(spacing: 10) {
                if tareas.isEmpty {
                    Text("Sin tareas")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding()
                } else {
                    ForEach(tareas) { tarea in
                        TareaCardView(
                            tarea: tarea,
                            idSprint: idSprint,
                            vm: vm
                        )
                    }
                }
            }
            .padding(.horizontal, 8)
            .padding(.bottom, 12)
        }
        .frame(width: 260)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(14)
    }
}
