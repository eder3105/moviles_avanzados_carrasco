import UIKit
import CoreData

// A5 · Nueva venta (solo vendedor)
// ① Vendedor de la sesión (automático) · ② Cliente · ③ Producto
// ④ Cantidad con stepper y stock disponible · ⑤ Resumen calculado · ⑥ Registrar venta
class NuevaVentaViewController: UITableViewController {

    private var cliente: Cliente?
    private var producto: Producto?
    private var cantidad = 1
    private let stepper = UIStepper()

    init() {
        super.init(style: .insetGrouped)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) no se usa")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        stepper.minimumValue = 1
        stepper.maximumValue = 999
        stepper.value = 1
        stepper.addTarget(self, action: #selector(cambioStepper), for: .valueChanged)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData() // el stock pudo cambiar en otra pestaña
    }

    @objc private func cambioStepper() {
        cantidad = Int(stepper.value)
        tableView.reloadData()
    }

    // ⑤ Cálculo con las reglas de negocio (nil si falta cliente o producto)
    private var calculo: CalculoVenta? {
        guard let c = cliente, let p = producto, cantidad > 0 else { return nil }
        return Reglas.calcular(precio: p.precio, cantidad: cantidad, categoria: Reglas.categoria(c))
    }

    // MARK: - Secciones: 0 vendedor · 1 datos · 2 resumen · 3 botón
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 1: return 3
        case 2: return calculo == nil ? 1 : 4
        default: return 1
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1: return "Datos de la venta"
        case 2: return "Resumen (calculado)"
        default: return nil
        }
    }

    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return section == 1 ? "Toca «Cantidad» para escribirla o usa − / +." : nil
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0: return celdaVendedor()
        case 1: return celdaDato(indexPath.row)
        case 2: return celdaResumen(indexPath.row)
        default: return celdaBoton()
        }
    }

    // ① Vendedor de la sesión, en una tarjeta azul suave (no editable)
    private func celdaVendedor() -> UITableViewCell {
        let celda = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        let nombre = Sesion.shared.usuario?.nombre ?? ""
        var c = celda.defaultContentConfiguration()
        c.image = imagenIniciales(nombre)
        c.imageProperties.maximumSize = CGSize(width: 40, height: 40)
        c.text = "\(nombre) · Vendedor"
        c.textProperties.font = .systemFont(ofSize: 16, weight: .semibold)
        c.textProperties.color = Tema.principal
        c.secondaryText = "Sesión iniciada · la venta se registra a tu nombre"
        c.secondaryTextProperties.color = Tema.principal
        celda.contentConfiguration = c

        var fondo = celda.defaultBackgroundConfiguration()
        fondo.backgroundColor = Tema.principal.withAlphaComponent(0.18)
        celda.backgroundConfiguration = fondo
        celda.selectionStyle = .none
        return celda
    }

    // ② Cliente · ③ Producto · ④ Cantidad
    private func celdaDato(_ fila: Int) -> UITableViewCell {
        let celda = UITableViewCell(style: .value1, reuseIdentifier: nil)
        var c = celda.defaultContentConfiguration()
        switch fila {
        case 0:
            c.text = "Cliente"
            if let cl = cliente {
                c.secondaryText = "\(cl.nombre ?? "") (\(Reglas.categoria(cl).rawValue))"
            } else {
                c.secondaryText = "Elegir"
            }
            celda.accessoryType = .disclosureIndicator
        case 1:
            c.text = "Producto"
            if let p = producto {
                c.secondaryText = "\(p.nombre ?? "") · \(soles(p.precio))"
            } else {
                c.secondaryText = "Elegir"
            }
            celda.accessoryType = .disclosureIndicator
        default:
            c.text = "Cantidad: \(cantidad)"
            c.textProperties.font = .systemFont(ofSize: 17, weight: .semibold)
            c.secondaryText = producto.map { "stock \($0.stock)" } ?? "stock —"
            stepper.value = Double(min(max(cantidad, 1), 999))
            celda.accessoryView = stepper
        }
        celda.contentConfiguration = c
        return celda
    }

    // ⑤ Resumen: subtotal, descuento, IGV y total
    private func celdaResumen(_ fila: Int) -> UITableViewCell {
        guard let calc = calculo, let cl = cliente else {
            let celda = UITableViewCell()
            var c = celda.defaultContentConfiguration()
            c.text = "Elige cliente, producto y cantidad."
            c.textProperties.color = .secondaryLabel
            celda.contentConfiguration = c
            celda.selectionStyle = .none
            return celda
        }
        let categoria = Reglas.categoria(cl)
        let celda = UITableViewCell(style: .value1, reuseIdentifier: nil)
        var c = celda.defaultContentConfiguration()
        switch fila {
        case 0:
            c.text = "Subtotal"
            c.secondaryText = soles(calc.subtotal)
        case 1:
            c.text = categoria == .vip ? "Descuento VIP 10 %" : "Descuento (\(categoria.rawValue))"
            c.secondaryText = calc.descuento > 0 ? "− " + soles(calc.descuento) : soles(0)
            resaltar(celda, &c, Tema.menta)
        case 2:
            c.text = "IGV 18 %"
            c.secondaryText = soles(calc.igv)
            resaltar(celda, &c, Tema.ambar)
        default:
            c.text = "Total"
            c.secondaryText = soles(calc.total)
            c.textProperties.font = .systemFont(ofSize: 18, weight: .bold)
            c.secondaryTextProperties.font = .systemFont(ofSize: 18, weight: .bold)
            resaltar(celda, &c, Tema.principal, solida: true)
        }
        celda.contentConfiguration = c
        celda.selectionStyle = .none
        return celda
    }

    // Fondo de color suave para destacar una fila del resumen (solo decoración)
    // (fondo de ese color y letra en su tono oscuro)
    // solida: fondo de color fuerte con letra blanca (para el Total)
    private func resaltar(_ celda: UITableViewCell, _ c: inout UIListContentConfiguration, _ color: UIColor,
                          solida: Bool = false) {
        var fondo = celda.defaultBackgroundConfiguration()
        fondo.backgroundColor = solida ? color : color.withAlphaComponent(0.25)
        celda.backgroundConfiguration = fondo
        c.textProperties.color = solida ? .white : tonoOscuro(color)
        c.secondaryTextProperties.color = solida ? .white : tonoOscuro(color)
    }

    // ⑥ Botón azul "Registrar venta"
    private func celdaBoton() -> UITableViewCell {
        let celda = UITableViewCell()
        var c = celda.defaultContentConfiguration()
        c.text = "Registrar venta"
        c.textProperties.alignment = .center
        c.textProperties.font = .systemFont(ofSize: 17, weight: .bold)
        c.textProperties.color = .white
        celda.contentConfiguration = c

        var fondo = celda.defaultBackgroundConfiguration()
        fondo.backgroundColor = Tema.principal
        celda.backgroundConfiguration = fondo
        return celda
    }

    // MARK: - Acciones
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 1 {
            switch indexPath.row {
            case 0: elegirCliente(desde: indexPath)
            case 1: elegirProducto(desde: indexPath)
            default: escribirCantidad()
            }
        } else if indexPath.section == 3 {
            registrar()
        }
    }

    private func elegirCliente(desde indexPath: IndexPath) {
        let req: NSFetchRequest<Cliente> = Cliente.fetchRequest()
        req.sortDescriptors = [NSSortDescriptor(key: "nombre", ascending: true)]
        let clientes = (try? contexto().fetch(req)) ?? []

        let menu = UIAlertController(title: "Elige un cliente", message: nil, preferredStyle: .actionSheet)
        for cl in clientes {
            menu.addAction(UIAlertAction(title: "\(cl.nombre ?? "") (\(Reglas.categoria(cl).rawValue))",
                                         style: .default) { _ in
                self.cliente = cl
                self.tableView.reloadData()
            })
        }
        menu.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        menu.popoverPresentationController?.sourceView = tableView.cellForRow(at: indexPath)
        present(menu, animated: true)
    }

    private func elegirProducto(desde indexPath: IndexPath) {
        let req: NSFetchRequest<Producto> = Producto.fetchRequest()
        req.sortDescriptors = [NSSortDescriptor(key: "nombre", ascending: true)]
        let productos = (try? contexto().fetch(req)) ?? []

        let menu = UIAlertController(title: "Elige un producto", message: nil, preferredStyle: .actionSheet)
        for p in productos {
            menu.addAction(UIAlertAction(title: "\(p.nombre ?? "") · \(soles(p.precio)) · stock \(p.stock)",
                                         style: .default) { _ in
                self.producto = p
                self.tableView.reloadData()
            })
        }
        menu.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        menu.popoverPresentationController?.sourceView = tableView.cellForRow(at: indexPath)
        present(menu, animated: true)
    }

    // Permite escribir la cantidad (por ejemplo 50, para probar el caso 6)
    private func escribirCantidad() {
        let alerta = UIAlertController(title: "Cantidad", message: nil, preferredStyle: .alert)
        alerta.addTextField { campo in
            campo.keyboardType = .numberPad
            campo.text = String(self.cantidad)
        }
        alerta.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        alerta.addAction(UIAlertAction(title: "Aceptar", style: .default) { _ in
            guard let n = Int(alerta.textFields?.first?.text ?? ""), n > 0 else {
                self.mostrarAlerta("Cantidad inválida", "Escribe un número mayor a 0.")
                return
            }
            self.cantidad = n
            self.tableView.reloadData()
        })
        present(alerta, animated: true)
    }

    // ⑥ Registrar venta
    private func registrar() {
        guard let vendedor = Sesion.shared.usuario, let cl = cliente, let p = producto, cantidad > 0 else {
            mostrarAlerta("Faltan datos", "Elige cliente, producto y una cantidad mayor a 0.")
            return
        }
        // Regla de stock: si no alcanza, alerta y NO se registra
        guard Int64(cantidad) <= p.stock else {
            mostrarAlerta("Stock insuficiente",
                          "Pediste \(cantidad) y solo hay \(p.stock). La venta no se registró.")
            return
        }

        let calc = Reglas.calcular(precio: p.precio, cantidad: cantidad, categoria: Reglas.categoria(cl))
        let ctx = contexto()
        let venta = Venta(context: ctx)
        venta.fecha = Date()
        venta.cantidad = Int64(cantidad)
        venta.precioUnitario = p.precio
        venta.descuento = calc.descuento
        venta.igv = calc.igv
        venta.total = calc.total
        venta.anulada = false
        venta.vendedor = vendedor   // relación venta ▸ vendedor
        venta.cliente = cl          // relación venta ▸ cliente
        venta.producto = p          // relación venta ▸ producto
        p.stock -= Int64(cantidad)  // baja el stock

        do {
            try ctx.save()
            // Limpia el formulario y muestra el comprobante
            cliente = nil
            producto = nil
            cantidad = 1
            tableView.reloadData()
            present(UINavigationController(rootViewController: BoletaViewController(venta: venta)), animated: true)
        } catch {
            ctx.rollback()
            mostrarAlerta("Error", "No se pudo registrar: \(error.localizedDescription)")
        }
    }
}
