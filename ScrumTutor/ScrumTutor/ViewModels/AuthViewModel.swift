// AuthViewModel.swift
import Foundation

@MainActor
class AuthViewModel: ObservableObject {

    @Published var isLoggedIn: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    // MARK: - Verificar sesión al abrir la app
    func checkSession() {
        guard let token = KeychainManager.shared.getToken() else {
            isLoggedIn = false
            return
        }
        isLoggedIn = JWTDecoder.isValid(token)
    }

    // ---------------------------------------------------------------
    // Entradas     : correo: String — correo del usuario registrado
    //                contrasena: String — contraseña en texto plano
    // Salidas      : isLoggedIn: Bool — true si la autenticación fue exitosa
    //                isLoading: Bool — estado de actividad de red
    //                errorMessage: String? — descripción del error si falla
    // Valor retorno: Void
    // Función      : Valida que los campos no estén vacíos, envía
    //                POST /api/auth/login y, al tener éxito, almacena
    //                el JWT en el Keychain y activa isLoggedIn.
    // Variables    : body: LoginRequest, isLoading: Bool,
    //                isLoggedIn: Bool, errorMessage: String?
    // Fecha        : 2026-04-25
    // Autor        : Ernesto
    // Rutinas anexas: NetworkManager.shared.request,
    //                 APIConstants.Auth.login,
    //                 KeychainManager.shared.saveToken
    // ---------------------------------------------------------------
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

    // ---------------------------------------------------------------
    // Entradas     : nombre: String — nombre completo del nuevo usuario
    //                correo: String — correo electrónico único
    //                contrasena: String — contraseña en texto plano
    // Salidas      : isLoggedIn: Bool — true si el registro fue exitoso
    //                isLoading: Bool — estado de actividad de red
    //                errorMessage: String? — descripción del error si falla
    // Valor retorno: Void
    // Función      : Valida que los campos no estén vacíos, envía
    //                POST /api/auth/register y, al tener éxito, almacena
    //                el JWT y activa isLoggedIn igual que en login().
    // Variables    : body: RegisterRequest, isLoading: Bool,
    //                isLoggedIn: Bool, errorMessage: String?
    // Fecha        : 2026-04-25
    // Autor        : Ernesto
    // Rutinas anexas: NetworkManager.shared.request,
    //                 APIConstants.Auth.register,
    //                 KeychainManager.shared.saveToken
    // ---------------------------------------------------------------
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

    // ---------------------------------------------------------------
    // Entradas     : Ninguna
    // Salidas      : isLoggedIn: Bool = false — redirige a la pantalla
    //                de inicio de sesión
    // Valor retorno: Void
    // Función      : Elimina el JWT almacenado en el Keychain y desactiva
    //                isLoggedIn para que ContentView redirija al login.
    //                No realiza llamada al servidor.
    // Variables    : isLoggedIn: Bool
    // Fecha        : 2026-04-25
    // Autor        : Ernesto
    // Rutinas anexas: KeychainManager.shared.deleteToken
    // ---------------------------------------------------------------
    func logout() {
        KeychainManager.shared.deleteToken()
        isLoggedIn = false
    }
}
