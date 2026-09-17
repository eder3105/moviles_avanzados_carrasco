import Foundation

struct CursoCatalogo {
    let id: Int
    let nombre: String
    let precioUnitario: Double
}

struct CursoComprado {
    let curso: CursoCatalogo
    let cantidad: Int
    
    var total: Double {
        return Double(cantidad) * curso.precioUnitario
    }
}

struct Estudiante {
    let nombre: String
    let dni: String
    let esAlumnoTecsup: Bool
}

// Catálogo de cursos predefinido con precios fijos
let catalogoCursos: [CursoCatalogo] = [
    CursoCatalogo(id: 1, nombre: "Swift Avanzado", precioUnitario: 450.00),
    CursoCatalogo(id: 2, nombre: "IA con Python", precioUnitario: 650.00),
    CursoCatalogo(id: 3, nombre: "Diseño UX/UI", precioUnitario: 500.00),
    CursoCatalogo(id: 4, nombre: "Desarrollo Web Fullstack", precioUnitario: 550.00)
]

struct Factura {
    let estudiante: Estudiante
    let cursos: [CursoComprado]
    
    var totalCantidadCursos: Int {
        return cursos.reduce(0) { $0 + $1.cantidad }
    }
    
    var subtotal: Double {
        return cursos.reduce(0.0) { $0 + $1.total }
    }
    
    var igv: Double {
        return subtotal * 0.18
    }
    
    var totalConIGV: Double {
        return subtotal + igv
    }
    
    var descuentoCantidad: Double {
        return totalCantidadCursos >= 3 ? (totalConIGV * 0.10) : 0.0
    }
    
    var descuentoTecsup: Double {
        return (estudiante.esAlumnoTecsup && totalCantidadCursos >= 3) ? 400.0 : 0.0
    }
    
    var totalFinal: Double {
        return totalConIGV - descuentoCantidad - descuentoTecsup
    }
}

extension Factura {
    func imprimirFactura() {
        print("\n==========================================")
        print("🎓 FACTURA DE CURSOS")
        print("Estudiante: \(estudiante.nombre)")
        print("DNI: \(estudiante.dni)")
        print("Alumno de Tecsup: \(estudiante.esAlumnoTecsup ? "Sí ✅" : "No ❌")")
        print("------------------------------------------")
        
        for item in cursos {
            let linea = String(format: "%-20@ x%-2d - S/ %7.2f", item.curso.nombre, item.cantidad, item.total)
            print(linea)
        }
        
        print("------------------------------------------")
        print(String(format: "Subtotal: S/ %.2f", subtotal))
        print(String(format: "IGV (18%%): S/ %.2f", igv))
        print(String(format: "Total con IGV: S/ %.2f", totalConIGV))
        
        if descuentoCantidad > 0 {
            print(String(format: "Descuento 10%% por cantidad: -S/ %.2f ✅", descuentoCantidad))
        }
        if descuentoTecsup > 0 {
            print(String(format: "Descuento especial Tecsup: -S/ %.2f ✅", descuentoTecsup))
        }
        
        print("------------------------------------------")
        print(String(format: "💰 TOTAL FINAL A PAGAR: S/ %.2f", totalFinal))
        print("==========================================")
    }
}