// RegisterView.swift
import SwiftUI

struct RegisterView: View {

    @EnvironmentObject var authVM: AuthViewModel
    @Environment(\.dismiss) var dismiss

    @State private var nombre: String = ""
    @State private var correo: String = ""
    @State private var contrasena: String = ""

    var body: some View {
        VStack(spacing: 24) {

            Spacer()

            VStack(spacing: 8) {
                Image(systemName: "person.badge.plus")
                    .font(.system(size: 50))
                    .foregroundColor(.blue)
                Text("Crear cuenta")
                    .font(.largeTitle.bold())
            }

            Spacer()

            VStack(spacing: 16) {
                TextField("Nombre completo", text: $nombre)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)

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

            // Botón registro
            Button {
                authVM.register(nombre: nombre, correo: correo, contrasena: contrasena)
            } label: {
                if authVM.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .padding()
                } else {
                    Text("Crear cuenta")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .disabled(authVM.isLoading)

            Button {
                dismiss()
            } label: {
                Text("¿Ya tienes cuenta? ")
                    .foregroundColor(.secondary) +
                Text("Inicia sesión")
                    .foregroundColor(.blue)
                    .bold()
            }

            Spacer()
        }
        .padding(.horizontal, 24)
        .navigationBarBackButtonHidden(true)
    }
}
