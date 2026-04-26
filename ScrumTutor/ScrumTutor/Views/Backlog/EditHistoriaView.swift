// EditHistoriaView.swift
import SwiftUI

struct EditHistoriaView: View {

    let historia: Historia
    let idProyecto: Int
    @ObservedObject var vm: BacklogViewModel
    @Environment(\.dismiss) var dismiss

    @State private var titulo: String = ""
    @State private var descripcion: String = ""
    @State private var criterios: String = ""
    @State private var idPrioridad: Int = 1
    @State private var idEstado: Int = 1
    @State private var sprintSeleccionado: Int? = nil
    @State private var sprints: [Sprint] = []
    @State private var cargandoSprints: Bool = false

    let prioridades = ["Alta", "Media", "Baja"]
    let estados = ["Por hacer", "En progreso", "Completado"]

    var sprintsDisponibles: [Sprint] {
        sprints.filter { $0.idEstado != 3 }
    }

    var body: some View {
        NavigationStack {
            Form {
                seccionInfo
                seccionConfiguracion
                seccionSprint
                seccionError
            }
            .navigationTitle("Editar historia")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Guardar") {
                        vm.editarHistoria(
                            id: historia.id,
                            idProyecto: idProyecto,
                            titulo: titulo,
                            descripcion: descripcion,
                            idSprint: sprintSeleccionado,
                            idPrioridad: idPrioridad,
                            criterios: criterios,
                            idEstado: idEstado
                        ) { ok in if ok { dismiss() } }
                    }
                    .disabled(titulo.isEmpty)
                }
            }
            .onAppear {
                titulo = historia.titulo
                descripcion = historia.descripcion ?? ""
                criterios = historia.criteriosAceptacion ?? ""
                idPrioridad = historia.idPrioridad ?? 1
                idEstado = historia.idEstado ?? 1
                sprintSeleccionado = historia.idSprint
                cargarSprints()
            }
        }
    }

    // MARK: - Sección Info
    var seccionInfo: some View {
        Section("Historia de usuario") {
            TextField("Título", text: $titulo)
            TextField("Descripción", text: $descripcion, axis: .vertical)
                .lineLimit(3...6)
            TextField("Criterios de aceptación", text: $criterios, axis: .vertical)
                .lineLimit(3...6)
        }
    }

    // MARK: - Sección Configuración
    var seccionConfiguracion: some View {
        Section("Configuración") {
            Picker("Prioridad", selection: $idPrioridad) {
                ForEach(0..<prioridades.count, id: \.self) { i in
                    Text(prioridades[i]).tag(i + 1)
                }
            }
            Picker("Estado", selection: $idEstado) {
                ForEach(0..<estados.count, id: \.self) { i in
                    Text(estados[i]).tag(i + 1)
                }
            }
        }
    }

    // MARK: - Sección Sprint
    var seccionSprint: some View {
        Section {
            if cargandoSprints {
                HStack {
                    ProgressView()
                    Text("Cargando sprints...")
                        .foregroundColor(.secondary)
                }
            } else if sprintsDisponibles.isEmpty {
                Text("No hay sprints activos disponibles")
                    .foregroundColor(.secondary)
                    .font(.caption)
            } else {
                Button {
                    sprintSeleccionado = nil
                } label: {
                    HStack {
                        Text("Sin sprint").foregroundColor(.primary)
                        Spacer()
                        if sprintSeleccionado == nil {
                            Image(systemName: "checkmark").foregroundColor(.blue)
                        }
                    }
                }
                ForEach(sprintsDisponibles) { sprint in
                    SprintOpcionRow(
                        sprint: sprint,
                        seleccionado: sprintSeleccionado == sprint.id
                    ) {
                        sprintSeleccionado = sprint.id
                    }
                }
            }
        } header: {
            Text("Sprint")
        } footer: {
            sprintFooter
        }
    }

    // MARK: - Footer sprint
    @ViewBuilder
    var sprintFooter: some View {
        if sprintSeleccionado != nil {
            Text("La historia será movida al sprint seleccionado")
                .font(.caption)
        } else if historia.idSprint != nil {
            Text("La historia será removida de su sprint actual")
                .font(.caption)
                .foregroundColor(.orange)
        }
    }

    // MARK: - Sección Error
    @ViewBuilder
    var seccionError: some View {
        if let error = vm.errorMessage {
            Section {
                Text(error).foregroundColor(.red).font(.caption)
            }
        }
    }

    // MARK: - Cargar sprints
    func cargarSprints() {
        cargandoSprints = true
        NetworkManager.shared.request(
            path: APIConstants.Proyectos.sprints(idProyecto),
            method: "GET",
            responseType: [Sprint].self
        ) { result in
            cargandoSprints = false
            if case .success(let data) = result {
                sprints = data
            }
        }
    }
}

// MARK: - Fila opción sprint
struct SprintOpcionRow: View {
    let sprint: Sprint
    let seleccionado: Bool
    let onTap: () -> Void

    var colorEstado: Color {
        switch sprint.idEstado {
        case 1: return .gray
        case 2: return .blue
        default: return .green
        }
    }

    var body: some View {
        Button(action: onTap) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(sprint.nombre).foregroundColor(.primary)
                    Text(sprint.estadoDescripcion ?? "")
                        .font(.caption)
                        .foregroundColor(colorEstado)
                }
                Spacer()
                if seleccionado {
                    Image(systemName: "checkmark").foregroundColor(.blue)
                }
            }
        }
    }
}
