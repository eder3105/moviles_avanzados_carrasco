import Foundation

// MARK: - SISTEMA DE PRESTAMO DE LIBROS

print("=== SISTEMA DE PRESTAMO DE LIBROS ===")


// MARK: - INGRESO Y VALIDACION DEL TITULO

var titulo = ""

repeat {
    print("Titulo del libro:")
    titulo = readLine() ?? ""

    if titulo.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
        print("Error: El titulo del libro no puede estar vacio.")
        print("")
    }

} while titulo.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty


// MARK: - SELECCION Y VALIDACION DEL USUARIO

print("")
print("Seleccione tipo de usuario:")
print("1. Alumno")
print("2. Docente")
print("3. Administrativo")
print("4. Coordinador")

var opcion = 0

repeat {

    print("Ingrese una opcion del 1 al 4:")

    if let entrada = readLine(),
       let numero = Int(entrada),
       numero >= 1 && numero <= 4 {

        opcion = numero

    } else {
        print("Error: Ese tipo de usuario no existe.")
        print("")
    }

} while opcion < 1 || opcion > 4


// MARK: - DATOS SEGUN TIPO DE USUARIO

var tipoUsuario = ""
var diasOtorgados = 0
var tasaMulta = 0.0

if opcion == 1 {

    tipoUsuario = "Alumno"
    diasOtorgados = 7
    tasaMulta = 1.5

} else if opcion == 2 {

    tipoUsuario = "Docente"
    diasOtorgados = 15
    tasaMulta = 2.0

} else if opcion == 3 {

    tipoUsuario = "Administrativo"
    diasOtorgados = 10
    tasaMulta = 3.0

} else if opcion == 4 {

    tipoUsuario = "Coordinador"
    diasOtorgados = 15
    tasaMulta = 4.0
}


// MARK: - CONFIGURACION DE FECHAS

let formatter = DateFormatter()
formatter.dateFormat = "dd/MM/yyyy"
formatter.isLenient = false

let calendar = Calendar.current


// MARK: - FUNCION PARA FORMATEAR FECHA

func formatearFecha(_ texto: String) -> String {

    let textoLimpio = texto.trimmingCharacters(in: .whitespacesAndNewlines)

    // Si ya tiene formato dd/MM/yyyy
    if textoLimpio.count == 10 {
        return textoLimpio
    }

    // Si escribe ddMMyyyy
    if textoLimpio.count == 8,
       textoLimpio.allSatisfy({ $0.isNumber }) {

        let indiceDia = textoLimpio.index(
            textoLimpio.startIndex,
            offsetBy: 2
        )

        let indiceMes = textoLimpio.index(
            textoLimpio.startIndex,
            offsetBy: 4
        )

        let dia = textoLimpio[..<indiceDia]
        let mes = textoLimpio[indiceDia..<indiceMes]
        let anio = textoLimpio[indiceMes...]

        return "\(dia)/\(mes)/\(anio)"
    }

    return textoLimpio
}


// MARK: - FECHA DE PRESTAMO

var fechaPrestamo = Date()
var fechaPrestamoValida = false

repeat {

    print("")
    print("Fecha de prestamo (dd/MM/yyyy):")

    let entrada = readLine() ?? ""
    let fechaTexto = formatearFecha(entrada)

    if fechaTexto.count == 10,
       let fecha = formatter.date(from: fechaTexto),
       formatter.string(from: fecha) == fechaTexto {

        let hoy = calendar.startOfDay(for: Date())
        let fechaIngresada = calendar.startOfDay(for: fecha)

        if fechaIngresada < hoy {

            print("Error: La fecha de prestamo no puede ser una fecha pasada.")

        } else {

            fechaPrestamo = fecha
            fechaPrestamoValida = true

            print("Fecha registrada: \(formatter.string(from: fechaPrestamo))")
        }

    } else {

        print("Error: La fecha ingresada no existe o tiene un formato incorrecto.")
        print("Ejemplo correcto: 03/09/2026")
    }

} while !fechaPrestamoValida


// MARK: - CALCULAR FECHA LIMITE

let fechaLimite = calendar.date(
    byAdding: .day,
    value: diasOtorgados,
    to: fechaPrestamo
) ?? fechaPrestamo


// MARK: - MOSTRAR DATOS DEL PRESTAMO

print("")
print("=== PRESTAMO REGISTRADO ===")
print("Libro: \(titulo)")
print("Tipo de usuario: \(tipoUsuario)")
print("Tarifa base: S/ \(String(format: "%.2f", tasaMulta))")
print("Dias permitidos: \(diasOtorgados)")
print("Fecha de prestamo: \(formatter.string(from: fechaPrestamo))")
print("Fecha limite de devolucion: \(formatter.string(from: fechaLimite))")


// MARK: - FECHA REAL DE DEVOLUCION

var fechaDevolucion = Date()
var fechaDevolucionValida = false

