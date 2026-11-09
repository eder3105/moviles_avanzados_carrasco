import Foundation

// Categoría del cliente: se CALCULA, no se guarda en la base de datos
enum CategoriaCliente: String {
    case regular = "Regular"
    case frecuente = "Frecuente"
    case vip = "VIP"
}

// Resultado del cálculo de una venta
struct CalculoVenta {
    let subtotal: Double
    let descuento: Double
    let igv: Double
    let total: Double
}

// Reglas de negocio del caso Ventas (Grupo A)
enum Reglas {
    static let tasaIGV = 0.18      // IGV 18 %
    static let descuentoVIP = 0.10 // VIP 10 % del subtotal

    // Lo comprado por el cliente: suma de sus ventas NO anuladas
    static func totalComprado(_ cliente: Cliente) -> Double {
        let ventas = (cliente.ventas as? Set<Venta>) ?? []
        return ventas.filter { !$0.anulada }.reduce(0) { $0 + $1.total }
    }

    // Regular < S/ 1,000 · Frecuente desde S/ 1,000 · VIP desde S/ 5,000
    static func categoria(_ cliente: Cliente) -> CategoriaCliente {
        let comprado = totalComprado(cliente)
        if comprado >= 5000 { return .vip }
        if comprado >= 1000 { return .frecuente }
        return .regular
    }

    // subtotal = precio x cantidad
    // descuento = 10 % del subtotal si es VIP
    // IGV = 18 % sobre (subtotal - descuento)
    // total = subtotal - descuento + IGV
    // Ejemplo caso 4: 2 x 200 = 400 · desc 40 · IGV 64.80 · total 424.80
    static func calcular(precio: Double, cantidad: Int, categoria: CategoriaCliente) -> CalculoVenta {
        let subtotal = redondear(precio * Double(cantidad))
        let descuento = categoria == .vip ? redondear(subtotal * descuentoVIP) : 0
        let igv = redondear((subtotal - descuento) * tasaIGV)
        let total = redondear(subtotal - descuento + igv)
        return CalculoVenta(subtotal: subtotal, descuento: descuento, igv: igv, total: total)
    }
}
