import SwiftUI

/// Trabajo grupal: indicadores de cuentas por cobrar y por pagar.
struct CuentasView: View {

    // Cuentas por cobrar
    @State private var cxcInicial = ""
    @State private var cxcFinal = ""
    @State private var ventasCredito = ""
    @State private var cxcVencidas = ""
    @State private var pctIncobrable = ""

    // Cuentas por pagar
    @State private var cxpInicial = ""
    @State private var cxpFinal = ""
    @State private var comprasCredito = ""
    @State private var pasivosTotales = ""

    // MARK: - Cálculos (se actualizan solos al escribir)

    private var cxcPromedio: Double? {
        guard let i = numero(cxcInicial), let f = numero(cxcFinal) else { return nil }
        return (i + f) / 2
    }

    private var edadCobrar: Double? {
        guard let p = cxcPromedio, let v = numero(ventasCredito), v > 0 else { return nil }
        return p * 360 / v
    }

    private var rotacionCobrar: Double? {
        guard let p = cxcPromedio, p > 0, let v = numero(ventasCredito) else { return nil }
        return v / p
    }

    private var morosidad: Double? {
        guard let t = numero(cxcFinal), t > 0, let v = numero(cxcVencidas) else { return nil }
        return v / t * 100
    }

    private var provision: Double? {
        guard let t = numero(cxcFinal), let p = numero(pctIncobrable) else { return nil }
        return t * p / 100
    }

    private var cxpPromedio: Double? {
        guard let i = numero(cxpInicial), let f = numero(cxpFinal) else { return nil }
        return (i + f) / 2
    }

    private var edadPagar: Double? {
        guard let p = cxpPromedio, let c = numero(comprasCredito), c > 0 else { return nil }
        return p * 360 / c
    }

    private var rotacionPagar: Double? {
        guard let p = cxpPromedio, p > 0, let c = numero(comprasCredito) else { return nil }
        return c / p
    }

    private var endeudamiento: Double? {
        guard let f = numero(cxpFinal), let t = numero(pasivosTotales), t > 0 else { return nil }
        return f / t * 100
    }

    private var cicloFinanciero: Double? {
        guard let c = edadCobrar, let p = edadPagar else { return nil }
        return c - p
    }

    private func texto(_ valor: Double?, _ formato: (Double) -> String) -> String {
        valor.map(formato) ?? "—"
    }

    // MARK: - Pantalla

    var body: some View {
        Form {
            Section("Cuentas por cobrar - datos") {
                CampoNumerico(titulo: "Saldo inicial (S/)", texto: $cxcInicial)
                CampoNumerico(titulo: "Saldo final = totales (S/)", texto: $cxcFinal)
                CampoNumerico(titulo: "Ventas a crédito (S/)", texto: $ventasCredito)
                CampoNumerico(titulo: "Cuentas vencidas (S/)", texto: $cxcVencidas)
                CampoNumerico(titulo: "% estimado de incobrabilidad", texto: $pctIncobrable)
            }

            Section("Cuentas por cobrar - resultados") {
                FilaResultado(titulo: "Edad promedio", valor: texto(edadCobrar, dias))
                FilaResultado(titulo: "Rotación", valor: texto(rotacionCobrar, veces))
                FilaResultado(titulo: "Índice de morosidad", valor: texto(morosidad, porcentaje))
                FilaResultado(titulo: "Provisión incobrables", valor: texto(provision, soles))
            }

            Section("Cuentas por pagar - datos") {
                CampoNumerico(titulo: "Saldo inicial (S/)", texto: $cxpInicial)
                CampoNumerico(titulo: "Saldo final (S/)", texto: $cxpFinal)
                CampoNumerico(titulo: "Compras a crédito (S/)", texto: $comprasCredito)
                CampoNumerico(titulo: "Pasivos totales (S/)", texto: $pasivosTotales)
            }

            Section("Cuentas por pagar - resultados") {
                FilaResultado(titulo: "Edad promedio", valor: texto(edadPagar, dias))
                FilaResultado(titulo: "Rotación", valor: texto(rotacionPagar, veces))
                FilaResultado(titulo: "Endeudamiento con proveedores", valor: texto(endeudamiento, porcentaje))
            }

            Section {
                FilaResultado(titulo: "Ciclo financiero",
                              valor: texto(cicloFinanciero, dias),
                              destacado: true)
                if let ciclo = cicloFinanciero {
                    Text(ciclo < 0
                         ? "Ciclo negativo: los proveedores financian las operaciones."
                         : "Ciclo positivo: la empresa financia sus operaciones con recursos propios durante \(String(format: "%.1f", ciclo)) días.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            } header: {
                Text("Comparación")
            } footer: {
                Text("Ciclo financiero = edad promedio por cobrar - edad promedio por pagar (año de 360 días).")
            }

            Section {
                Button("Limpiar todo", role: .destructive, action: limpiar)
            }
        }
        .navigationTitle("Cuentas por cobrar y pagar")
        .navigationBarTitleDisplayMode(.inline)
        .scrollDismissesKeyboard(.interactively)
    }

    private func limpiar() {
        cxcInicial = ""; cxcFinal = ""; ventasCredito = ""; cxcVencidas = ""; pctIncobrable = ""
        cxpInicial = ""; cxpFinal = ""; comprasCredito = ""; pasivosTotales = ""
    }
}

#Preview {
    NavigationStack { CuentasView() }
}
