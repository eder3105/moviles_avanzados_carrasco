import Foundation

// MARK: - Ingreso de datos

print("=== SISTEMA DE PRESTAMO DE LIBROS ===")

// Validar titulo
var titulo = ""

repeat {
    print("Titulo del libro: ")
    titulo = readLine() ?? ""

    if titulo.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
        print("Error: El titulo del libro no puede estar vacio.")
    }

} while titulo.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty


// Validar tipo de usuario
print("")
print("Seleccione tipo de usuario:")
print("1. Alumno")
print("2. Docente")
print("3. Administrativo")
print("4. Coordinador")

var opcion = 0

repeat {
    print("Ingrese una opcion del 1 al 4: ")

    if let entrada = readLine(),
       let numero = Int(entrada),
       numero >= 1 && numero <= 4 {

        opcion = numero

    } else {
        print("Error: Ese tipo de usuario no existe.")
    }

} while opcion < 1 || opcion > 4


var tipoUsuario = ""
var diasOtorgados = 0

if opcion == 1 {
    tipoUsuario = "Alumno"
    diasOtorgados = 7

} else if opcion == 2 {
    tipoUsuario = "Docente"
    diasOtorgados = 15

} else if opcion == 3 {
    tipoUsuario = "Administrativo"
    diasOtorgados = 10

} else if opcion == 4 {
    tipoUsuario = "Coordinador"
    diasOtorgados = 15
}


// MARK: - Configuracion de fechas

let formatter = DateFormatter()
formatter.dateFormat = "dd/MM/yyyy"
formatter.isLenient = false


// Funcion para agregar "/" si el usuario escribe ddMMyyyy
func formatearFecha(_ texto: String) -> String {

    let textoLimpio = texto.trimmingCharacters(in: .whitespacesAndNewlines)

    // Si ya tiene el formato dd/MM/yyyy
    if textoLimpio.count == 10 {
        return textoLimpio
    }

    // Si escribe solamente 8 numeros: ddMMyyyy
    if textoLimpio.count == 8,
       textoLimpio.allSatisfy({ $0.isNumber }) {

        let indiceDia = textoLimpio.index(textoLimpio.startIndex, offsetBy: 2)
        let indiceMes = textoLimpio.index(textoLimpio.startIndex, offsetBy: 4)

        let dia = textoLimpio[..<indiceDia]
        let mes = textoLimpio[indiceDia..<indiceMes]
        let anio = textoLimpio[indiceMes...]

        return "\(dia)/\(mes)/\(anio)"
    }

    return textoLimpio
}


// MARK: - Fecha de prestamo

var fechaPrestamo = Date()
var fechaPrestamoValida = false

repeat {

    print("")
    print("Fecha de prestamo (dd/MM/yyyy): ")

    let entrada = readLine() ?? ""
    let fechaTexto = formatearFecha(entrada)

    if fechaTexto.count == 10,
       let fecha = formatter.date(from: fechaTexto),
       formatter.string(from: fecha) == fechaTexto {

        fechaPrestamo = fecha
        fechaPrestamoValida = true

        print("Fecha registrada: \(formatter.string(from: fechaPrestamo))")

    } else {
        print("Error: La fecha de prestamo no es valida.")
        print("Ejemplo correcto: 03/09/2026")
    }

} while !fechaPrestamoValida


// MARK: - Fecha de devolucion

var fechaDevolucion = Date()
var fechaDevolucionValida = false

repeat {

    print("")
    print("Fecha de devolucion (dd/MM/yyyy): ")

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

        print("Error: La fecha de devolucion no es valida.")
        print("Ejemplo correcto: 10/09/2026")
    }

} while !fechaDevolucionValida


// Validar que la fecha de devolucion no supere los dias permitidos

let calendar = Calendar.current

let fechaMaximaPermitida = calendar.date(
    byAdding: .day,
    value: diasOtorgados,
    to: fechaPrestamo
) ?? fechaPrestamo

if fechaDevolucion > fechaMaximaPermitida {

    print("")
    print("NO SE PUEDE REALIZAR EL PRESTAMO")
    print("El tipo de usuario \(tipoUsuario) solo puede tener el libro por \(diasOtorgados) dias.")
    print("Fecha maxima de devolucion: \(formatter.string(from: fechaMaximaPermitida))")

    exit(0)
}

// commit del ingreso de datos


// MARK: - Calculo de fecha limite y dias de atraso

let fechaLimite = calendar.date(
    byAdding: .day,
    value: diasOtorgados,
    to: fechaPrestamo
) ?? fechaPrestamo

let diasAtrasoComponents = calendar.dateComponents(
    [.day],
    from: fechaLimite,
    to: fechaDevolucion
)

var diasAtraso = diasAtrasoComponents.day ?? 0

if diasAtraso < 0 {
    diasAtraso = 0
}


// MARK: - Tarifa de multa segun tipo de usuario

var tasaMulta = 0.0

if tipoUsuario == "Alumno" {
    tasaMulta = 1.5

} else if tipoUsuario == "Docente" {
    tasaMulta = 2.0

} else if tipoUsuario == "Administrativo" {
    tasaMulta = 3.0

} else if tipoUsuario == "Coordinador" {
    tasaMulta = 4.0
}


// MARK: - Multa progresiva, dia por dia

var multaTotal = 0.0

if diasAtraso > 0 {

    var dia = 1

    while dia <= diasAtraso {

        var tarifaDelDia = tasaMulta

        if dia >= 4 && dia <= 6 {
            tarifaDelDia = tasaMulta * 1.5

        } else if dia >= 7 {
            tarifaDelDia = tasaMulta * 2.0
        }

        multaTotal += tarifaDelDia
        dia += 1
    }
}


// MARK: - Situacion y estado

var situacion = ""
var usuarioHabilitado = true

if diasAtraso == 0 {

    situacion = "Devuelto a tiempo"

} else if diasAtraso <= 3 {

    situacion = "Atraso leve"

} else if diasAtraso <= 6 {

    situacion = "Atraso moderado"

} else if diasAtraso <= 9 {

    situacion = "Atraso grave"

} else {

    situacion = "Usuario suspendido"
    usuarioHabilitado = false
}


var estado = "Devuelto"

if diasAtraso > 0 {
    estado = "Devuelto con atraso"
}

// commit del calculo


// MARK: - Mostrar resultados

print("")
print("=== RESUMEN DEL PRESTAMO ===")
print("Libro: \(titulo)")
print("Tipo de usuario: \(tipoUsuario)")
print("Fecha de prestamo: \(formatter.string(from: fechaPrestamo))")
print("Fecha limite: \(formatter.string(from: fechaLimite))")
print("Fecha de devolucion: \(formatter.string(from: fechaDevolucion))")
print("Dias de atraso: \(diasAtraso)")
print("Multa total: S/ \(String(format: "%.2f", multaTotal))")
print("Estado: \(estado)")
print("Situacion: \(situacion)")
print("Usuario habilitado: \(usuarioHabilitado ? "Si" : "No")")

// commit de mostrar los datos
