// MainTabView.swift
import SwiftUI

struct MainTabView: View {

    @EnvironmentObject var authVM: AuthViewModel

    var body: some View {
        TabView {
            ProyectosView()
                .tabItem {
                    Label("Proyectos", systemImage: "folder.fill")
                }

            NotificacionesView()
                .tabItem {
                    Label("Notificaciones", systemImage: "bell.fill")
                }

            // Perfil temporal con botón de logout
            VStack(spacing: 20) {
                Text("Perfil")
                    .font(.largeTitle.bold())
                Button("Cerrar sesión") {
                    authVM.logout()
                }
                .foregroundColor(.red)
            }
            .tabItem {
                Label("Perfil", systemImage: "person.fill")
            }

            LearningView()
                .tabItem {
                    Label("Learning", systemImage: "book.fill")
                }
        }
    }
}
