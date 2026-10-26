import SwiftUI

// Pantalla única. Controles usados (los del curso): Text, VStack, HStack, @State,
// TextField, Picker, Button y ScrollView. Todo lo demás son modificadores de estilo.

struct ContentView: View {

    // Datos de entrada
    @State private var sueldo = ""
    @State private var dias = ""
    @State private var hijos = 0            // 0 = No, 1 = Sí
    @State private var sistema = 0          // 0 = ONP, 1 = AFP
    @State private var afpElegida = "AFP Ejemplo"
    @State private var horas25 = ""
    @State private var horas35 = ""
    @State private var adelantos = ""
    @State private var renta = 0            // 0 = No, 1 = Sí (nivel 3)

    // Salida
    @State private var mensajeError = ""
    @State private var resultado: ResultadoBoleta? = nil
    @State private var comparativo: ComparativoPension? = nil

    // Nivel 3: encabezado (datos ficticios)
    let razonSocial = "Comercial Andina S.A.C."
    let trabajador = "Juan Pérez Quispe"

    // Paleta
    let marino = Color(red: 0.05, green: 0.11, blue: 0.28)
    let azul = Color(red: 0.16, green: 0.38, blue: 0.85)
    let turquesa = Color(red: 0.05, green: 0.60, blue: 0.66)
    let verde = Color(red: 0.10, green: 0.58, blue: 0.35)
    let rojo = Color(red: 0.82, green: 0.22, blue: 0.24)
    let naranja = Color(red: 0.92, green: 0.50, blue: 0.08)
    let tarjeta = Color(UIColor.systemBackground)

    var body: some View {
        VStack(spacing: 0) {
            cabecera

            ScrollView {
                VStack(spacing: 14) {
                    Text("\(razonSocial)  ·  \(trabajador)")
                        .font(.system(size: 12, design: .rounded))
                        .foregroundColor(Color.white.opacity(0.75))
                        .frame(maxWidth: .infinity, alignment: .leading)

                    seccion("1", "Datos del mes") {
                        HStack(spacing: 10) {
                            campo("Sueldo básico", "S/", $sueldo, .decimalPad)
                            campo("Días laborados (1 a 30)", "", $dias, .numberPad)
                        }
                        etiqueta("¿Tiene hijos?")
                        Picker("¿Tiene hijos?", selection: $hijos) {
                            Text("No").tag(0)
                            Text("Sí").tag(1)
                        }
                        .pickerStyle(.segmented)
                    }

                    seccion("2", "Sistema de pensiones") {
                        Picker("Sistema de pensiones", selection: $sistema) {
                            Text("ONP").tag(0)
                            Text("AFP").tag(1)
                        }
                        .pickerStyle(.segmented)

                        // Solo aparece si eligió AFP
                        if sistema == 1 {
                            etiqueta("¿Cuál AFP?")
                            Picker("AFP", selection: $afpElegida) {
                                Text("AFP Ejemplo").tag("AFP Ejemplo")
                                // Para agregar otra AFP: una línea Text(...).tag(...) aquí
                                // y su entrada en el diccionario Parametros.tasasAFP
                            }
                            .pickerStyle(.segmented)
                        }
                    }

                    seccion("3", "Extras (opcional)") {
                        HStack(spacing: 10) {
                            campo("Horas extras 25%", "", $horas25, .decimalPad)
                            campo("Horas extras 35%", "", $horas35, .decimalPad)
                        }
                        campo("Adelantos", "S/", $adelantos, .decimalPad)
                    }

                    seccion("4", "Renta de 5.ª categoría", insignia: "RETO") {
                        Picker("Renta 5.ª categoría", selection: $renta) {
                            Text("No calcular").tag(0)
                            Text("Calcular").tag(1)
                        }
                        .pickerStyle(.segmented)
                        Text("Estimación simplificada. Si la activas, se resta de tu neto y aparece en los descuentos.")
                            .font(.system(size: 12, design: .rounded))
                            .foregroundColor(.gray)
                    }

                    Button(action: { calcular() }) {
                        Text("CALCULAR")
                            .font(.system(size: 17, weight: .heavy, design: .rounded))
                            .kerning(2)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .foregroundColor(.white)
                            .background(turquesa)
                            .cornerRadius(14)
                            .shadow(color: turquesa.opacity(0.5), radius: 8, x: 0, y: 4)
                    }

                    if mensajeError != "" {
                        Text(mensajeError)
                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                            .foregroundColor(rojo)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(14)
                            .background(tarjeta)
                            .cornerRadius(14)
                    }

                    if let r = resultado {
                        boleta(r)
                        rotulo("ANÁLISIS")
                        distribucion(r)
                    }

                    if let c = comparativo, resultado != nil {
                        comparacion(c)
                    }

                    pie
                }
                .padding(16)
            }
        }
        .background(marino.ignoresSafeArea())
    }

