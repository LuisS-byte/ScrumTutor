// ContentView.swift
import SwiftUI

struct ContentView: View {

    @EnvironmentObject var authVM: AuthViewModel

    var body: some View {
        Group {
            if authVM.isLoggedIn {
                MainTabView()
            } else {
                LoginView()
            }
        }
        .onAppear {
            authVM.checkSession()
        }
    }
}
