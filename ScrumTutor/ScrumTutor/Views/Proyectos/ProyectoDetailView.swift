// ProyectoDetailView.swift
import SwiftUI

struct ProyectoDetailView: View {

    let proyecto: Proyecto

    var body: some View {
        TabView {
            BacklogView(idProyecto: proyecto.id)
                .tabItem { Label("Backlog", systemImage: "list.bullet") }

            SprintsView(idProyecto: proyecto.id)
                .tabItem { Label("Sprints", systemImage: "bolt.fill") }

            MiembrosView(idProyecto: proyecto.id)
                .tabItem { Label("Miembros", systemImage: "person.2.fill") }
        }
        .navigationTitle(proyecto.nombre)
        .navigationBarTitleDisplayMode(.inline)
    }
}
