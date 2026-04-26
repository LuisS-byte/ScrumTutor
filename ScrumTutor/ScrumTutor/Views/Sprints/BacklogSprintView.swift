// BacklogSprintView.swift
import SwiftUI

struct BacklogSprintView: View {

    let idSprint: Int
    @State private var historias: [Historia] = []
    @State private var isLoading: Bool = false

    var body: some View {
        Group {
            if isLoading {
                ProgressView("Cargando...")
            } else if historias.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "list.bullet.clipboard")
                        .font(.system(size: 50))
                        .foregroundColor(.secondary)
                    Text("No hay historias en este sprint")
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List(historias) { historia in
                    HistoriaRowView(historia: historia)
                }
                .listStyle(.insetGrouped)
            }
        }
        .navigationTitle("Backlog Sprint")
        .onAppear { cargarHistorias() }
    }

    func cargarHistorias() {
        isLoading = true
        NetworkManager.shared.request(
            path: APIConstants.Sprints.historias(idSprint),
            method: "GET",
            responseType: [Historia].self
        ) { result in
            isLoading = false
            if case .success(let data) = result {
                historias = data
            }
        }
    }
}
