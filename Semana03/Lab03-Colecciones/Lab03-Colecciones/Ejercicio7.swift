// Desarrollado por: Ederd Carrasco
import Foundation // Importa Foundation para poder usar Double(), Int(), etc.

// Diccionarios para guardar precio y stock de cada producto por nombre
var precios: [String: Double] = [:] // Diccionario vacío: nombre -> precio
var stocks: [String: Int] = [:] // Diccionario vacío: nombre -> stock

print("¿Cuántos productos va a registrar?") // Pregunta cuántos productos habrá en el inventario
let cantidadProductos = Int(readLine() ?? "") ?? 0 // Lee la cantidad, si falla usa 0

// Bucle para registrar cada producto inicial
for i in 1...cantidadProductos { // Repite una vez por cada producto a registrar
    print("\nProducto \(i) - Nombre:") // Pide el nombre del producto
    let nombre = readLine() ?? "" // Lee el nombre, si falla usa string vacío
    print("Precio:") // Pide el precio del producto
    let precio = Double(readLine() ?? "") ?? 0 // Convierte a número, si falla usa 0
    print("Stock:") // Pide la cantidad en stock
    let stock = Int(readLine() ?? "") ?? 0 // Convierte a número entero, si falla usa 0
    precios[nombre] = precio // Guarda el precio en el diccionario
    stocks[nombre] = stock // Guarda el stock en el diccionario
}

var continuar = true // Variable de control para mantener el menú funcionando (true = seguir mostrando menú)

// Bucle principal del menú, se repite hasta que el usuario elija Salir
while continuar { // Mientras "continuar" sea true, sigue mostrando el menú
    print("\n===== MENÚ INVENTARIO =====") // Encabezado del menú
    print("1) Ver inventario") // Opción 1
    print("2) Buscar producto") // Opción 2
    print("3) Stock bajo") // Opción 3
    print("4) Valor total") // Opción 4
    print("5) Salir") // Opción 5
    print("Elige una opción:") // Pide al usuario que escriba un número
    let opcion = Int(readLine() ?? "") ?? 0 // Lee la opción elegida, si falla usa 0 (opción inválida)

    switch opcion { // Evalúa qué opción eligió el usuario
    case 1: // Si eligió "Ver inventario"
        print("\n===== INVENTARIO COMPLETO =====") // Encabezado del reporte
        for (nombre, precio) in precios { // Recorre todos los productos
            let stockActual = stocks[nombre] ?? 0 // Obtiene el stock de ese producto, o 0 si no existe
            print("\(nombre): Precio S/. \(precio), Stock: \(stockActual)") // Muestra los datos del producto
        }
    case 2: // Si eligió "Buscar producto"
        print("Nombre del producto a buscar:") // Pide el nombre a buscar
        let buscar = readLine() ?? "" // Lee el nombre ingresado
        if let precioEncontrado = precios[buscar] { // Busca el producto de forma segura con Optional
            let stockEncontrado = stocks[buscar] ?? 0 // Obtiene su stock también
            print("\(buscar): Precio S/. \(precioEncontrado), Stock: \(stockEncontrado)") // Muestra el resultado
        } else { // Si no se encontró el producto
            print("Producto no encontrado") // Mensaje de error
        }
    case 3: // Si eligió "Stock bajo"
        print("\n===== PRODUCTOS CON STOCK BAJO (menos de 5) =====") // Encabezado
        for (nombre, stock) in stocks { // Recorre todos los productos
            if stock < 5 { // Si el stock es menor a 5 unidades
                print("\(nombre): solo quedan \(stock) unidades") // Muestra la alerta de stock bajo
            }
        }
    case 4: // Si eligió "Valor total"
        var valorTotal = 0.0 // Acumulador del valor total del inventario
        for (nombre, precio) in precios { // Recorre cada producto
            let stock = stocks[nombre] ?? 0 // Obtiene su stock
            valorTotal += precio * Double(stock) // Suma precio × stock al total
        }
        print("Valor total del inventario: S/. \(valorTotal)") // Muestra el valor total calculado
    case 5: // Si eligió "Salir"
        print("Saliendo del sistema...") // Mensaje de despedida
        continuar = false // Cambia la variable de control a false, esto detiene el bucle while
    default: // Si el usuario escribió un número que no es 1-5
        print("Opción inválida, intenta de nuevo") // Mensaje de error
    }
}