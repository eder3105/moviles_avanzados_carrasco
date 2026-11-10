import UIKit
import CoreData

// MARK: - Core Data
// Devuelve el contexto de Core Data (igual que en el laboratorio de Contactos)
func contexto() -> NSManagedObjectContext {
    let delegate = UIApplication.shared.delegate as! AppDelegate
    return delegate.persistentContainer.viewContext
}

// MARK: - Dinero y redondeo
private let formatoSoles: NumberFormatter = {
    let f = NumberFormatter()
    f.numberStyle = .decimal
    f.minimumFractionDigits = 2
    f.maximumFractionDigits = 2
    f.locale = Locale(identifier: "en_US") // 1,234.50
    return f
}()

// Muestra un monto como "S/ 1,234.50"
func soles(_ valor: Double) -> String {
    return "S/ " + (formatoSoles.string(from: NSNumber(value: valor)) ?? "0.00")
}

// Redondea a 2 decimales (céntimos)
func redondear(_ valor: Double) -> Double {
    return (valor * 100).rounded() / 100
}

// MARK: - Fechas
private let formatoFecha: DateFormatter = {
    let f = DateFormatter()
    f.dateFormat = "dd/MM/yyyy HH:mm"
    return f
}()

private let formatoFechaCorta: DateFormatter = {
    let f = DateFormatter()
    f.dateFormat = "dd/MM HH:mm"
    return f
}()

func textoFecha(_ fecha: Date?) -> String {
    guard let fecha = fecha else { return "" }
    return formatoFecha.string(from: fecha)
}

func textoFechaCorta(_ fecha: Date?) -> String {
    guard let fecha = fecha else { return "" }
    return formatoFechaCorta.string(from: fecha)
}

func inicioDeHoy() -> Date {
    return Calendar.current.startOfDay(for: Date())
}

func inicioDelMes() -> Date {
    let cal = Calendar.current
    return cal.date(from: cal.dateComponents([.year, .month], from: Date()))!
}

// Segmento Todas / Hoy / Mes -> fecha desde la que se filtra (nil = todas)
func fechaDesde(segmento: Int) -> Date? {
    switch segmento {
    case 1: return inicioDeHoy()
    case 2: return inicioDelMes()
    default: return nil
    }
}

// MARK: - Ventas
extension Venta {
    // Texto corto: "Cliente · Producto x2"
    var descripcion: String {
        return "\(cliente?.nombre ?? "—") · \(producto?.nombre ?? "—") x\(cantidad)"
    }

    // Subtotal = precio unitario x cantidad
    var subtotal: Double {
        return redondear(precioUnitario * Double(cantidad))
    }

    // Número del comprobante, a partir del id interno de Core Data (ej. V-000012)
    var numero: String {
        let digitos = objectID.uriRepresentation().lastPathComponent.filter { $0.isNumber }
        return String(format: "V-%06d", Int(digitos) ?? 0)
    }
}

// Suma el total de las ventas que NO están anuladas
func totalVentas(_ ventas: [Venta]) -> Double {
    return ventas.filter { !$0.anulada }.reduce(0) { $0 + $1.total }
}

// Fetch request de ventas con NSPredicate:
// - por vendedor (relación venta ▸ vendedor)
// - por fecha (periodo)
// - por nombre del cliente (relación venta ▸ cliente)
func buscarVentas(vendedor: Usuario?, desde: Date?, cliente: String) -> [Venta] {
    let req: NSFetchRequest<Venta> = Venta.fetchRequest()
    var condiciones: [NSPredicate] = []
    if let vendedor = vendedor {
        condiciones.append(NSPredicate(format: "vendedor == %@", vendedor))
    }
    if let desde = desde {
        condiciones.append(NSPredicate(format: "fecha >= %@", desde as NSDate))
    }
    if !cliente.isEmpty {
        condiciones.append(NSPredicate(format: "cliente.nombre CONTAINS[cd] %@", cliente))
    }
    req.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: condiciones)
    req.sortDescriptors = [NSSortDescriptor(key: "fecha", ascending: false)]
    return (try? contexto().fetch(req)) ?? []
}

// MARK: - Ayudas de interfaz
func crearCampo(_ placeholder: String, seguro: Bool = false) -> UITextField {
    let campo = UITextField()
    campo.placeholder = placeholder
    campo.borderStyle = .none
    campo.backgroundColor = Tema.tarjeta
    campo.layer.cornerRadius = 12
    campo.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 14, height: 1))
    campo.leftViewMode = .always
    campo.autocapitalizationType = .none
    campo.autocorrectionType = .no
    campo.isSecureTextEntry = seguro
    campo.heightAnchor.constraint(equalToConstant: 50).isActive = true
    return campo
}

func crearTitulo(_ texto: String) -> UILabel {
    let etiqueta = UILabel()
    etiqueta.text = texto.uppercased()
    etiqueta.font = .systemFont(ofSize: 13, weight: .semibold)
    etiqueta.textColor = .secondaryLabel
    return etiqueta
}

