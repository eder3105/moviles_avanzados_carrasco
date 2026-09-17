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