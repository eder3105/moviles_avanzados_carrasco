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
