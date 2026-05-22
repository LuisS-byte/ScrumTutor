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
                        KanbanColumnaView(titulo: "Por hacer", color: .gray, tareas: vm.por_hacer, idSprint: idSprint, vm: vm)
                        KanbanColumnaView(titulo: "En progreso", color: .blue, tareas: vm.en_progreso, idSprint: idSprint, vm: vm)
                        KanbanColumnaView(titulo: "Completado", color: .green, tareas: vm.completadas, idSprint: idSprint, vm: vm)
                    }
                    .padding()
                }
            }

            AppFloatingButton {
                mostrarCrear = true
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
        .appErrorAlert(message: $vm.error_message)
    }
}

struct KanbanColumnaView: View {

    let titulo: String
    let color: Color
    let tareas: [Tarea]
    let idSprint: Int
    @ObservedObject var vm: TareaViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Circle()
                    .fill(color)
                    .frame(width: 10, height: 10)
                Text(titulo)
                    .font(.headline)
                Spacer()
                AppBadge(text: "\(tareas.count)", foregroundColor: color, backgroundColor: color.opacity(0.15))
            }
            .padding(.horizontal, 12)
            .padding(.top, 12)

            VStack(spacing: 10) {
                if tareas.isEmpty {
                    Text("Sin tareas")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding()
                } else {
                    ForEach(tareas) { tarea in
                        TareaCardView(tarea: tarea, idSprint: idSprint, vm: vm)
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
