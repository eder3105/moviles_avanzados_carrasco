// ===== CASO 1.5: HERENCIA Y POLIMORFISMO: LA CADENA DE SUCURSALES =====
// Docente: Juan León

enum CategoriaElectro {
    case lineaBlanca, tecnologia, pequenos
}

struct Electrodomestico {
    let nombre: String
    let marca: String
    let precioLista: Double
    let categoria: CategoriaElectro
}

class Sucursal {
    let nombre: String
    let ciudad: String
    
    init(nombre: String, ciudad: String) {
        self.nombre = nombre
        self.ciudad = ciudad
    }
    
    func descuento() -> Double {
        return 0.05
    }
    
    func costoEnvio(monto: Double) -> Double {
        return 30.0
    }
    
    // REGLA 2: Este método NO se sobreescribe en las subclases
    func cotizar(item: Electrodomestico) {
        let precioConDescuento = item.precioLista * (1 - descuento())
        let envio = costoEnvio(monto: precioConDescuento)
        let total = precioConDescuento + envio
        print("\(nombre): \(item.nombre) -> S/ \(precioConDescuento) + envio S/ \(envio) = S/ \(total)")
    }
}

// --- TODO 14: SucursalLima ---
class SucursalLima: Sucursal {
    override func descuento() -> Double {
        return 0.10
    }
    
    override func costoEnvio(monto: Double) -> Double {
        if monto >= 1500.0 {
            return 0.0
        } else {
            return 30.0
        }
    }
}

// --- TODO 15: SucursalProvincia ---
class SucursalProvincia: Sucursal {
    override func costoEnvio(monto: Double) -> Double {
        let envioCalculado = monto * 0.08
        if envioCalculado < 50.0 {
            return 50.0
        } else {
            return envioCalculado
        }
    }
}

// --- TODO 16: SucursalOutlet ---
class SucursalOutlet: Sucursal {
    override func descuento() -> Double {
        return 0.25
    }
    
    override func costoEnvio(monto: Double) -> Double {
        return 0.0
    }
}

// --- TODO 18: SucursalOnline (Prueba de polimorfismo) ---
class SucursalOnline: Sucursal {
    override func costoEnvio(monto: Double) -> Double {
        return 15.0
    }
}
/* 
 Respuesta: ¿Cuántas líneas nuevas se necesitaron para SucursalOnline?
 Se necesitaron exactamente 5 líneas de código nuevas.
*/

// --- TODO 17: El recorrido polimórfico (REGLA 4) ---
let refrigeradora = Electrodomestico(nombre: "Refrigeradora", marca: "Frost", precioLista: 2000.0, categoria: .lineaBlanca)
let licuadora = Electrodomestico(nombre: "Licuadora", marca: "Mix", precioLista: 250.0, categoria: .pequenos)

let sucursales: [Sucursal] = [
    SucursalLima(nombre: "Lima Centro", ciudad: "Lima"),
    SucursalProvincia(nombre: "Provincia Cusco", ciudad: "Cusco"),
    SucursalOutlet(nombre: "Outlet Ate", ciudad: "Lima"),
    SucursalOnline(nombre: "Tienda Web", ciudad: "Virtual")
]

print("===== Refrigeradora (S/ 2000.0) =====")
for sucursal in sucursales {
    sucursal.cotizar(item: refrigeradora)
}

print("===== Licuadora (S/ 250.0) =====")
for sucursal in sucursales {
    sucursal.cotizar(item: licuadora)
}

// ===== CASO 2: PARTE A - BIBLIOTECA (SIN IA) =====
// Docente: Juan León

enum EstadoLibro {
    case disponible, prestado
}

struct Libro {
    let titulo: String
    let autor: String
    var estado: EstadoLibro = .disponible
}

class Biblioteca {
    var libros: [Libro] = []
    
    func agregar(libro: Libro) {
        libros.append(libro)
    }
    
    func prestar(titulo: String) -> Bool {
        for i in 0..<libros.count {
            if libros[i].titulo == titulo {
                if libros[i].estado == .disponible {
                    libros[i].estado = .prestado
                    print("Préstamo aprobado: \(titulo)")
                    return true
                } else {
                    print("Error: \(titulo) ya está prestado")
                    return false
                }
            }
        }
        print("Error: no existe \(titulo)")
        return false
    }
    
    func devolver(titulo: String) -> Bool {
        for i in 0..<libros.count {
            if libros[i].titulo == titulo {
                if libros[i].estado == .prestado {
                    libros[i].estado = .disponible
                    print("Devolución registrada: \(titulo)")
                    return true
                } else {
                    print("Error: \(titulo) ya se encuentra disponible")
                    return false
                }
            }
        }
        print("Error: no existe \(titulo)")
        return false
    }
    
    func inventario() {
        print("===== INVENTARIO =====")
        for libro in libros {
            let estadoTexto = (libro.estado == .prestado) ? "prestado" : "disponible"
            print("\(libro.titulo) (\(libro.autor))\n\(estadoTexto)")
        }
    }
}

// Simulación solicitada
let miBiblioteca = Biblioteca()
miBiblioteca.agregar(libro: Libro(titulo: "Cien años de soledad", autor: "Gabriel García Márquez"))
miBiblioteca.agregar(libro: Libro(libro: "La ciudad y los perros", autor: "Mario Vargas Llosa"))
miBiblioteca.agregar(libro: Libro(titulo: "El Quijote", autor: "Miguel de Cervantes"))

miBiblioteca.prestar(titulo: "La ciudad y los perros")
miBiblioteca.prestar(titulo: "La ciudad y los perros") 
miBiblioteca.devolver(titulo: "La ciudad y los perros")
miBiblioteca.prestar(titulo: "El Quijote")
miBiblioteca.prestar(titulo: "El Principito") 
miBiblioteca.inventario()