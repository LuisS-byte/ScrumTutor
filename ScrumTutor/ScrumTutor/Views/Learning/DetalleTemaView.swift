import SwiftUI

struct DetalleTemaView: View {

    let titulo: String
    let contenido: String

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(titulo)
                    .font(.largeTitle.bold())

                Text(contenido.isEmpty ? "Sin contenido disponible." : contenido)
                    .font(.body)
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
        }
        .navigationTitle("Detalle")
        .navigationBarTitleDisplayMode(.inline)
    }
}
