import SwiftUI

struct NotificacionesView: View {

    @StateObject private var vm = NotificacionViewModel()

    var body: some View {
        Group {
            if vm.isLoading {
                ProgressView("Cargando notificaciones...")
            } else if vm.notificaciones.isEmpty {
                AppEmptyStateView(
                    icon: "bell.slash",
                    title: "Sin notificaciones nuevas",
                    message: "Cuando haya invitaciones o avisos importantes van a aparecer aca."
                )
            } else {
                List {
                    ForEach(vm.notificaciones) { notificacion in
                        NotificacionRowView(notificacion: notificacion, vm: vm)
                    }
                }
                .listStyle(.insetGrouped)
            }
        }
        .navigationTitle("Notificaciones")
        .onAppear {
            vm.cargarNotificaciones()
        }
        .appErrorAlert(message: $vm.errorMessage)
    }
}

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
                Image(systemName: esInvitacion ? "person.badge.plus" : "bell.fill")
                    .font(.title2)
                    .foregroundColor(esInvitacion ? .blue : .orange)
                    .frame(width: 40, height: 40)
                    .background((esInvitacion ? Color.blue : Color.orange).opacity(0.1))
                    .clipShape(Circle())

                VStack(alignment: .leading, spacing: 4) {
                    Text(esInvitacion ? "Invitacion a proyecto" : "Notificacion")
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text(notificacion.mensaje ?? "")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }

                Spacer()

                if esInvitacion {
                    AppBadge(
                        text: "Pendiente",
                        foregroundColor: .blue,
                        backgroundColor: Color.blue.opacity(0.12)
                    )
                }
            }
            .padding(.vertical, 4)
        }
        .buttonStyle(.plain)
        .sheet(isPresented: $mostrarModalInvitacion) {
            if let idProyecto = notificacion.idProyecto {
                ModalInvitacionView(notificacion: notificacion, idProyecto: idProyecto, vm: vm)
            }
        }
    }
}