repeat {

    print("")
    print("Fecha real de devolucion (dd/MM/yyyy):")

    let entrada = readLine() ?? ""
    let fechaTexto = formatearFecha(entrada)

    if fechaTexto.count == 10,
       let fecha = formatter.date(from: fechaTexto),
       formatter.string(from: fecha) == fechaTexto {

        if fecha < fechaPrestamo {

            print("Error: La fecha de devolucion no puede ser anterior a la fecha de prestamo.")

        } else {

            fechaDevolucion = fecha
            fechaDevolucionValida = true

            print("Fecha registrada: \(formatter.string(from: fechaDevolucion))")
        }

    } else {

        print("Error: La fecha ingresada no existe o tiene un formato incorrecto.")
        print("Ejemplo correcto: 15/09/2026")
    }

} while !fechaDevolucionValida


// MARK: - CALCULAR DIAS DE ATRASO

let diasAtrasoComponents = calendar.dateComponents(
    [.day],
    from: fechaLimite,
    to: fechaDevolucion
)

var diasAtraso = diasAtrasoComponents.day ?? 0

if diasAtraso < 0 {
    diasAtraso = 0
}


// MARK: - CALCULO DE MULTA Y CALENDARIO DIARIO

var multaTotal = 0.0

print("")
print("=== CALENDARIO DE MULTAS ===")

if diasAtraso == 0 {

    print("No existen dias de atraso.")
    print("El libro fue devuelto dentro del plazo establecido.")

} else {

    var dia = 1

    // Solo se calcula multa hasta el dia 20.
    // Desde el dia 21 el usuario queda suspendido.
    let diasParaCalcular = min(diasAtraso, 20)

    while dia <= diasParaCalcular {

        var tarifaDelDia = 0.0
        var porcentaje = "0%"

        // Dias 1 al 3: no paga
        if dia <= 3 {

            tarifaDelDia = 0.0
            porcentaje = "0%"

        // Dias 4 al 6: tarifa base + 25%
        } else if dia <= 6 {

            tarifaDelDia = tasaMulta + (tasaMulta * 0.25)
            porcentaje = "+25%"

        // Dias 7 al 10: tarifa base + 50%
        } else if dia <= 10 {

            tarifaDelDia = tasaMulta + (tasaMulta * 0.50)
            porcentaje = "+50%"

        // Dias 11 al 20: tarifa base + 100%
        } else {

            tarifaDelDia = tasaMulta + (tasaMulta * 1.00)
            porcentaje = "+100%"
        }

        // Calcular la fecha correspondiente al dia de atraso
        let fechaDiaAtraso = calendar.date(
            byAdding: .day,
            value: dia,
            to: fechaLimite
        ) ?? fechaLimite

        multaTotal += tarifaDelDia

        print(
            "Dia \(dia) | " +
            "\(formatter.string(from: fechaDiaAtraso)) | " +
            "\(porcentaje) | " +
            "S/ \(String(format: "%.2f", tarifaDelDia))"
        )

        dia += 1
    }

    // Si tiene 21 dias o mas
    if diasAtraso >= 21 {

        print("")
        print("Dia 21 en adelante: USUARIO SUSPENDIDO")
    }
}


// MARK: - SITUACION DEL USUARIO

var situacion = ""
var usuarioHabilitado = true

if diasAtraso == 0 {

    situacion = "Devuelto a tiempo"

} else if diasAtraso <= 3 {

    situacion = "Atraso sin multa"

} else if diasAtraso <= 6 {

    situacion = "Atraso con recargo del 25%"

} else if diasAtraso <= 10 {

    situacion = "Atraso con recargo del 50%"

} else if diasAtraso <= 20 {

    situacion = "Atraso con recargo del 100%"

} else {

    situacion = "Usuario suspendido"
    usuarioHabilitado = false
}


// MARK: - ESTADO DEL PRESTAMO

var estado = "Devuelto"

if diasAtraso > 0 {
    estado = "Devuelto con atraso"
}


// MARK: - MOSTRAR RESULTADOS

print("")
print("=== RESUMEN DEL PRESTAMO ===")

print("Libro: \(titulo)")
print("Tipo de usuario: \(tipoUsuario)")
print("Tarifa base: S/ \(String(format: "%.2f", tasaMulta))")
print("Dias permitidos: \(diasOtorgados)")

print("Fecha de prestamo: \(formatter.string(from: fechaPrestamo))")
print("Fecha limite: \(formatter.string(from: fechaLimite))")
print("Fecha real de devolucion: \(formatter.string(from: fechaDevolucion))")

print("Dias de atraso: \(diasAtraso)")
print("Multa total: S/ \(String(format: "%.2f", multaTotal))")

print("Estado: \(estado)")
print("Situacion: \(situacion)")
print("Usuario habilitado: \(usuarioHabilitado ? "Si" : "No")")
