import SwiftUI

struct AppEmptyStateView<Content: View>: View {

    let icon: String
    let title: String
    let message: String
    let action: Content

    init(icon: String, title: String, message: String, @ViewBuilder action: () -> Content = { EmptyView() }) {
        self.icon = icon
        self.title = title
        self.message = message
        self.action = action()
    }

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 50))
                .foregroundColor(.secondary)

            Text(title)
                .font(.headline)

            Text(message)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)

            action
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct AppFloatingButton: View {

    var systemImage: String = "plus"
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: systemImage)
                .font(.title2.bold())
                .foregroundColor(.white)
                .padding(18)
                .background(Color.blue)
                .clipShape(Circle())
                .shadow(color: .black.opacity(0.2), radius: 6, x: 0, y: 3)
        }
    }
}

struct AppBadge: View {

    let text: String
    let foregroundColor: Color
    let backgroundColor: Color

    var body: some View {
        Text(text)
            .modifier(AppBadgeStyle(foregroundColor: foregroundColor, backgroundColor: backgroundColor))
    }
}

struct AppBadgeStyle: ViewModifier {

    let foregroundColor: Color
    let backgroundColor: Color

    func body(content: Content) -> some View {
        content
            .font(.caption2)
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(backgroundColor)
            .foregroundColor(foregroundColor)
            .cornerRadius(6)
    }
}

private struct AppErrorAlertModifier: ViewModifier {

    @Binding var message: String?

    func body(content: Content) -> some View {
        content.alert("Error", isPresented: Binding(
            get: { message != nil },
            set: { if !$0 { message = nil } }
        )) {
            Button("OK") { message = nil }
        } message: {
            Text(message ?? "")
        }
    }
}

extension View {
    func appErrorAlert(message: Binding<String?>) -> some View {
        modifier(AppErrorAlertModifier(message: message))
    }
}
