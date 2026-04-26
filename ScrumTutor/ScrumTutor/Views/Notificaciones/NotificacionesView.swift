// NotificacionesView.swift
import SwiftUI

struct NotificacionesView: View {

    @StateObject private var vm = NotificacionViewModel()

    var body: some View {
        NavigationStack {
            Group {
                if vm.isLoading {
                    ProgressView("Cargando notificaciones...")
                } else if vm.notificaciones.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "bell.slash")
                            .font(.system(size: 50))
                            .foregroundColor(.secondary)
                        Text("Sin notificaciones nuevas")
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        ForEach(vm.notificaciones) { notificacion in
                            NotificacionRowView(
                                notificacion: notificacion,
                                vm: vm
                            )
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("Notificaciones")
            .onAppear {
                vm.cargarNotificaciones()
            }
            .alert("Error", isPresented: .constant(vm.errorMessage != nil)) {
                Button("OK") { vm.errorMessage = nil }
            } message: {
                Text(vm.errorMessage ?? "")
            }
        }
    }
}

// MARK: - Fila de notificación
struct NotificacionRowView: View {

    let notificacion: Notificacion
    @ObservedObject var vm: NotificacionViewModel
    @State private var mostrarModalInvitacion: Bool = false

    var esInvitacion: Bool { notificacion.idTipo == 5 }

    var body: some View {
        Button {
            if esInvitacion {
                mostrarModalInvitacion = true
            }
        } label: {
            HStack(spacing: 12) {
                // Ícono según tipo
                Image(systemName: esInvitacion ? "person.badge.plus" : "bell.fill")
                    .font(.title2)
                    .foregroundColor(esInvitacion ? .blue : .orange)
                    .frame(width: 40, height: 40)
                    .background(
                        (esInvitacion ? Color.blue : Color.orange).opacity(0.1)
                    )
                    .clipShape(Circle())

                VStack(alignment: .leading, spacing: 4) {
                    Text(esInvitacion ? "Invitación a proyecto" : "Notificación")
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text(notificacion.mensaje ?? "")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }

                Spacer()

                if esInvitacion {
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.vertical, 4)
        }
        .sheet(isPresented: $mostrarModalInvitacion) {
            if let idProyecto = notificacion.idProyecto {
                ModalInvitacionView(
                    notificacion: notificacion,
                    idProyecto: idProyecto,
                    vm: vm
                )
            }
        }
    }
}
