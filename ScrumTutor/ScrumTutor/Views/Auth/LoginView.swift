// LoginView.swift
import SwiftUI

struct LoginView: View {

    @EnvironmentObject var authVM: AuthViewModel

    @State private var correo: String = ""
    @State private var contrasena: String = ""
    @State private var irARegistro: Bool = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {

                Spacer()

                // Logo / Título
                VStack(spacing: 8) {
                    Image(systemName: "checkmark.seal.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.blue)
                    Text("ScrumTutor")
                        .font(.largeTitle.bold())
                    Text("Gestión ágil de proyectos")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                Spacer()

                // Formulario
                VStack(spacing: 16) {
                    TextField("Correo electrónico", text: $correo)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)

                    SecureField("Contraseña", text: $contrasena)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                }

                // Error
                if let error = authVM.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.caption)
                        .multilineTextAlignment(.center)
                }

                // Botón login
                Button {
                    authVM.login(correo: correo, contrasena: contrasena)
                } label: {
                    if authVM.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .padding()
                    } else {
                        Text("Iniciar sesión")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .disabled(authVM.isLoading)

                // Ir a registro
                Button {
                    irARegistro = true
                } label: {
                    Text("¿No tienes cuenta? ")
                        .foregroundColor(.secondary) +
                    Text("Regístrate")
                        .foregroundColor(.blue)
                        .bold()
                }

                Spacer()
            }
            .padding(.horizontal, 24)
            .navigationDestination(isPresented: $irARegistro) {
                RegisterView()
            }
        }
    }
}
