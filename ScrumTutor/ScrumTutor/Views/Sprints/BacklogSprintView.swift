import SwiftUI

struct BacklogSprintView: View {

    let idSprint: Int
    @State private var historias: [Historia] = []
    @State private var isLoading: Bool = false
    @State private var errorMessage: String? = nil

    var body: some View {
        Group {
            if isLoading {
                ProgressView("Cargando...")
            } else if historias.isEmpty {
                AppEmptyStateView(
                    icon: "list.bullet.clipboard",
                    title: "No hay historias en este sprint",
                    message: "Asigna historias al sprint para verlas aca."
                )
            } else {
                List(historias) { historia in
                    HistoriaRowView(historia: historia)
                }
                .listStyle(.insetGrouped)
            }
        }
        .navigationTitle("Backlog Sprint")
        .onAppear { cargarHistorias() }
        .appErrorAlert(message: $errorMessage)
    }

    func cargarHistorias() {
        isLoading = true
        errorMessage = nil

        NetworkManager.shared.request(
            path: APIConstants.Sprints.historias(idSprint),
            method: "GET",
            responseType: [Historia].self
        ) { result in
            isLoading = false
            switch result {
            case .success(let data):
                historias = data
            case .failure(let error):
                errorMessage = error.localizedDescription
            }
        }
    }
}
