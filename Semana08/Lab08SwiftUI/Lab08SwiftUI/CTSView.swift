import SwiftUI

/// CTS = (Sueldo + 1/6 de la gratificación) × (Meses trabajados / 12)
struct CTSView: View {

    struct Resultado {
        let sextoGratificacion: Double
        let base: Double
        let cts: Double
    }

    @State private var sueldo = ""
    @State private var gratificacion = ""
    @State private var meses = 6
    @State private var resultado: Resultado?
    @State private var mensajeError: String?

    var body: some View {
        Form {
            Section {
                CampoNumerico(titulo: "Sueldo mensual (S/)", texto: $sueldo)
                CampoNumerico(titulo: "Gratificación (S/)", texto: $gratificacion)
                Stepper("Meses trabajados: \(meses)", value: $meses, in: 1...6)
            } header: {
                Text("Datos")
            } footer: {
                Text("Los meses corresponden al período semestral (1 a 6).")
            }

            Section {
                BotonCalcular(titulo: "Calcular CTS", accion: calcular)
            }

            if let mensajeError {
                Section {
                    Text(mensajeError).foregroundStyle(.red)
                }
            }

            if let r = resultado {
                Section("Resultado") {
                    FilaResultado(titulo: "1/6 de la gratificación", valor: soles(r.sextoGratificacion))
                    FilaResultado(titulo: "Sueldo + 1/6 gratificación", valor: soles(r.base))
                    FilaResultado(titulo: "CTS a depositar", valor: soles(r.cts), destacado: true)
                }
            }
        }
        .navigationTitle("Cálculo de CTS")
        .navigationBarTitleDisplayMode(.inline)
        .scrollDismissesKeyboard(.interactively)
    }

    private func calcular() {
        resultado = nil
        mensajeError = nil

        guard let s = numero(sueldo), s > 0 else {
            mensajeError = "Ingresa un sueldo válido mayor que 0."
            return
        }
        guard let g = numero(gratificacion), g >= 0 else {
            mensajeError = "Ingresa una gratificación válida (0 o más)."
            return
        }

        let sexto = g / 6
        let base = s + sexto
        let cts = base * (Double(meses) / 12)
        resultado = Resultado(sextoGratificacion: sexto, base: base, cts: cts)
    }
}

#Preview {
    NavigationStack { CTSView() }
}
