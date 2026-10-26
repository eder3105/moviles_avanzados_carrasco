import SwiftUI

struct ContentView: View {

    // Datos de entrada
    @State private var sueldo = ""
    @State private var dias = ""
    @State private var hijos = 0            // 0 = No, 1 = Sí
    @State private var sistema = 0          // 0 = ONP, 1 = AFP
    @State private var afpElegida = Parametros.nombresAFP.first ?? ""
    @State private var horas25 = ""
    @State private var horas35 = ""
    @State private var adelantos = ""
    @State private var renta = 0            // 0 = No, 1 = Sí (nivel 3)

    // Salida
    @State private var mensajeError = ""
    @State private var resultado: ResultadoBoleta? = nil
    @State private var comparativo: ComparativoPension? = nil

    // Nivel 3: encabezado (datos ficticios)
    let razonSocial = "Comercial Andina S.A.C. (ficticia)"
    let trabajador = "Juan Pérez Quispe (ficticio)"

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                encabezado
                formulario

                Button("Calcular") {
                    calcular()
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 10)
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))

                if mensajeError != "" {
                    Text(mensajeError)
                        .foregroundColor(.red)
                }

                if let r = resultado {
                    boleta(r)
                }

                if let c = comparativo, resultado != nil {
                    comparacion(c)
                }
            }
            .padding()
        }
    }

    // MARK: - Encabezado

    var encabezado: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Boleta de ejemplo")
                .font(.title)
                .bold()
            Text("Razón social: \(razonSocial)")
            Text("Trabajador: \(trabajador)")
        }
    }

    // MARK: - Formulario

    var formulario: some View {
        VStack(alignment: .leading, spacing: 10) {
            campo("Sueldo básico (S/)", $sueldo, .decimalPad)
            campo("Días laborados (1 a 30)", $dias, .numberPad)

            Text("¿Tiene hijos?")
            Picker("¿Tiene hijos?", selection: $hijos) {
                Text("No").tag(0)
                Text("Sí").tag(1)
            }
            .pickerStyle(.segmented)

            Text("Sistema de pensiones")
            Picker("Sistema de pensiones", selection: $sistema) {
                Text("ONP").tag(0)
                Text("AFP").tag(1)
            }
            .pickerStyle(.segmented)

            // Solo aparece si eligió AFP
            if sistema == 1 {
                Text("AFP")
                Picker("AFP", selection: $afpElegida) {
                    ForEach(Parametros.nombresAFP, id: \.self) { nombre in
                        Text(nombre).tag(nombre)
                    }
                }
                .pickerStyle(.segmented)
            }

            campo("Horas extras al 25%", $horas25, .decimalPad)
            campo("Horas extras al 35%", $horas35, .decimalPad)
            campo("Adelantos (S/)", $adelantos, .decimalPad)

            Text("Retención de renta 5.ª categoría (reto)")
            Picker("Renta 5.ª categoría", selection: $renta) {
                Text("No").tag(0)
                Text("Sí").tag(1)
            }
            .pickerStyle(.segmented)
        }
    }

    func campo(_ titulo: String, _ texto: Binding<String>, _ teclado: UIKeyboardType) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(titulo)
            TextField(titulo, text: texto)
                .keyboardType(teclado)
                .textFieldStyle(.roundedBorder)
        }
    }

    // MARK: - Acción

    func calcular() {
        let respuesta = Validador.validar(sueldo: sueldo,
                                          dias: dias,
                                          tieneHijos: hijos == 1,
                                          sistema: sistema == 1 ? .afp : .onp,
                                          afp: afpElegida,
                                          horas25: horas25,
                                          horas35: horas35,
                                          adelantos: adelantos,
                                          calcularRenta: renta == 1)
        switch respuesta {
        case .failure(let error):
            mensajeError = error.mensaje
            resultado = nil
            comparativo = nil
        case .success(let datos):
            mensajeError = ""
            let boleta = Boleta(datos: datos)
            resultado = boleta.calcular()
            comparativo = boleta.comparar()
        }
    }

    // MARK: - Boleta (tres bloques uno debajo del otro)

    func boleta(_ r: ResultadoBoleta) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            bloque("REMUNERACIONES", r.remuneraciones, "Total remuneraciones", r.totalRemuneraciones)
            bloque("RETENCIONES / DESCUENTOS", r.descuentos, "Total descuentos", r.totalDescuentos)
            bloque("APORTACIONES DEL EMPLEADOR", r.aportaciones, "Total aportaciones", r.essalud)

            Text("NETO A PAGAR: S/ \(soles(r.neto))")
                .font(.title2)
                .bold()
        }
    }

    func bloque(_ titulo: String, _ conceptos: [Concepto], _ totalNombre: String, _ total: Double) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(titulo)
                .font(.headline)
            ForEach(conceptos) { c in
                HStack {
                    Text(c.nombre)
                    Spacer()
                    Text(soles(c.monto))
                }
            }
            HStack {
                Text(totalNombre).bold()
                Spacer()
                Text(soles(total)).bold()
            }
        }
        .padding()
        .background(Color.gray.opacity(0.12))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }

    // MARK: - Nivel 3: ONP y AFP lado a lado

    func comparacion(_ c: ComparativoPension) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("ONP vs AFP (mismos datos)")
                .font(.headline)
            HStack(alignment: .top, spacing: 12) {
                columna("ONP", c.onp)
                columna(c.nombreAFP, c.afp)
            }
            if c.mejor == "Igual" {
                Text("Con ambos sistemas recibes el mismo neto este mes.")
            } else {
                Text("Este mes con \(c.mejor) recibes S/ \(soles(c.diferencia)) más.")
            }
        }
    }

    func columna(_ titulo: String, _ r: ResultadoBoleta) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(titulo).bold()
            Text("Descuentos: \(soles(r.totalDescuentos))")
            Text("Neto: \(soles(r.neto))")
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.gray.opacity(0.12))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
