import SwiftUI

/// Pago mensual de un instructor.
///  - Pago por hora: S/ 50, máximo 23 horas semanales.
///  - Sueldo bruto = horas semanales × pago por hora × 4
///  - Descuentos: AFP (10%) u ONP (13%) + Impuesto a la Renta de 5ta categoría.
///  - ESSALUD (9%) lo paga el empleador y no afecta al sueldo neto.
struct PagoInstructoresView: View {

    // Constantes del enunciado
    private let pagoPorHora = 50.0
    private let horasMaximas = 23
    private let semanasPorMes = 4.0
    private let tasaEssalud = 0.09

    // Impuesto a la Renta (5ta categoría): ajusta la UIT si cambia el año.
    private let uit = 5500.0                // UIT 2026
    private let mesesDelAnio = 12.0         // renta anual proyectada = bruto × 12
    private let deduccionUIT = 7.0          // monto no afecto: 7 UIT
    // (hasta cuántas UIT, tasa)
    private let tramos: [(hasta: Double, tasa: Double)] = [
        (5, 0.08), (20, 0.14), (35, 0.17), (45, 0.20), (Double.infinity, 0.30)
    ]

    enum SistemaPension: String, CaseIterable, Identifiable {
        case afp = "AFP (10%)"
        case onp = "ONP (13%)"
        var id: String { rawValue }
        var tasa: Double { self == .afp ? 0.10 : 0.13 }
    }

    struct Resultado {
        let bruto: Double
        let pension: Double
        let impuestoRenta: Double
        let descuentos: Double
        let neto: Double
        let essalud: Double
    }

    @State private var horas = 20
    @State private var sistema: SistemaPension = .afp
    @State private var resultado: Resultado?

    var body: some View {
        Form {
            Section {
                LabeledContent("Pago por hora", value: soles(pagoPorHora))
                Stepper("Horas semanales: \(horas)", value: $horas, in: 1...horasMaximas)
                Picker("Sistema de pensión", selection: $sistema) {
                    ForEach(SistemaPension.allCases) { s in
                        Text(s.rawValue).tag(s)
                    }
                }
                .pickerStyle(.segmented)
            } header: {
                Text("Datos del instructor")
            } footer: {
                Text("Máximo \(horasMaximas) horas semanales.")
            }

            Section {
                BotonCalcular(titulo: "Calcular pago", accion: calcular)
            }

            if let r = resultado {
                Section("Resultado mensual") {
                    FilaResultado(titulo: "Sueldo bruto", valor: soles(r.bruto))
                    FilaResultado(titulo: "Descuento \(sistema.rawValue)", valor: "- " + soles(r.pension))
                    FilaResultado(titulo: "Impuesto a la Renta (5ta)", valor: "- " + soles(r.impuestoRenta))
                    FilaResultado(titulo: "Total descuentos", valor: "- " + soles(r.descuentos))
                    FilaResultado(titulo: "Sueldo neto", valor: soles(r.neto), destacado: true)
                }
                Section("Informativo") {
                    FilaResultado(titulo: "ESSALUD 9% (lo paga el empleador)", valor: soles(r.essalud))
                }
            }
        }
        .navigationTitle("Pago de instructores")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func calcular() {
        let bruto = Double(horas) * pagoPorHora * semanasPorMes
        let pension = bruto * sistema.tasa
        let renta = impuestoRentaMensual(bruto: bruto)
        let descuentos = pension + renta
        resultado = Resultado(bruto: bruto,
                              pension: pension,
                              impuestoRenta: renta,
                              descuentos: descuentos,
                              neto: bruto - descuentos,
                              essalud: bruto * tasaEssalud)
    }

    /// Impuesto a la Renta mensual: solo si la renta anual proyectada supera 7 UIT.
    private func impuestoRentaMensual(bruto: Double) -> Double {
        let rentaAnual = bruto * mesesDelAnio
        let base = rentaAnual - deduccionUIT * uit
        guard base > 0 else { return 0 }

        var restante = base
        var limitePrevio = 0.0
        var impuesto = 0.0
        for tramo in tramos {
            let limite = tramo.hasta * uit
            let ancho = min(restante, limite - limitePrevio)
            if ancho <= 0 { break }
            impuesto += ancho * tramo.tasa
            restante -= ancho
            limitePrevio = limite
        }
        return impuesto / mesesDelAnio
    }
}

#Preview {
    NavigationStack { PagoInstructoresView() }
}
