import SwiftUI

struct MainTabView: View {

    var body: some View {
        TabView {
            NavigationStack {
                ProyectosView()
            }
            .tabItem {
                Label("Proyectos", systemImage: "folder.fill")
            }

            NavigationStack {
                NotificacionesView()
            }
            .tabItem {
                Label("Notificaciones", systemImage: "bell.fill")
            }

            NavigationStack {
                PerfilView()
            }
            .tabItem {
                Label("Perfil", systemImage: "person.fill")
            }

            NavigationStack {
                LearningView()
            }
            .tabItem {
                Label("Learning", systemImage: "book.fill")
            }
        }
    }
}
