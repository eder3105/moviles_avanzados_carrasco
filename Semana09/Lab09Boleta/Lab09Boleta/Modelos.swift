import Foundation

enum SistemaPension: String, CaseIterable {
    case onp = "ONP"
    case afp = "AFP"
}

// Datos que ingresa el usuario (ya validados)
struct DatosBoleta {
    var sueldoBasico: Double
    var diasLaborados: Int
    var tieneHijos: Bool
    var sistema: SistemaPension
    var afp: String
    var horasExtras25: Double
    var horasExtras35: Double
    var adelantos: Double
    var calcularRenta: Bool = false   // Nivel 3
}

// Una fila de la boleta (nombre + monto)
struct Concepto: Identifiable {
    let id = UUID()
    let nombre: String
    let monto: Double
}

struct ResultadoBoleta {
    let remuneraciones: [Concepto]
    let descuentos: [Concepto]
    let aportaciones: [Concepto]
    let totalRemuneraciones: Double
    let totalDescuentos: Double
    let neto: Double
    let essalud: Double
}

// Nivel 3: ONP y AFP lado a lado
struct ComparativoPension {
    let onp: ResultadoBoleta
    let afp: ResultadoBoleta
    let nombreAFP: String

    var mejor: String {
        if afp.neto > onp.neto { return "AFP" }
        if onp.neto > afp.neto { return "ONP" }
        return "Igual"
    }

    var diferencia: Double {
        redondear(abs(afp.neto - onp.neto))
    }
}

struct ErrorBoleta: Error {
    let mensaje: String
}
