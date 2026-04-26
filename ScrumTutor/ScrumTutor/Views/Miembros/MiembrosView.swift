// MiembrosView.swift
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
                    VStack(spacing: 12) {
                        Image(systemName: "person.2")
                            .font(.system(size: 50))
                            .foregroundColor(.secondary)
                        Text("No hay miembros en este proyecto")
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        ForEach(vm.miembros) { miembro in
                            MiembroRowView(miembro: miembro)
                                .swipeActions(edge: .trailing) {
                                    if vm.esProductOwner(idProyecto: idProyecto) {
                                        Button(role: .destructive) {
                                            vm.eliminarMiembro(
                                                idProyecto: idProyecto,
                                                idMiembro: miembro.id
                                            )
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

            // Botón flotante — solo Product Owner puede invitar
            if vm.esProductOwner(idProyecto: idProyecto) {
                Button {
                    mostrarInvitar = true
                } label: {
                    Image(systemName: "person.badge.plus")
                        .font(.title2.bold())
                        .foregroundColor(.white)
                        .padding(18)
                        .background(Color.blue)
                        .clipShape(Circle())
                        .shadow(radius: 4)
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
        .alert("Error", isPresented: .constant(vm.errorMessage != nil)) {
            Button("OK") { vm.errorMessage = nil }
        } message: {
            Text(vm.errorMessage ?? "")
        }
    }
}

// MARK: - Fila de miembro
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
                Text(miembro.rolDescripcion ?? "—")
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(Color.blue.opacity(0.15))
                    .foregroundColor(.blue)
                    .cornerRadius(6)

                if miembro.invitacion == true {
                    Text("Pendiente")
                        .font(.caption2)
                        .foregroundColor(.orange)
                }
            }
        }
        .padding(.vertical, 4)
    }
}
