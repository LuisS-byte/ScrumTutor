// SprintDetailView.swift
import SwiftUI

struct SprintDetailView: View {

    let sprint: Sprint
    let idProyecto: Int
    @StateObject private var vm = SprintViewModel()
    @State private var mostrarEditar: Bool = false

    var body: some View {
        TabView {
            NavigationStack {
                BacklogSprintView(idSprint: sprint.id)
            }
            .tabItem { Label("Backlog", systemImage: "list.bullet") }

            NavigationStack {
                KanbanView(idSprint: sprint.id)
            }
            .tabItem { Label("Kanban", systemImage: "square.grid.3x1.fill.below.line.grid.1x2") }

            NavigationStack {
                CalendarioView(sprint: sprint)
            }
            .tabItem { Label("Calendario", systemImage: "calendar") }
        }
        .navigationTitle(sprint.nombre)
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
            EditSprintView(sprint: sprint, idProyecto: idProyecto, vm: vm)
        }
        .onAppear {
            vm.cargarSprints(idProyecto: idProyecto)
        }
    }
}
