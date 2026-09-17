// ===== CASO 1.5: HERENCIA Y POLIMORFISMO — LA CADENA DE SUCURSALES =====

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
        if monto >= 1500 {
            return 0.0
        } else {
            return 30.0
        }
    }
}

// --- TODO 15: SucursalProvincia ---
class SucursalProvincia: Sucursal {
    // No sobreescribe descuento(): hereda el 5 % de la base

    override func costoEnvio(monto: Double) -> Double {
        let calculado = monto * 0.08
        if calculado < 50.0 {
            return 50.0
        } else {
            return calculado
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

// --- TODO 17: El recorrido polimorfico ---
let refrigeradora = Electrodomestico(nombre: "Refrigeradora", marca: "Frost", precioLista: 2000.0, categoria: .lineaBlanca)
let licuadora = Electrodomestico(nombre: "Licuadora", marca: "Mix", precioLista: 250.0, categoria: .pequenos)

let sucursales: [Sucursal] = [
    SucursalLima(nombre: "Lima Centro", ciudad: "Lima"),
    SucursalProvincia(nombre: "Provincia Cusco", ciudad: "Cusco"),
    SucursalOutlet(nombre: "Outlet Ate", ciudad: "Lima")
]

print("===== Refrigeradora (S/ 2000.0) =====")
for sucursal in sucursales {
    sucursal.cotizar(item: refrigeradora)
}

print("===== Licuadora (S/ 250.0) =====")
for sucursal in sucursales {
    sucursal.cotizar(item: licuadora)
}

// --- TODO 18: SucursalOnline ---
class SucursalOnline: Sucursal {
    override func costoEnvio(monto: Double) -> Double {
        return 15.0
    }
}
// Comentario pedido: solo necesité 3 líneas nuevas (la clase + el override),
// no toqué cotizar() ni los for-in porque el flujo ya está en la clase base.

// ===== FIX =====
class SucursalMall: Sucursal {
    // FIX 7: faltaba "override". Swift lo exige porque descuento() ya existe
    // en la clase base Sucursal, y sin "override" el compilador no sabe si
    // quieres reemplazar ese método o crear uno nuevo por error (evita bugs).
    override func descuento() -> Double {
        return 0.12
    }
}

class SucursalExpress: Sucursal {
    let radioKm: Int

    init(nombre: String, ciudad: String, radioKm: Int) {
        self.radioKm = radioKm
        // FIX 8: faltaba llamar a super.init() para inicializar nombre y ciudad
        // (propiedades heredadas de Sucursal). Toda subclase debe inicializar
        // primero sus propias propiedades y luego llamar a super.init().
        super.init(nombre: nombre, ciudad: ciudad)
    }
}

// ===== PREDICT =====
let misteriosa: Sucursal = SucursalLima(nombre: "Lima Centro", ciudad: "Lima")
print(misteriosa.descuento())
// PREDICT 6: imprime 0.1, no 0.05.
// Aunque la variable está DECLARADA como tipo Sucursal, en tiempo de ejecución
// Swift usa el tipo REAL del objeto (SucursalLima) para decidir qué método
// llamar — eso es dynamic dispatch / polimorfismo. El tipo de la variable
// (estático) solo importa para qué métodos puedes LLAMAR, no cuál se ejecuta.

let monto = 2000.0 * (1 - misteriosa.descuento())
print(misteriosa.costoEnvio(monto: monto))
// PREDICT 7: monto = 2000 * 0.9 = 1800.0. Como 1800 >= 1500, SucursalLima
// devuelve envío 0.0. Imprime: 0.0