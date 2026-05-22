import Foundation

@MainActor
class AuthViewModel: ObservableObject {

    @Published var isLoggedIn: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var globalMessage: String? = nil

    init() {
        NotificationCenter.default.addObserver(
            forName: .sessionExpired,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self else { return }
            if self.isLoggedIn || KeychainManager.shared.hasToken() {
                self.logout()
                self.globalMessage = "Tu sesion expiro. Inicia sesion nuevamente."
            }
        }
    }

    func checkSession() {
        guard let token = KeychainManager.shared.getToken() else {
            isLoggedIn = false
            return
        }
        isLoggedIn = JWTDecoder.isValid(token)
    }

    func login(correo: String, contrasena: String) {
        guard !correo.isEmpty, !contrasena.isEmpty else {
            errorMessage = "Completa todos los campos"
            return
        }

        isLoading = true
        errorMessage = nil

        let body = LoginRequest(correo: correo, contrasena: contrasena)

        NetworkManager.shared.request(
            path: APIConstants.Auth.login,
            method: "POST",
            body: body,
            responseType: AuthResponse.self
        ) { [weak self] result in
            guard let self else { return }
            self.isLoading = false

            switch result {
            case .success(let response):
                KeychainManager.shared.saveToken(response.jwt)
                self.isLoggedIn = true
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }

    func register(nombre: String, correo: String, contrasena: String) {
        guard !nombre.isEmpty, !correo.isEmpty, !contrasena.isEmpty else {
            errorMessage = "Completa todos los campos"
            return
        }

        isLoading = true
        errorMessage = nil

        let body = RegisterRequest(nombre: nombre, correo: correo, contrasena: contrasena)

        NetworkManager.shared.request(
            path: APIConstants.Auth.register,
            method: "POST",
            body: body,
            responseType: AuthResponse.self
        ) { [weak self] result in
            guard let self else { return }
            self.isLoading = false

            switch result {
            case .success(let response):
                KeychainManager.shared.saveToken(response.jwt)
                self.isLoggedIn = true
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }

    func logout() {
        KeychainManager.shared.deleteToken()
        isLoggedIn = false
    }
}
