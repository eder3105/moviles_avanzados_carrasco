import SwiftUI

/// Promedio de 4 notas de teoría de Programación en Móviles Avanzado.
/// Reglas:
///  - Cada nota debe estar entre 0 y 20.
///  - Se elimina la menor nota para calcular el promedio.
///  - El resultado se redondea.
///  - Si se ingresa AN (laboratorio anulado), esa nota cuenta como 0, se
///    considera en el promedio y NO se puede eliminar (se elimina la menor
///    de las demás notas).
struct NotasTeoriaView: View {

    struct Resultado {
        let eliminada: Int?        // posición (0...3) de la nota eliminada
        let valorEliminado: Double?
        let promedio: Double
        let redondeado: Int
    }

    @State private var notas: [String] = ["", "", "", ""]
    @State private var resultado: Resultado?
    @State private var mensajeError: String?

    var body: some View {
        Form {
            Section {
                ForEach(0..<4, id: \.self) { i in
                    HStack {
                        Text("Nota \(i + 1)")
                        Spacer()
                        TextField("0 - 20 o AN", text: $notas[i])
                            .multilineTextAlignment(.trailing)
                            .textInputAutocapitalization(.characters)
                            .autocorrectionDisabled()
                            .frame(maxWidth: 140)
                    }
                }
            } header: {
                Text("Ingresa las 4 notas")
            } footer: {
                Text("AN = laboratorio anulado: cuenta como 0 y no se puede eliminar.")
            }

            Section {
                BotonCalcular(titulo: "Calcular promedio", accion: calcular)
            }

            if let mensajeError {
                Section {
                    Text(mensajeError)
                        .foregroundStyle(.red)
                }
            }

            if let resultado {
                Section("Resultado") {
                    if let e = resultado.eliminada, let v = resultado.valorEliminado {
                        FilaResultado(titulo: "Nota eliminada",
                                      valor: "Nota \(e + 1) (\(String(format: "%.1f", v)))")
                    } else {
                        FilaResultado(titulo: "Nota eliminada", valor: "Ninguna")
                    }
                    FilaResultado(titulo: "Promedio", valor: String(format: "%.2f", resultado.promedio))
                    FilaResultado(titulo: "Promedio redondeado",
                                  valor: "\(resultado.redondeado)",
                                  destacado: true)
                }
            }
        }
        .navigationTitle("Notas de teoría")
        .navigationBarTitleDisplayMode(.inline)
        .scrollDismissesKeyboard(.interactively)
    }

    private func calcular() {
        resultado = nil
        mensajeError = nil

        var valores: [Double] = []
        var esAN: [Bool] = []

        for (i, texto) in notas.enumerated() {
            let t = texto.trimmingCharacters(in: .whitespaces).uppercased()
            if t == "AN" {
                valores.append(0)
                esAN.append(true)
            } else if let n = numero(t), n >= 0, n <= 20 {
                valores.append(n)
                esAN.append(false)
            } else {
                mensajeError = "La nota \(i + 1) debe estar entre 0 y 20 (o AN)."
                return
            }
        }

        // La menor nota que SÍ se puede eliminar (las AN no se eliminan)
        let candidatas = valores.indices.filter { !esAN[$0] }
        let eliminada = candidatas.min(by: { valores[$0] < valores[$1] })

        var suma = valores.reduce(0, +)
        var cantidad = Double(valores.count)
        if let e = eliminada {
            suma -= valores[e]
            cantidad -= 1
        }

        let promedio = suma / cantidad
        resultado = Resultado(eliminada: eliminada,
                              valorEliminado: eliminada.map { valores[$0] },
                              promedio: promedio,
                              redondeado: Int(promedio.rounded()))
    }
}

#Preview {
    NavigationStack { NotasTeoriaView() }
}
