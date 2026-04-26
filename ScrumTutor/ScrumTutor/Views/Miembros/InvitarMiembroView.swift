// InvitarMiembroView.swift
import SwiftUI

struct InvitarMiembroView: View {

    let idProyecto: Int
    @ObservedObject var vm: MiembrosViewModel
    @Environment(\.dismiss) var dismiss

    @State private var correo: String = ""
    @State private var idRolSeleccionado: Int = 3
    @State private var buscando: Bool = false
    @State private var usuarioEncontrado: Usuario? = nil
    @State private var errorBusqueda: String? = nil

    var body: some View {
        NavigationStack {
            Form {
                Section("Buscar usuario") {
                    HStack {
                        TextField("Correo electrónico", text: $correo)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)

                        Button {
                            buscarUsuario()
                        } label: {
                            if buscando {
                                ProgressView()
                            } else {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.blue)
                            }
                        }
                        .disabled(correo.isEmpty || buscando)
                    }

                    if let error = errorBusqueda {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                }

                if let usuario = usuarioEncontrado {
                    Section("Usuario encontrado") {
                        HStack(spacing: 12) {
                            Text(String(usuario.nombre.prefix(1)).uppercased())
                                .font(.headline.bold())
                                .foregroundColor(.white)
                                .frame(width: 36, height: 36)
                                .background(Color.green)
                                .clipShape(Circle())

                            VStack(alignment: .leading) {
                                Text(usuario.nombre)
                                    .font(.headline)
                                Text(usuario.correo)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }

                    Section("Rol en el proyecto") {
                        Picker("Rol", selection: $idRolSeleccionado) {
                            ForEach(vm.roles) { rol in
                                Text(rol.descripcion).tag(rol.id)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                }

                if let error = vm.errorMessage {
                    Section {
                        Text(error).foregroundColor(.red).font(.caption)
                    }
                }
            }
            .navigationTitle("Invitar miembro")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
                if usuarioEncontrado != nil {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Invitar") {
                            guard let usuario = usuarioEncontrado else { return }
                            vm.invitarMiembro(
                                idProyecto: idProyecto,
                                idUsuario: usuario.id,
                                idRolProyecto: idRolSeleccionado
                            ) { ok in if ok { dismiss() } }
                        }
                    }
                }
            }
        }
    }

    func buscarUsuario() {
        buscando = true
        errorBusqueda = nil
        usuarioEncontrado = nil

        vm.buscarUsuario(correo: correo) { usuario in
            buscando = false
            if let usuario = usuario {
                usuarioEncontrado = usuario
            } else {
                errorBusqueda = "No se encontró ningún usuario con ese correo"
            }
        }
    }
}