// Botón azul grande y redondeado
func crearBotonPrincipal(_ titulo: String) -> UIButton {
    var configuracion = UIButton.Configuration.filled()
    configuracion.title = titulo
    configuracion.cornerStyle = .large
    configuracion.buttonSize = .large
    configuracion.baseBackgroundColor = Tema.principal
    return UIButton(configuration: configuracion)
}

// Color del stock: verde > 10, ámbar 6 a 10, rojo 5 o menos
func colorStock(_ stock: Int64) -> UIColor {
    if stock > 10 { return .systemGreen }
    if stock >= 6 { return .systemOrange }
    return .systemRed
}

// Círculo de color con las iniciales (cliente o vendedor)
func imagenIniciales(_ nombre: String, color: UIColor = Tema.principal) -> UIImage {
    let iniciales = nombre.split(separator: " ").prefix(2)
        .compactMap { $0.first }.map { String($0) }.joined().uppercased()
    let tam = CGSize(width: 40, height: 40)
    return UIGraphicsImageRenderer(size: tam).image { _ in
        color.setFill()
        UIBezierPath(ovalIn: CGRect(origin: .zero, size: tam)).fill()
        let atributos: [NSAttributedString.Key: Any] = [.font: UIFont.boldSystemFont(ofSize: 15),
                                                         .foregroundColor: UIColor.white]
        let texto = iniciales as NSString
        let medida = texto.size(withAttributes: atributos)
        texto.draw(at: CGPoint(x: (tam.width - medida.width) / 2, y: (tam.height - medida.height) / 2),
                   withAttributes: atributos)
    }
}

extension UIViewController {
    func mostrarAlerta(_ titulo: String, _ mensaje: String) {
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "OK", style: .default))
        present(alerta, animated: true)
    }

    // Coloca las vistas una debajo de otra (con scroll) y oculta el teclado al tocar fuera
    @discardableResult
    func montarPila(_ vistas: [UIView]) -> UIStackView {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.keyboardDismissMode = .interactive
        view.addSubview(scroll)

        let pila = UIStackView(arrangedSubviews: vistas)
        pila.axis = .vertical
        pila.spacing = 14
        pila.translatesAutoresizingMaskIntoConstraints = false
        scroll.addSubview(pila)

        NSLayoutConstraint.activate([
            scroll.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scroll.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            pila.topAnchor.constraint(equalTo: scroll.contentLayoutGuide.topAnchor, constant: 24),
            pila.leadingAnchor.constraint(equalTo: scroll.contentLayoutGuide.leadingAnchor, constant: 24),
            pila.trailingAnchor.constraint(equalTo: scroll.contentLayoutGuide.trailingAnchor, constant: -24),
            pila.bottomAnchor.constraint(equalTo: scroll.contentLayoutGuide.bottomAnchor, constant: -24),
            pila.widthAnchor.constraint(equalTo: scroll.frameLayoutGuide.widthAnchor, constant: -48)
        ])

        let toque = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))
        toque.cancelsTouchesInView = false
        view.addGestureRecognizer(toque)
        return pila
    }
}

// Cabecera de tabla con controles apilados (chips, indicadores...)
extension UITableView {
    func ponerCabecera(_ vistas: [UIView]) {
        let pila = UIStackView(arrangedSubviews: vistas)
        pila.axis = .vertical
        pila.spacing = 12
        pila.translatesAutoresizingMaskIntoConstraints = false

        let contenedor = UIView(frame: CGRect(x: 0, y: 0, width: 400, height: 10))
        contenedor.addSubview(pila)
        let abajo = pila.bottomAnchor.constraint(equalTo: contenedor.bottomAnchor, constant: -4)
        abajo.priority = .defaultHigh
        let derecha = pila.trailingAnchor.constraint(equalTo: contenedor.trailingAnchor, constant: -20)
        derecha.priority = .defaultHigh
        NSLayoutConstraint.activate([
            pila.topAnchor.constraint(equalTo: contenedor.topAnchor, constant: 8),
            pila.leadingAnchor.constraint(equalTo: contenedor.leadingAnchor, constant: 20),
            derecha,
            abajo
        ])
        tableHeaderView = contenedor
    }

    // Llamar desde viewDidLayoutSubviews para que la cabecera tome su alto real
    func ajustarCabecera() {
        guard let cabecera = tableHeaderView, bounds.width > 0 else { return }
        let tam = cabecera.systemLayoutSizeFitting(CGSize(width: bounds.width, height: 0),
                                                   withHorizontalFittingPriority: .required,
                                                   verticalFittingPriority: .fittingSizeLevel)
        if abs(cabecera.frame.height - tam.height) > 0.5 || abs(cabecera.frame.width - bounds.width) > 0.5 {
            cabecera.frame = CGRect(x: 0, y: 0, width: bounds.width, height: tam.height)
            tableHeaderView = cabecera
        }
    }
}