    // MARK: - Cabecera fija y piezas sueltas

    var cabecera: some View {
        HStack {
            Text("BOLETA")
                .font(.system(size: 30, weight: .heavy, design: .rounded))
                .kerning(4)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("DE EJEMPLO")
                .font(.system(size: 10, weight: .bold, design: .rounded))
                .kerning(1)
                .foregroundColor(.white)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(Color.white.opacity(0.22))
                .cornerRadius(10)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }

    func rotulo(_ texto: String) -> some View {
        Text(texto)
            .font(.system(size: 12, weight: .heavy, design: .rounded))
            .kerning(2)
            .foregroundColor(Color.white.opacity(0.85))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 8)
    }

    var pie: some View {
        Text("Boleta de ejemplo con datos ficticios. No es un documento oficial.")
            .font(.system(size: 11, design: .rounded))
            .foregroundColor(Color.white.opacity(0.7))
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)
            .padding(.bottom, 8)
    }

    // MARK: - Piezas del formulario

    func seccion<Contenido: View>(_ numero: String, _ titulo: String, insignia: String = "",
                                  @ViewBuilder _ contenido: () -> Contenido) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                Text(numero)
                    .font(.system(size: 13, weight: .heavy, design: .rounded))
                    .foregroundColor(.white)
                    .frame(width: 26, height: 26)
                    .background(azul)
                    .cornerRadius(13)
                Text(titulo)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .frame(maxWidth: .infinity, alignment: .leading)
                if insignia != "" {
                    Text(insignia)
                        .font(.system(size: 10, weight: .heavy, design: .rounded))
                        .kerning(1)
                        .foregroundColor(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(naranja)
                        .cornerRadius(10)
                }
            }
            contenido()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(tarjeta)
        .cornerRadius(18)
        .shadow(color: Color.black.opacity(0.18), radius: 8, x: 0, y: 4)
    }

    func etiqueta(_ texto: String) -> some View {
        Text(texto)
            .font(.system(size: 12, weight: .semibold, design: .rounded))
            .foregroundColor(.gray)
    }

    func campo(_ titulo: String, _ prefijo: String, _ texto: Binding<String>,
               _ teclado: UIKeyboardType) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            etiqueta(titulo)
            HStack(spacing: 6) {
                if prefijo != "" {
                    Text(prefijo)
                        .font(.system(size: 16, weight: .heavy, design: .rounded))
                        .foregroundColor(azul)
                }
                TextField("0", text: texto)
                    .keyboardType(teclado)
            }
            .padding(12)
            .background(Color.gray.opacity(0.12))
            .cornerRadius(12)
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

    // MARK: - La boleta (papel blanco, estilo recibo, tres bloques y el neto)

    func boleta(_ r: ResultadoBoleta) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            encabezadoPapel
            bloqueRemuneraciones(r)
            linea
            bloqueDescuentos(r)
            linea
            bloqueAportaciones(r)
            linea
            bandaNeto(r)
        }
        .foregroundColor(Color.black)
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(6)
        .shadow(color: Color.black.opacity(0.35), radius: 10, x: 0, y: 6)
    }

    var encabezadoPapel: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("BOLETA DE PAGO")
                .font(.system(size: 18, weight: .heavy, design: .monospaced))
                .kerning(3)
                .frame(maxWidth: .infinity)
            Text("Boleta de ejemplo · datos ficticios")
                .font(.system(size: 11, design: .monospaced))
                .foregroundColor(Color.gray)
                .frame(maxWidth: .infinity)
            linea
            datoPapel("EMPRESA", razonSocial)
            datoPapel("TRABAJADOR", trabajador)
            linea
        }
    }

    func datoPapel(_ titulo: String, _ valor: String) -> some View {
        HStack(spacing: 6) {
            Text(titulo + ":")
                .font(.system(size: 12, weight: .bold, design: .monospaced))
                .foregroundColor(Color.gray)
            Text(valor)
                .font(.system(size: 12, design: .monospaced))
        }
    }

    // Línea punteada como en un recibo
    var linea: some View {
        Text(String(repeating: "- ", count: 18))
            .font(.system(size: 11, design: .monospaced))
            .foregroundColor(Color.gray)
            .lineLimit(1)
            .minimumScaleFactor(0.5)
            .frame(maxWidth: .infinity)
    }

    func banda(_ titulo: String, _ color: Color) -> some View {
        Text(titulo)
            .font(.system(size: 12, weight: .heavy, design: .rounded))
            .kerning(1)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(8)
            .background(color)
            .cornerRadius(4)
    }

    // Una fila de concepto: nombre a la izquierda, monto a la derecha.
    // Lo que no aplica se ve apagado (0.00), como en la boleta real.
    func fila(_ c: Concepto) -> some View {
        HStack {
            Text(c.nombre)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(soles(c.monto))
        }
        .font(.system(size: 14, design: .monospaced))
        .foregroundColor(c.monto == 0 ? Color.gray.opacity(0.6) : Color.black)
        .padding(.horizontal, 4)
    }

    func totalFila(_ nombre: String, _ monto: Double, _ color: Color) -> some View {
        HStack {
            Text(nombre)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("S/ \(soles(monto))")
        }
        .font(.system(size: 14, weight: .bold, design: .monospaced))
        .foregroundColor(color)
        .padding(8)
        .background(color.opacity(0.12))
        .cornerRadius(4)
    }

    func bloqueRemuneraciones(_ r: ResultadoBoleta) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            banda("REMUNERACIONES", azul)
            fila(r.remuneraciones[0])
            fila(r.remuneraciones[1])
            fila(r.remuneraciones[2])
            fila(r.remuneraciones[3])
            totalFila("Total remuneraciones", r.totalRemuneraciones, azul)
        }
    }

    func bloqueDescuentos(_ r: ResultadoBoleta) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            banda("RETENCIONES / DESCUENTOS", rojo)
            fila(r.descuentos[0])
            fila(r.descuentos[1])
            fila(r.descuentos[2])
            fila(r.descuentos[3])
            fila(r.descuentos[4])
            // Nivel 3: solo existe si activaste la renta de 5.ª categoría
            if r.descuentos.count > 5 {
                fila(r.descuentos[5])
            }
            totalFila("Total descuentos", r.totalDescuentos, rojo)
        }
    }

    func bloqueAportaciones(_ r: ResultadoBoleta) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            banda("APORTACIONES DEL EMPLEADOR", naranja)
            fila(r.aportaciones[0])
            totalFila("Total aportaciones", r.essalud, naranja)
        }
    }

    func bandaNeto(_ r: ResultadoBoleta) -> some View {
        VStack(spacing: 4) {
            Text("NETO A PAGAR")
                .font(.system(size: 13, weight: .heavy, design: .rounded))
                .kerning(3)
                .foregroundColor(Color.white.opacity(0.9))
            Text("S/ \(soles(r.neto))")
                .font(.system(size: 38, weight: .heavy, design: .monospaced))
                .foregroundColor(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            if r.descuentos.count > 5 {
                Text("Incluye retención de renta de 5.ª categoría")
                    .font(.system(size: 11, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Color.white.opacity(0.22))
                    .cornerRadius(10)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(verde)
        .cornerRadius(10)
    }

    // MARK: - Análisis 1: a dónde se va tu sueldo (barra hecha con Text)

    func distribucion(_ r: ResultadoBoleta) -> some View {
        let total = r.totalRemuneraciones
        let adel = r.descuentos[4].monto           // Adelantos
        let pension = max(r.totalDescuentos - adel, 0.0)
        let fNeto = total > 0 ? r.neto / total : 0.0
        let fPension = total > 0 ? pension / total : 0.0
        let fAdel = total > 0 ? adel / total : 0.0
        let ancho: CGFloat = 250
        let llegan = String(format: "%.2f", fNeto * 100)

        return VStack(alignment: .leading, spacing: 12) {
            Text("¿A dónde se va tu sueldo?")
                .font(.system(size: 16, weight: .bold, design: .rounded))

            Text("De cada S/ 100 de remuneración, te llegan S/ \(llegan)")
                .font(.system(size: 14, design: .rounded))
                .foregroundColor(.gray)

            HStack(spacing: 0) {
                Text(" ").frame(width: ancho * CGFloat(fNeto), height: 16).background(verde)
                Text(" ").frame(width: ancho * CGFloat(fPension), height: 16).background(rojo)
                Text(" ").frame(width: ancho * CGFloat(fAdel), height: 16).background(naranja)
            }
            .frame(width: ancho, alignment: .leading)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(8)

            leyenda(verde, "Te llega (neto)", r.neto, fNeto)
            if pension > 0 {
                leyenda(rojo, "Pensión e impuestos", pension, fPension)
            }
            if adel > 0 {
                leyenda(naranja, "Adelantos", adel, fAdel)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(tarjeta)
        .cornerRadius(18)
        .shadow(color: Color.black.opacity(0.18), radius: 8, x: 0, y: 4)
    }

    func leyenda(_ color: Color, _ texto: String, _ monto: Double, _ fraccion: Double) -> some View {
        HStack(spacing: 8) {
            Text("■")
                .foregroundColor(color)
            Text(texto)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("S/ \(soles(monto))")
            Text(String(format: "%.1f%%", fraccion * 100))
                .bold()
                .frame(width: 58, alignment: .trailing)
        }
        .font(.system(size: 14, design: .rounded))
    }

    // MARK: - Análisis 2 (nivel 3): ONP y AFP lado a lado

    func comparacion(_ c: ComparativoPension) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("¿ONP o AFP?")
                .font(.system(size: 16, weight: .bold, design: .rounded))
            Text("Mismos datos, mismo mes")
                .font(.system(size: 14, design: .rounded))
                .foregroundColor(.gray)

            HStack(alignment: .top, spacing: 10) {
                columna("ONP", c.onp, c.mejor == "ONP")
                columna(c.nombreAFP, c.afp, c.mejor == "AFP")
            }

            if c.mejor == "Igual" {
                Text("Con ambos sistemas recibes el mismo neto este mes.")
                    .font(.system(size: 15, weight: .semibold, design: .rounded))
            } else {
                Text("Este mes con \(c.mejor) recibes S/ \(soles(c.diferencia)) más.")
                    .font(.system(size: 15, weight: .semibold, design: .rounded))
            }
            Text("Solo compara el neto de este mes, no la pensión futura.")
                .font(.system(size: 12, design: .rounded))
                .foregroundColor(.gray)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(tarjeta)
        .cornerRadius(18)
        .shadow(color: Color.black.opacity(0.18), radius: 8, x: 0, y: 4)
    }

    func columna(_ titulo: String, _ r: ResultadoBoleta, _ gana: Bool) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(titulo)
                .font(.system(size: 14, weight: .heavy, design: .rounded))
                .foregroundColor(gana ? Color.white : Color.primary)
            Text("Descuentos")
                .font(.system(size: 12, design: .rounded))
                .foregroundColor(gana ? Color.white.opacity(0.8) : Color.gray)
            Text("S/ \(soles(r.totalDescuentos))")
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundColor(gana ? Color.white : Color.primary)
            Text("Neto")
                .font(.system(size: 12, design: .rounded))
                .foregroundColor(gana ? Color.white.opacity(0.8) : Color.gray)
            Text("S/ \(soles(r.neto))")
                .font(.system(size: 20, weight: .heavy, design: .rounded))
                .foregroundColor(gana ? Color.white : Color.primary)
            Text(gana ? "★ MEJOR ESTE MES" : " ")
                .font(.system(size: 11, weight: .heavy, design: .rounded))
                .foregroundColor(Color.white)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(gana ? verde : Color.gray.opacity(0.12))
        .cornerRadius(14)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
