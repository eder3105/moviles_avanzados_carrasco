import Foundation
import CoreData

// Datos de prueba: se cargan una sola vez, si no hay productos.
// Sirven para probar los casos 4, 5 y 6 de la guía:
// - Laptop S/ 200 con stock 40 y Mouse S/ 35
// - "Comercial Andina SAC" ya es VIP porque tiene una compra antigua de S/ 6,372
// - "Juan Pérez" es Regular (no tiene compras)
enum DatosDemo {
    static func cargarSiVacio() {
        let ctx = contexto()
        let req: NSFetchRequest<Producto> = Producto.fetchRequest()
        if ((try? ctx.count(for: req)) ?? 0) > 0 { return }

        func producto(_ nombre: String, _ categoria: String, _ precio: Double, _ stock: Int64) -> Producto {
            let p = Producto(context: ctx)
            p.nombre = nombre
            p.categoria = categoria
            p.precio = precio
            p.stock = stock
            return p
        }
        _ = producto("Laptop", "Computo", 200, 40)
        _ = producto("Mouse", "Accesorios", 35, 50)
        _ = producto("Teclado", "Accesorios", 60, 8)
        let monitor = producto("Monitor", "Computo", 450, 4)

        let vip = Cliente(context: ctx)
        vip.nombre = "Comercial Andina SAC"
        vip.documento = "20123456789"

        let regular = Cliente(context: ctx)
        regular.nombre = "Juan Pérez"
        regular.documento = "45678912"

        // Vendedor de ejemplo para la compra antigua del cliente VIP
        let demo = Usuario(context: ctx)
        demo.nombre = "Vendedor Demo"
        demo.usuario = "vdemo"
        demo.clave = "123456"
        demo.rol = "Vendedor"

        // Compra antigua (hace 40 días): 12 monitores = S/ 6,372 -> el cliente queda VIP
        let calculo = Reglas.calcular(precio: 450, cantidad: 12, categoria: .regular)
        let antigua = Venta(context: ctx)
        antigua.fecha = Calendar.current.date(byAdding: .day, value: -40, to: Date())
        antigua.cantidad = 12
        antigua.precioUnitario = 450
        antigua.descuento = calculo.descuento
        antigua.igv = calculo.igv
        antigua.total = calculo.total
        antigua.anulada = false
        antigua.vendedor = demo
        antigua.cliente = vip
        antigua.producto = monitor

        do {
            try ctx.save()
        } catch {
            print("Error al cargar datos de prueba: \(error)")
        }
    }
}
