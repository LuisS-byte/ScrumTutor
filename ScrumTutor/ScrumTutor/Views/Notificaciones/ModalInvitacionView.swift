// ModalInvitacionView.swift
import SwiftUI

struct ModalInvitacionView: View {

    let notificacion: Notificacion
    let idProyecto: Int
    @ObservedObject var vm: NotificacionViewModel
    @Environment(\.dismiss) var dismiss

    @State private var nombreProyecto: String = "Cargando..."
    @State private var isLoading: Bool = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 32) {
                Spacer()

                // Ícono
                Image(systemName: "person.badge.plus.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.blue)

                VStack(spacing: 8) {
                    Text("Invitación a proyecto")
                        .font(.title2.bold())
                    Text("Te han invitado a unirte a:")
                        .foregroundColor(.secondary)
                    Text(nombreProyecto)
                        .font(.title3.bold())
                        .foregroundColor(.blue)
                }

                if let mensaje = notificacion.mensaje {
                    Text(mensaje)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }

                Spacer()

                // Botones
                VStack(spacing: 12) {
                    Button {
                        isLoading = true
                        vm.aceptarInvitacion(
                            idProyecto: idProyecto,
                            idNotificacion: notificacion.id
                        )
                        dismiss()
                    } label: {
                        Text("Aceptar invitación")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }

                    Button {
                        vm.rechazarInvitacion(
                            idProyecto: idProyecto,
                            idNotificacion: notificacion.id
                        )
                        dismiss()
                    } label: {
                        Text("Rechazar")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red.opacity(0.1))
                            .foregroundColor(.red)
                            .cornerRadius(12)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cerrar") { dismiss() }
                }
            }
            .onAppear {
                cargarNombreProyecto()
            }
        }
    }

    func cargarNombreProyecto() {
        NetworkManager.shared.request(
            path: APIConstants.Proyectos.byId(idProyecto),
            method: "GET",
            responseType: Proyecto.self
        ) { result in
            if case .success(let proyecto) = result {
                nombreProyecto = proyecto.nombre
            }
        }
    }
}
