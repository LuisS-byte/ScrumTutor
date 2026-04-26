// ScrumTutorApp.swift
import SwiftUI

@main
struct ScrumTutorApp: App {

    @StateObject private var authVM = AuthViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authVM)
        }
    }
}
