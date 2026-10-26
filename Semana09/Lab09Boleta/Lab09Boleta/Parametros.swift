import Foundation

// Un solo lugar para todos los parámetros (fuentes y fechas: ver README).

struct TasasAFP {
    let fondo: Double
    let comision: Double
    let seguro: Double
}

enum Parametros {
    static let rmv = 1230.00                        // D.S. de la RMV, vigente desde 01/10/2026
    static let porcentajeAsignacionFamiliar = 0.10  // Ley 25129
    static let tasaONP = 0.13                       // D.L. 19990
    static let tasaEsSalud = 0.09                   // Ley 26790
    static let recargoHE25 = 1.25
    static let recargoHE35 = 1.35
    static let diasMes = 30.0
    static let horasDia = 8.0

    // Nivel 3: retención de renta de 5.ª categoría (versión simplificada)
    static let uit = 5500.0                         // D.S. 301-2025-EF (año 2026)
    static let deduccionUIT = 7.0                   // 7 UIT de deducción anual
    static let sueldosAnuales = 14.0                // 12 sueldos + 2 gratificaciones

    // Diccionario: nombre de la AFP -> sus tasas
    static let tasasAFP: [String: TasasAFP] = [
        "AFP Ejemplo": TasasAFP(fondo: 0.10, comision: 0.016, seguro: 0.0135)
    ]

    static var asignacionFamiliar: Double {
        redondear(rmv * porcentajeAsignacionFamiliar)
    }

    static var nombresAFP: [String] {
        tasasAFP.keys.sorted()
    }
}

// Redondeo a 2 decimales, mitad hacia arriba (igual que ROUND de Excel).
func redondear(_ valor: Double) -> Double {
    (valor * 100 + 0.0000001).rounded(.toNearestOrAwayFromZero) / 100
}

// Formato "2,175.00"
func soles(_ valor: Double) -> String {
    let f = NumberFormatter()
    f.numberStyle = .decimal
    f.minimumFractionDigits = 2
    f.maximumFractionDigits = 2
    f.locale = Locale(identifier: "en_US")
    return f.string(from: NSNumber(value: valor)) ?? String(format: "%.2f", valor)
}
