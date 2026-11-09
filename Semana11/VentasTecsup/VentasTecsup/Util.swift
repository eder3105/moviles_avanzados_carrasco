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

func textoFecha(_ fecha: Date?) -> String {
    guard let fecha = fecha else { return "" }
    return formatoFecha.string(from: fecha)
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

// Configura una fila de venta. Si está anulada: texto tachado y etiqueta ANULADA.
func configurarCeldaVenta(_ celda: UITableViewCell, _ venta: Venta, mostrarVendedor: Bool) {
    var detalle = "\(textoFecha(venta.fecha)) · \(soles(venta.total))"
    if mostrarVendedor {
        detalle = "Vendedor: \(venta.vendedor?.nombre ?? "—") · " + detalle
    }
    if venta.anulada {
        celda.textLabel?.attributedText = NSAttributedString(
            string: venta.descripcion,
            attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue,
                         .foregroundColor: UIColor.secondaryLabel])
        detalle += "\nMotivo: \(venta.motivoAnulacion ?? "")"
        let etiqueta = UILabel()
        etiqueta.text = "ANULADA"
        etiqueta.font = .boldSystemFont(ofSize: 12)
        etiqueta.textColor = .systemRed
        etiqueta.sizeToFit()
        celda.accessoryView = etiqueta
    } else {
        celda.textLabel?.attributedText = nil
        celda.textLabel?.text = venta.descripcion
        celda.textLabel?.textColor = .label
        celda.accessoryView = nil
    }
    celda.detailTextLabel?.text = detalle
    celda.detailTextLabel?.numberOfLines = 0
    celda.selectionStyle = .none
}

// MARK: - Ayudas de interfaz
func crearCampo(_ placeholder: String, seguro: Bool = false) -> UITextField {
    let campo = UITextField()
    campo.placeholder = placeholder
    campo.borderStyle = .roundedRect
    campo.autocapitalizationType = .none
    campo.autocorrectionType = .no
    campo.isSecureTextEntry = seguro
    campo.heightAnchor.constraint(equalToConstant: 44).isActive = true
    return campo
}

func crearTitulo(_ texto: String) -> UILabel {
    let etiqueta = UILabel()
    etiqueta.text = texto
    etiqueta.font = .boldSystemFont(ofSize: 15)
    etiqueta.textColor = .secondaryLabel
    return etiqueta
}

// Color del stock: verde > 10, ámbar 6 a 10, rojo 5 o menos
func colorStock(_ stock: Int64) -> UIColor {
    if stock > 10 { return .systemGreen }
    if stock >= 6 { return .systemOrange }
    return .systemRed
}

// Círculo con las iniciales del cliente
func imagenIniciales(_ nombre: String) -> UIImage {
    let iniciales = nombre.split(separator: " ").prefix(2)
        .compactMap { $0.first }.map { String($0) }.joined().uppercased()
    let tam = CGSize(width: 40, height: 40)
    return UIGraphicsImageRenderer(size: tam).image { _ in
        UIColor.systemBlue.setFill()
        UIBezierPath(ovalIn: CGRect(origin: .zero, size: tam)).fill()
        let atributos: [NSAttributedString.Key: Any] = [.font: UIFont.boldSystemFont(ofSize: 15),
                                                         .foregroundColor: UIColor.white]
        let texto = iniciales as NSString
        let medida = texto.size(withAttributes: atributos)
        texto.draw(at: CGPoint(x: (tam.width - medida.width) / 2, y: (tam.height - medida.height) / 2),
                   withAttributes: atributos)
    }
}

// Cabecera (o pie) para una tabla con controles apilados
func crearCabecera(_ vistas: [UIView]) -> UIView {
    let pila = UIStackView(arrangedSubviews: vistas)
    pila.axis = .vertical
    pila.spacing = 8
    pila.translatesAutoresizingMaskIntoConstraints = false
    let alto = CGFloat(vistas.count) * 44 + 16
    let contenedor = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: alto))
    contenedor.addSubview(pila)
    NSLayoutConstraint.activate([
        pila.leadingAnchor.constraint(equalTo: contenedor.leadingAnchor, constant: 16),
        pila.trailingAnchor.constraint(equalTo: contenedor.trailingAnchor, constant: -16),
        pila.topAnchor.constraint(equalTo: contenedor.topAnchor, constant: 8)
    ])
    return contenedor
}

extension UIViewController {
    func mostrarAlerta(_ titulo: String, _ mensaje: String) {
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "OK", style: .default))
        present(alerta, animated: true)
    }

    // Coloca las vistas una debajo de otra y oculta el teclado al tocar fuera
    @discardableResult
    func montarPila(_ vistas: [UIView]) -> UIStackView {
        let pila = UIStackView(arrangedSubviews: vistas)
        pila.axis = .vertical
        pila.spacing = 14
        pila.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pila)
        NSLayoutConstraint.activate([
            pila.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            pila.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            pila.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24)
        ])
        let toque = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))
        toque.cancelsTouchesInView = false
        view.addGestureRecognizer(toque)
        return pila
    }
}
