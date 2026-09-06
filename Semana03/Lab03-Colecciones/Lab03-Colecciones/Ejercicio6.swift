// Desarrollado por: Ederd Carrasco
import Foundation // Importa Foundation para poder usar funciones adicionales como Double()

// Diccionario donde cada alumno (clave) tiene un array de 3 notas (valor)
var notasAlumnos: [String: [Double]] = [:] // Se crea vacío, tipo [String: [Double]]

print("¿Cuántos alumnos?") // Pregunta cuántos alumnos se van a registrar
let cantidadAlumnos = Int(readLine() ?? "") ?? 0 // Lee la cantidad, si falla usa 0

// Bucle para pedir el nombre y las 3 notas de cada alumno
for i in 1...cantidadAlumnos { // Repite una vez por cada alumno
    print("\nAlumno \(i) - Nombre:") // Pide el nombre del alumno actual
    let nombre = readLine() ?? "" // Lee el nombre, si falla usa string vacío
    var notas: [Double] = [] // Array temporal para guardar las 3 notas de este alumno
    for j in 1...3 { // Repite 3 veces, una por cada nota
        print("Nota \(j):") // Pide la nota número j
        let nota = Double(readLine() ?? "") ?? 0 // Convierte el texto a número, si falla usa 0
        notas.append(nota) // Agrega la nota al array temporal
    }
    notasAlumnos[nombre] = notas // Guarda el array de 3 notas en el diccionario, bajo la clave "nombre"
}

// Diccionario para guardar el promedio de cada alumno
var promedios: [String: Double] = [:] // Vacío al inicio, se llena en el siguiente bucle

// Calcula el promedio de cada alumno y lo guarda en "promedios"
for (nombre, notas) in notasAlumnos { // Recorre cada par nombre-notas del diccionario
    var suma = 0.0 // Acumulador de la suma de las 3 notas
    for nota in notas { // Recorre las 3 notas del alumno actual
        suma += nota // Suma cada nota al acumulador
    }
    let promedio = suma / Double(notas.count) // Calcula el promedio dividiendo suma entre cantidad de notas
    promedios[nombre] = promedio // Guarda el promedio calculado en el diccionario de promedios
}

print("\n===== REPORTE POR ALUMNO =====") // Encabezado del reporte individual
// Clasifica y muestra el promedio de cada alumno
for (nombre, promedio) in promedios { // Recorre cada alumno con su promedio
    var clasificacion = "" // Variable para guardar el texto de la clasificación
    switch promedio { // Evalúa en qué rango cae el promedio
    case 17...20: clasificacion = "Excelente" // De 17 a 20 es Excelente
    case 14..<17: clasificacion = "Bueno" // De 14 a 16.99 es Bueno
    case 11..<14: clasificacion = "Aprobado" // De 11 a 13.99 es Aprobado
    default: clasificacion = "Desaprobado" // Cualquier otro caso (menos de 11) es Desaprobado
    }
    print("\(nombre): Promedio \(promedio) → \(clasificacion)") // Imprime el resultado de este alumno
}

// ===== ESTADÍSTICAS GENERALES =====
print("\n===== ESTADÍSTICAS =====") // Encabezado de estadísticas generales

var sumaPromedios = 0.0 // Acumulador para calcular el promedio general de la clase
for (_, promedio) in promedios { // Recorre solo los valores (promedios), ignora el nombre con "_"
    sumaPromedios += promedio // Suma cada promedio individual
}
let promedioGeneral = sumaPromedios / Double(promedios.count) // Divide la suma entre el número de alumnos
print("Promedio general: \(promedioGeneral)") // Muestra el promedio general de toda la clase

let notaMasAlta = promedios.values.max() ?? 0 // Obtiene el promedio más alto de todos, o 0 si está vacío
let notaMasBaja = promedios.values.min() ?? 0 // Obtiene el promedio más bajo de todos, o 0 si está vacío
print("Nota más alta: \(notaMasAlta)") // Muestra el promedio más alto
print("Nota más baja: \(notaMasBaja)") // Muestra el promedio más bajo

var totalAprobados = 0 // Contador de alumnos aprobados (promedio >= 11)
for (_, promedio) in promedios { // Recorre todos los promedios
    if promedio >= 11 { // Si el promedio es 11 o más, se considera aprobado
        totalAprobados += 1 // Aumenta el contador de aprobados
    }
}
let porcentajeAprobados = (Double(totalAprobados) / Double(promedios.count)) * 100 // Calcula el % de aprobados
print("Porcentaje de aprobados: \(porcentajeAprobados)%") // Muestra el porcentaje de aprobados

// ===== ORDENAR POR PROMEDIO =====
print("\n===== RANKING (mayor a menor) =====") // Encabezado del ranking ordenado
let ranking = promedios.sorted { $0.value > $1.value } // Ordena el diccionario por promedio, de mayor a menor
for (nombre, promedio) in ranking { // Recorre la lista ya ordenada
    print("\(nombre): \(promedio)") // Muestra cada alumno en orden de mejor a peor promedio
}