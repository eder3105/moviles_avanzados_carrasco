import Foundation

// MARK: - Ingreso de datos
print("=== SISTEMA DE PRESTAMO DE LIBROS ===")

print("Titulo del libro: ")
let titulo = readLine() ?? ""

print("Seleccione tipo de usuario:")
print("1. Alumno")
print("2. Docente")
print("3. Administrativo")
let opcion = Int(readLine() ?? "") ?? 1

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
} else {
    tipoUsuario = "Alumno"
    diasOtorgados = 7
}

let formatter = DateFormatter()
formatter.dateFormat = "dd/MM/yyyy"

print("Fecha de prestamo (dd/MM/yyyy): ")
let fechaPrestamoStr = readLine() ?? ""
let fechaPrestamo = formatter.date(from: fechaPrestamoStr) ?? Date()

print("Fecha de devolucion (dd/MM/yyyy): ")
let fechaDevolucionStr = readLine() ?? ""
let fechaDevolucion = formatter.date(from: fechaDevolucionStr) ?? Date()

//commit del ingreso de datos

// MARK: - Calculo de fecha limite y dias de atraso
let calendar = Calendar.current
let fechaLimite = calendar.date(byAdding: .day, value: diasOtorgados, to: fechaPrestamo) ?? fechaPrestamo

let diasAtrasoComponents = calendar.dateComponents([.day], from: fechaLimite, to: fechaDevolucion)
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

//commit del calculo

// MARK: - Mostrar resultados
formatter.dateFormat = "dd/MM/yyyy"

print("")
print("=== RESUMEN DEL PRESTAMO ===")
print("Libro: \(titulo)")
print("Tipo de usuario: \(tipoUsuario)")
print("Fecha de prestamo: \(formatter.string(from: fechaPrestamo))")
print("Fecha limite: \(formatter.string(from: fechaLimite))")
print("Fecha de devolucion: \(formatter.string(from: fechaDevolucion))")
print("Dias de atraso: \(diasAtraso)")
print("Multa total: S/ \(multaTotal)")
print("Estado: \(estado)")
print("Situacion: \(situacion)")
print("Usuario habilitado: \(usuarioHabilitado ? "Si" : "No")")

//commit de mostrar los datos
