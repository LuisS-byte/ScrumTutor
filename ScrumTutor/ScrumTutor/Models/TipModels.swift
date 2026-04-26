// TipModels.swift
import Foundation

struct Tip: Decodable, Identifiable {
    let id: Int
    let seccion: String?
    let mensaje: String?
}
