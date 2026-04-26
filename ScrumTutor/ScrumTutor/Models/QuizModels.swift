// QuizModels.swift
import Foundation

struct Quiz: Decodable, Identifiable {
    let id: Int
    let titulo: String
    let descripcion: String?
    let preguntas: [QuizPregunta]?
}

struct QuizPregunta: Decodable, Identifiable {
    let id: Int
    let pregunta: String
    let opcionA: String
    let opcionB: String
    let opcionC: String
    let opcionCorrecta: String
}

struct ProgresoRequest: Encodable {
    let puntaje: Double
}
