import UIKit
import CoreData

// A5 · Nueva venta (solo vendedor)
// ① Vendedor de la sesión (automático) · ② Cliente · ③ Producto
// ④ Cantidad con stepper y stock disponible · ⑤ Resumen calculado · ⑥ Registrar venta
class NuevaVentaViewController: UIViewController {

    private var cliente: Cliente?
    private var producto: Producto?

    private let lblVendedor = UILabel()
    private let btnCliente = UIButton(configuration: .gray())
    private let btnProducto = UIButton(configuration: .gray())
    private let txtCantidad = crearCampo("Cantidad")
    private let stepper = UIStepper()
    private let lblStock = UILabel()
    private let lblResumen = UILabel()
    private let btnRegistrar = UIButton(configuration: .filled())

    // Cantidad escrita (0 si no es un número válido)
    private var cantidad: Int {
        return Int(txtCantidad.text ?? "") ?? 0
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        lblVendedor.textColor = .secondaryLabel
        btnCliente.showsMenuAsPrimaryAction = true
        btnProducto.showsMenuAsPrimaryAction = true

        // ④ Cantidad: se puede escribir o usar el stepper
        txtCantidad.keyboardType = .numberPad
        txtCantidad.text = "1"
        txtCantidad.addTarget(self, action: #selector(cantidadEscrita), for: .editingChanged)
        stepper.minimumValue = 1
        stepper.maximumValue = 999
        stepper.value = 1
        stepper.addTarget(self, action: #selector(cantidadConStepper), for: .valueChanged)
        let filaCantidad = UIStackView(arrangedSubviews: [txtCantidad, stepper])
        filaCantidad.spacing = 12
        filaCantidad.alignment = .center

        lblStock.textColor = .secondaryLabel
        lblResumen.numberOfLines = 0
        lblResumen.font = .monospacedDigitSystemFont(ofSize: 16, weight: .regular)

        btnRegistrar.setTitle("Registrar venta", for: .normal)
        btnRegistrar.addTarget(self, action: #selector(registrar), for: .touchUpInside)

        montarPila([lblVendedor,
                    crearTitulo("Cliente"), btnCliente,
                    crearTitulo("Producto"), btnProducto,
                    crearTitulo("Cantidad"), filaCantidad, lblStock,
                    crearTitulo("Resumen"), lblResumen,
                    btnRegistrar])
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // ① El vendedor sale de la sesión: no se puede cambiar
        lblVendedor.text = "Vendedor: \(Sesion.shared.usuario?.nombre ?? "") (automático)"
        armarMenus()
        actualizar()
    }

    // ② y ③ Menús con los clientes y productos actuales
    private func armarMenus() {
        let reqClientes: NSFetchRequest<Cliente> = Cliente.fetchRequest()
        reqClientes.sortDescriptors = [NSSortDescriptor(key: "nombre", ascending: true)]
        let clientes = (try? contexto().fetch(reqClientes)) ?? []
        btnCliente.menu = UIMenu(children: clientes.map { c in
            UIAction(title: "\(c.nombre ?? "") (\(Reglas.categoria(c).rawValue))") { [weak self] _ in
                self?.cliente = c
                self?.actualizar()
            }
        })

        let reqProductos: NSFetchRequest<Producto> = Producto.fetchRequest()
        reqProductos.sortDescriptors = [NSSortDescriptor(key: "nombre", ascending: true)]
        let productos = (try? contexto().fetch(reqProductos)) ?? []
        btnProducto.menu = UIMenu(children: productos.map { p in
            UIAction(title: "\(p.nombre ?? "") · \(soles(p.precio)) · stock \(p.stock)") { [weak self] _ in
                self?.producto = p
                self?.actualizar()
            }
        })
    }

    @objc private func cantidadConStepper() {
        txtCantidad.text = String(Int(stepper.value))
        actualizar()
    }

    @objc private func cantidadEscrita() {
        if cantidad >= 1 {
            stepper.value = Double(min(cantidad, 999))
        }
        actualizar()
    }

    // ⑤ Recalcula el resumen cada vez que cambia algo
    private func actualizar() {
        if let c = cliente {
            btnCliente.setTitle("\(c.nombre ?? "") (\(Reglas.categoria(c).rawValue))", for: .normal)
        } else {
            btnCliente.setTitle("Elegir cliente", for: .normal)
        }
        if let p = producto {
            btnProducto.setTitle("\(p.nombre ?? "") · \(soles(p.precio))", for: .normal)
            lblStock.text = "Stock disponible: \(p.stock)"
        } else {
            btnProducto.setTitle("Elegir producto", for: .normal)
            lblStock.text = "Stock disponible: —"
        }

        guard let c = cliente, let p = producto, cantidad > 0 else {
            lblResumen.text = "Elige cliente, producto y cantidad."
            return
        }
        let categoria = Reglas.categoria(c)
        let calculo = Reglas.calcular(precio: p.precio, cantidad: cantidad, categoria: categoria)
        lblResumen.text = """
        Subtotal:   \(soles(calculo.subtotal))
        Descuento:  \(soles(calculo.descuento)) (\(categoria.rawValue))
        IGV 18 %:   \(soles(calculo.igv))
        Total:      \(soles(calculo.total))
        """
    }

    // ⑥ Registrar venta
    @objc private func registrar() {
        view.endEditing(true)
        guard let vendedor = Sesion.shared.usuario, let c = cliente, let p = producto, cantidad > 0 else {
            mostrarAlerta("Faltan datos", "Elige cliente, producto y una cantidad mayor a 0.")
            return
        }
        // Regla de stock: si no alcanza, alerta y NO se registra
        guard Int64(cantidad) <= p.stock else {
            mostrarAlerta("Stock insuficiente",
                          "Pediste \(cantidad) y solo hay \(p.stock). La venta no se registró.")
            return
        }

        let calculo = Reglas.calcular(precio: p.precio, cantidad: cantidad, categoria: Reglas.categoria(c))
        let ctx = contexto()
        let venta = Venta(context: ctx)
        venta.fecha = Date()
        venta.cantidad = Int64(cantidad)
        venta.precioUnitario = p.precio
        venta.descuento = calculo.descuento
        venta.igv = calculo.igv
        venta.total = calculo.total
        venta.anulada = false
        venta.vendedor = vendedor   // relación venta ▸ vendedor
        venta.cliente = c           // relación venta ▸ cliente
        venta.producto = p          // relación venta ▸ producto
        p.stock -= Int64(cantidad)  // baja el stock

        do {
            try ctx.save()
            mostrarAlerta("Venta registrada",
                          "Total \(soles(calculo.total)). Stock de \(p.nombre ?? ""): \(p.stock).")
            txtCantidad.text = "1"
            stepper.value = 1
            armarMenus()
            actualizar()
        } catch {
            ctx.rollback()
            mostrarAlerta("Error", "No se pudo registrar: \(error.localizedDescription)")
        }
    }
}
