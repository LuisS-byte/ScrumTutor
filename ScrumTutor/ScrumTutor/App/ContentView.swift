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
        .alert("Sesion", isPresented: .constant(authVM.globalMessage != nil)) {
            Button("OK") { authVM.globalMessage = nil }
        } message: {
            Text(authVM.globalMessage ?? "")
        }
    }
}
