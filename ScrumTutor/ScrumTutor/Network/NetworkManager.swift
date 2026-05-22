import Foundation

final class NetworkManager {

    static let shared = NetworkManager()
    private init() {}

    private func notifySessionExpired() {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .sessionExpired, object: nil)
        }
    }

    func request<T: Decodable>(
        path: String,
        method: String = "GET",
        body: Encodable? = nil,
        responseType: T.Type,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        guard let url = URL(string: APIConstants.baseURL + path) else {
            completion(.failure(.invalidURL))
            return
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if let token = KeychainManager.shared.getToken() {
            urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        if let body = body {
            guard let encoded = try? JSONEncoder().encode(body) else {
                completion(.failure(.encodingError))
                return
            }
            urlRequest.httpBody = encoded
        }

        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(.networkError(error.localizedDescription)))
                }
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async { completion(.failure(.invalidResponse)) }
                return
            }

            if httpResponse.statusCode == 401 {
                self.notifySessionExpired()
                DispatchQueue.main.async { completion(.failure(.unauthorized)) }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async { completion(.failure(.noData)) }
                return
            }

            if let json = String(data: data, encoding: .utf8) {
                print("Response [\(path)]: \(json)")
            }

            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async { completion(.success(decoded)) }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(.decodingError(error.localizedDescription)))
                }
            }
        }.resume()
    }

    func requestEmpty(
        path: String,
        method: String,
        body: Encodable? = nil,
        completion: @escaping (Result<Void, NetworkError>) -> Void
    ) {
        guard let url = URL(string: APIConstants.baseURL + path) else {
            completion(.failure(.invalidURL))
            return
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if let token = KeychainManager.shared.getToken() {
            urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        if let body = body {
            guard let encoded = try? JSONEncoder().encode(body) else {
                completion(.failure(.encodingError))
                return
            }
            urlRequest.httpBody = encoded
        }

        URLSession.shared.dataTask(with: urlRequest) { _, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(.networkError(error.localizedDescription)))
                }
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async { completion(.failure(.invalidResponse)) }
                return
            }

            if httpResponse.statusCode == 401 {
                self.notifySessionExpired()
                DispatchQueue.main.async { completion(.failure(.unauthorized)) }
                return
            }

            if (200...299).contains(httpResponse.statusCode) {
                DispatchQueue.main.async { completion(.success(())) }
            } else {
                DispatchQueue.main.async { completion(.failure(.invalidResponse)) }
            }
        }.resume()
    }

    func requestIgnoringResponse(
        path: String,
        method: String,
        body: Encodable? = nil,
        completion: @escaping (Result<Void, NetworkError>) -> Void
    ) {
        requestEmpty(path: path, method: method, body: body, completion: completion)
    }
}

enum NetworkError: LocalizedError {
    case invalidURL
    case encodingError
    case networkError(String)
    case invalidResponse
    case unauthorized
    case noData
    case decodingError(String)

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "URL invalida"
        case .encodingError: return "Error al codificar los datos"
        case .networkError(let message): return "Error de red: \(message)"
        case .invalidResponse: return "Respuesta invalida del servidor"
        case .unauthorized: return "Sesion expirada. Inicia sesion nuevamente."
        case .noData: return "Sin datos en la respuesta"
        case .decodingError(let message): return "Error al decodificar: \(message)"
        }
    }
}
