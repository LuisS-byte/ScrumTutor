import SwiftUI

struct PerfilView: View {

    @EnvironmentObject var authVM: AuthViewModel
    @StateObject private var vm = PerfilViewModel()
    @State private var mostrarEditar: Bool = false

    var body: some View {
        Group {
            if vm.isLoading {
                ProgressView("Cargando perfil...")
            } else if let usuario = vm.usuario {
                List {
                    Section {
                        HStack(spacing: 16) {
                            Text(iniciales(nombre: usuario.nombre))
                                .font(.title.bold())
                                .foregroundColor(.white)
                                .frame(width: 64, height: 64)
                                .background(Color.blue)
                                .clipShape(Circle())

                            VStack(alignment: .leading, spacing: 4) {
                                Text(usuario.nombre)
                                    .font(.title3.bold())
                                Text(usuario.correo)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 4)
                    }

                    Section("Informacion") {
                        LabeledContent("Correo", value: usuario.correo)
                        LabeledContent("Rol", value: usuario.rol?.nombre ?? "Sin rol")
                        LabeledContent("Estado") {
                            AppBadge(
                                text: (usuario.activo ?? true) ? "Activo" : "Inactivo",
                                foregroundColor: (usuario.activo ?? true) ? .green : .red,
                                backgroundColor: ((usuario.activo ?? true) ? Color.green : Color.red).opacity(0.12)
                            )
                        }
                    }

                    Section("Acciones") {
                        Button {
                            mostrarEditar = true
                        } label: {
                            Label("Editar perfil", systemImage: "pencil")
                        }

                        Button(role: .destructive) {
                            authVM.logout()
                        } label: {
                            Label("Cerrar sesion", systemImage: "rectangle.portrait.and.arrow.right")
                        }
                    }
                }
                .listStyle(.insetGrouped)
                .sheet(isPresented: $mostrarEditar) {
                    NavigationStack {
                        EditPerfilView(vm: vm, usuario: usuario)
                    }
                }
            } else {
                AppEmptyStateView(
                    icon: "person.crop.circle.badge.exclamationmark",
                    title: "No se pudo cargar el perfil",
                    message: "Proba de nuevo para obtener tu informacion actual."
                ) {
                    Button("Reintentar") {
                        vm.cargarPerfil()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.blue)
                }
            }
        }
        .navigationTitle("Perfil")
        .onAppear {
            if vm.roles.isEmpty {
                vm.cargarRoles()
            }
            if vm.usuario == nil {
                vm.cargarPerfil()
            }
        }
        .appErrorAlert(message: $vm.errorMessage)
    }

    private func iniciales(nombre: String) -> String {
        let partes = nombre.split(separator: " ").prefix(2)
        let letras = partes.compactMap { $0.first }
        return letras.isEmpty ? "?" : String(letras).uppercased()
    }
}

private struct EditPerfilView: View {

    @ObservedObject var vm: PerfilViewModel
    let usuario: Usuario
    @Environment(\.dismiss) private var dismiss

    @State private var nombre: String
    @State private var idRolSeleccionado: Int

    init(vm: PerfilViewModel, usuario: Usuario) {
        self.vm = vm
        self.usuario = usuario
        _nombre = State(initialValue: usuario.nombre)
        _idRolSeleccionado = State(initialValue: usuario.rol?.id ?? 2)
    }

    var body: some View {
        Form {
            Section("Datos") {
                TextField("Nombre", text: $nombre)
                Text(usuario.correo)
                    .foregroundColor(.secondary)
            }

            Section("Rol") {
                Picker("Rol", selection: $idRolSeleccionado) {
                    ForEach(vm.roles) { rol in
                        Text(rol.nombre).tag(rol.id)
                    }
                }
            }
        }
        .navigationTitle("Editar perfil")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancelar") { dismiss() }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button {
                    vm.actualizarPerfil(id: usuario.id, nombre: nombre, idRol: idRolSeleccionado) { ok in
                        if ok { dismiss() }
                    }
                } label: {
                    if vm.isSaving {
                        ProgressView()
                    } else {
                        Text("Guardar")
                    }
                }
                .disabled(nombre.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || vm.isSaving)
            }
        }
    }
}
