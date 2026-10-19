import SwiftUI

// MARK: - Funciones de ayuda

/// Convierte un texto en número. Acepta coma o punto como separador decimal.
func numero(_ texto: String) -> Double? {
    let limpio = texto
        .trimmingCharacters(in: .whitespaces)
        .replacingOccurrences(of: ",", with: ".")
    guard !limpio.isEmpty, let valor = Double(limpio), valor.isFinite else { return nil }
    return valor
}

func soles(_ valor: Double) -> String { String(format: "S/ %.2f", valor) }
func porcentaje(_ valor: Double) -> String { String(format: "%.2f %%", valor) }
func dias(_ valor: Double) -> String { String(format: "%.1f días", valor) }
func veces(_ valor: Double) -> String { String(format: "%.2f veces", valor) }

// MARK: - Componentes reutilizables

/// Fila "título ........ valor" para mostrar resultados.
struct FilaResultado: View {
    let titulo: String
    let valor: String
    var destacado: Bool = false

    var body: some View {
        HStack {
            Text(titulo)
            Spacer()
            Text(valor)
                .fontWeight(destacado ? .bold : .regular)
                .foregroundStyle(destacado ? Color.blue : Color.primary)
        }
    }
}

/// Campo de texto numérico con título a la izquierda y valor a la derecha.
struct CampoNumerico: View {
    let titulo: String
    @Binding var texto: String

    var body: some View {
        HStack {
            Text(titulo)
                .lineLimit(2)
            Spacer()
            TextField("0", text: $texto)
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.trailing)
                .frame(maxWidth: 120)
        }
    }
}

/// Botón azul de ancho completo para "Calcular".
struct BotonCalcular: View {
    let titulo: String
    let accion: () -> Void

    var body: some View {
        Button(action: accion) {
            Text(titulo)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 6)
        }
        .buttonStyle(.borderedProminent)
        .listRowInsets(EdgeInsets())
        .listRowBackground(Color.clear)
    }
}
