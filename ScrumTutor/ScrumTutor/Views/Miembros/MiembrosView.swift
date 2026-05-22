import SwiftUI

struct MiembrosView: View {

    let idProyecto: Int
    @StateObject private var vm = MiembrosViewModel()
    @State private var mostrarInvitar: Bool = false

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Group {
                if vm.isLoading {
                    ProgressView("Cargando miembros...")
                } else if vm.miembros.isEmpty {
                    AppEmptyStateView(
                        icon: "person.2",
                        title: "No hay miembros en este proyecto",
                        message: "Invita personas para colaborar en el proyecto."
                    )
                } else {
                    List {
                        ForEach(vm.miembros) { miembro in
                            MiembroRowView(miembro: miembro)
                                .swipeActions(edge: .trailing) {
                                    if vm.esProductOwner(idProyecto: idProyecto) {
                                        Button(role: .destructive) {
                                            vm.eliminarMiembro(idProyecto: idProyecto, idMiembro: miembro.id)
                                        } label: {
                                            Label("Eliminar", systemImage: "trash")
                                        }
                                    }
                                }
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }

            if vm.esProductOwner(idProyecto: idProyecto) {
                AppFloatingButton(systemImage: "person.badge.plus") {
                    mostrarInvitar = true
                }
                .padding(.trailing, 24)
                .padding(.bottom, 24)
            }
        }
        .navigationTitle("Miembros")
        .sheet(isPresented: $mostrarInvitar) {
            InvitarMiembroView(idProyecto: idProyecto, vm: vm)
        }
        .onAppear {
            vm.cargarMiembros(idProyecto: idProyecto)
            vm.cargarRoles()
        }
        .appErrorAlert(message: $vm.errorMessage)
    }
}

struct MiembroRowView: View {

    let miembro: Miembro

    var body: some View {
        HStack(spacing: 12) {
            Text(String(miembro.usuarioNombre?.prefix(1) ?? "?").uppercased())
                .font(.headline.bold())
                .foregroundColor(.white)
                .frame(width: 40, height: 40)
                .background(Color.blue)
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 4) {
                Text(miembro.usuarioNombre ?? "Sin nombre")
                    .font(.headline)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                AppBadge(
                    text: miembro.rolDescripcion ?? "-",
                    foregroundColor: .blue,
                    backgroundColor: Color.blue.opacity(0.15)
                )

                if miembro.invitacion == false {
                    AppBadge(
                        text: "Pendiente",
                        foregroundColor: .orange,
                        backgroundColor: Color.orange.opacity(0.15)
                    )
                }
            }
        }
        .padding(.vertical, 4)
    }
}
