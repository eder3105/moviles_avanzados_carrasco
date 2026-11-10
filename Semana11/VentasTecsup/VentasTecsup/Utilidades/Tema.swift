import UIKit

// Colores de la app (en un solo lugar para que todo se vea igual)
enum Tema {
    // Fondo verde menta muy suave (en modo oscuro usa el gris oscuro del sistema)
    static let fondo = UIColor { rasgos in
        rasgos.userInterfaceStyle == .dark
            ? UIColor.systemGroupedBackground.resolvedColor(with: rasgos)
            : UIColor(red: 0.94, green: 0.98, blue: 0.96, alpha: 1)
    }
    static let tarjeta = UIColor.secondarySystemGroupedBackground // blanco de las tarjetas

    // Color de la marca: verde esmeralda (#059669)
    static let principal = UIColor(red: 0.02, green: 0.59, blue: 0.41, alpha: 1)
    // Degradado de la barra y del login: verde azulado (#0F766E) -> esmeralda (#10B981)
    static let degradado = [UIColor(red: 0.06, green: 0.46, blue: 0.43, alpha: 1),
                            UIColor(red: 0.06, green: 0.73, blue: 0.51, alpha: 1)]
    // Colores para resaltar
    static let menta = UIColor.systemMint                                      // descuento
    static let ambar = UIColor(red: 0.96, green: 0.62, blue: 0.04, alpha: 1)   // IGV (#F59E0B)

    // Apariencia general de la tienda: barra superior con degradado, títulos blancos
    // y fondo lila en todas las listas. Se llama una sola vez al abrir la app (en el login).
    static func aplicarApariencia() {
        let barra = UINavigationBarAppearance()
        barra.configureWithOpaqueBackground()
        barra.backgroundImage = imagenDegradado()
        barra.shadowColor = .clear
        barra.titleTextAttributes = [.foregroundColor: UIColor.white,
                                     .font: UIFont.systemFont(ofSize: 17, weight: .bold)]
        barra.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

        let navegacion = UINavigationBar.appearance()
        navegacion.standardAppearance = barra
        navegacion.scrollEdgeAppearance = barra
        navegacion.compactAppearance = barra
        navegacion.tintColor = .white   // botones + , Cerrar y volver en blanco
        navegacion.barStyle = .black    // hora y batería en blanco

        // Buscador blanco sobre la barra de color
        UISearchTextField.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).backgroundColor =
            UIColor.white.withAlphaComponent(0.9)

        UITabBar.appearance().tintColor = principal
        UITableView.appearance().backgroundColor = fondo
    }
}

// Imagen con el degradado índigo -> azul (para la barra superior)
func imagenDegradado() -> UIImage {
    let tam = CGSize(width: 400, height: 100)
    return UIGraphicsImageRenderer(size: tam).image { contexto in
        let colores = Tema.degradado.map { $0.cgColor } as CFArray
        guard let degradado = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: colores,
                                         locations: [0, 1]) else { return }
        contexto.cgContext.drawLinearGradient(degradado, start: .zero, end: CGPoint(x: tam.width, y: 0),
                                              options: [])
    }
}

// Versión oscura de un color, para escribir encima de su fondo suave
// (verde oscuro sobre verde claro, ámbar oscuro sobre ámbar claro...)
func tonoOscuro(_ color: UIColor) -> UIColor {
    return UIColor { rasgos in
        let base = color.resolvedColor(with: rasgos)
        if rasgos.userInterfaceStyle == .dark { return base } // en modo oscuro se usa el color tal cual
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        guard base.getHue(&h, saturation: &s, brightness: &b, alpha: &a) else { return base }
        return UIColor(hue: h, saturation: min(s * 1.1, 1), brightness: b * 0.5, alpha: a)
    }
}

// Color de cada categoría de cliente
extension CategoriaCliente {
    var color: UIColor {
        switch self {
        case .vip: return Tema.ambar          // dorado: cliente premium
        case .frecuente: return .systemBlue   // azul: cliente fiel
        case .regular: return .systemGray     // gris: cliente normal
        }
    }
}

// Etiqueta tipo "píldora": texto de color sobre fondo suave (VIP, Stock 40, Anulada)
class Etiqueta: UILabel {
    private let relleno = UIEdgeInsets(top: 3, left: 8, bottom: 3, right: 8)

    // solida: true = fondo de color fuerte con letra blanca (para lo más importante)
    //         false = fondo suave con letra oscura del mismo color
    init(_ texto: String, color: UIColor, solida: Bool = false) {
        super.init(frame: .zero)
        text = texto
        font = .systemFont(ofSize: 12, weight: solida ? .bold : .semibold)
        textColor = solida ? .white : tonoOscuro(color)
        backgroundColor = solida ? color : color.withAlphaComponent(0.25)
        // La etiqueta mide solo lo que ocupa su texto (no se estira)
        setContentHuggingPriority(.required, for: .horizontal)
        setContentCompressionResistancePriority(.required, for: .horizontal)
        textAlignment = .center
        layer.cornerRadius = 10
        clipsToBounds = true
        sizeToFit()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) no se usa")
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: relleno))
    }

    override var intrinsicContentSize: CGSize {
        let tam = super.intrinsicContentSize
        return CGSize(width: tam.width + relleno.left + relleno.right,
                      height: tam.height + relleno.top + relleno.bottom)
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let tam = super.sizeThatFits(size)
        return CGSize(width: tam.width + relleno.left + relleno.right,
                      height: tam.height + relleno.top + relleno.bottom)
    }
}

// Tarjeta de indicador: título pequeño, monto grande y detalle
class IndicadorView: UIView {
    private let lblValor = UILabel()
    private let lblDetalle = UILabel()

    // color: tono de la tarjeta (fondo suave + título y monto de ese color)
    init(titulo: String, color: UIColor = Tema.principal) {
        super.init(frame: .zero)
        backgroundColor = color.withAlphaComponent(0.22)
        layer.cornerRadius = 14

        let lblTitulo = UILabel()
        lblTitulo.text = titulo
        lblTitulo.font = .systemFont(ofSize: 13, weight: .semibold)
        lblTitulo.textColor = tonoOscuro(color)

        lblValor.font = .systemFont(ofSize: 22, weight: .bold)
        lblValor.textColor = .label
        lblValor.adjustsFontSizeToFitWidth = true
        lblValor.minimumScaleFactor = 0.6
        lblValor.text = soles(0)

        lblDetalle.font = .systemFont(ofSize: 12)
        lblDetalle.textColor = .secondaryLabel
        lblDetalle.numberOfLines = 0

        let pila = UIStackView(arrangedSubviews: [lblTitulo, lblValor, lblDetalle])
        pila.axis = .vertical
        pila.spacing = 4
        pila.translatesAutoresizingMaskIntoConstraints = false
        addSubview(pila)
        NSLayoutConstraint.activate([
            pila.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            pila.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14),
            pila.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -14),
            pila.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) no se usa")
    }

    func mostrar(valor: String, detalle: String, colorDetalle: UIColor = .secondaryLabel) {
        lblValor.text = valor
        lblDetalle.text = detalle
        lblDetalle.textColor = colorDetalle
    }
}

// Fila de dos indicadores lado a lado
func filaIndicadores(_ a: IndicadorView, _ b: IndicadorView) -> UIStackView {
    let fila = UIStackView(arrangedSubviews: [a, b])
    fila.axis = .horizontal
    fila.spacing = 12
    fila.distribution = .fillEqually
    return fila
}

// Tarjeta blanca redondeada con un título opcional
// color: si se indica, la tarjeta toma un fondo suave de ese color (para tarjetas importantes)
func crearTarjeta(titulo: String?, contenido: UIView, color: UIColor? = nil) -> UIView {
    let pila = UIStackView(arrangedSubviews: [contenido])
    pila.axis = .vertical
    pila.spacing = 10
    if let titulo = titulo {
        let lbl = UILabel()
        lbl.text = titulo
        lbl.font = .systemFont(ofSize: 17, weight: .semibold)
        if let color = color { lbl.textColor = tonoOscuro(color) }
        pila.insertArrangedSubview(lbl, at: 0)
    }
    pila.translatesAutoresizingMaskIntoConstraints = false

    let tarjeta = UIView()
    tarjeta.backgroundColor = color?.withAlphaComponent(0.15) ?? Tema.tarjeta
    tarjeta.layer.cornerRadius = 16
    tarjeta.addSubview(pila)
    NSLayoutConstraint.activate([
        pila.topAnchor.constraint(equalTo: tarjeta.topAnchor, constant: 16),
        pila.leadingAnchor.constraint(equalTo: tarjeta.leadingAnchor, constant: 16),
        pila.trailingAnchor.constraint(equalTo: tarjeta.trailingAnchor, constant: -16),
        pila.bottomAnchor.constraint(equalTo: tarjeta.bottomAnchor, constant: -16)
    ])
    return tarjeta
}

// Fila "texto ........ monto" (boleta, resumen, ranking)
func filaDoble(_ izquierda: String, _ derecha: String, negrita: Bool = false,
               color: UIColor = .label, tam: CGFloat = 15) -> UIStackView {
    let lblIzq = UILabel()
    lblIzq.text = izquierda
    lblIzq.numberOfLines = 0
    lblIzq.font = negrita ? .systemFont(ofSize: tam, weight: .bold) : .systemFont(ofSize: tam)
    lblIzq.textColor = negrita ? .label : .secondaryLabel

    let lblDer = UILabel()
    lblDer.text = derecha
    lblDer.textAlignment = .right
    lblDer.font = negrita ? .systemFont(ofSize: tam, weight: .bold)
                          : .monospacedDigitSystemFont(ofSize: tam, weight: .regular)
    lblDer.textColor = color
    lblDer.setContentCompressionResistancePriority(.required, for: .horizontal)
    lblDer.setContentHuggingPriority(.required, for: .horizontal)

    let fila = UIStackView(arrangedSubviews: [lblIzq, lblDer])
    fila.axis = .horizontal
    fila.spacing = 12
    fila.alignment = .firstBaseline
    return fila
}

// Línea delgada separadora
func separador() -> UIView {
    let linea = UIView()
    linea.backgroundColor = .separator
    linea.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
    return linea
}

// Fila de venta: ícono ✓ / ✕, cliente, fecha y producto, monto a la derecha.
// Si está anulada: ícono rojo, monto tachado y etiqueta "Anulada".
func configurarCeldaVenta(_ celda: UITableViewCell, _ venta: Venta, mostrarVendedor: Bool) {
    // Colores con significado:
    //   venta válida  -> fila verde suave y monto en verde sólido
    //   venta anulada -> fila ROJA completa con letra blanca (igual que "Cerrar sesión")
    let anulada = venta.anulada
    let rojoOscuro = UIColor(red: 0.55, green: 0.05, blue: 0.05, alpha: 1)

    var c = celda.defaultContentConfiguration()
    c.image = UIImage(systemName: anulada ? "xmark.circle.fill" : "checkmark.circle.fill")
    c.imageProperties.tintColor = anulada ? .white : Tema.principal
    c.text = venta.cliente?.nombre ?? "—"
    c.textProperties.font = .systemFont(ofSize: 16, weight: .semibold)
    c.textProperties.color = anulada ? .white : .label

    var detalle = "\(textoFechaCorta(venta.fecha)) · \(venta.producto?.nombre ?? "—") × \(venta.cantidad)"
    if mostrarVendedor {
        detalle += "\nVendedor: \(venta.vendedor?.nombre ?? "—")"
    }
    if anulada {
        detalle += "\nMotivo: \(venta.motivoAnulacion ?? "")"
    }
    c.secondaryText = detalle
    c.secondaryTextProperties.color = anulada ? UIColor.white.withAlphaComponent(0.9) : .secondaryLabel
    c.secondaryTextProperties.numberOfLines = 0
    celda.contentConfiguration = c

    // Fondo de toda la fila
    var fondo = celda.defaultBackgroundConfiguration()
    fondo.backgroundColor = anulada ? .systemRed : UIColor.systemGreen.withAlphaComponent(0.12)
    celda.backgroundConfiguration = fondo

    if anulada {
        // Monto tachado en blanco y etiqueta ANULADA en rojo oscuro
        let monto = UILabel()
        monto.attributedText = NSAttributedString(string: soles(venta.total), attributes: [
            .strikethroughStyle: NSUnderlineStyle.single.rawValue,
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 15, weight: .semibold)
        ])
        celda.accessoryView = columnaEtiquetas([monto, Etiqueta("ANULADA", color: rojoOscuro, solida: true)])
    } else {
        // Monto válido en verde sólido
        celda.accessoryView = Etiqueta(soles(venta.total), color: Tema.principal, solida: true)
    }
}

// MARK: - Decoración

// Fondo con degradado índigo -> azul (login y tarjeta principal del resumen)
class FondoDegradado: UIView {
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }

    init(radio: CGFloat = 0) {
        super.init(frame: .zero)
        let capa = layer as! CAGradientLayer
        capa.colors = Tema.degradado.map { $0.cgColor }
        capa.startPoint = CGPoint(x: 0, y: 0)
        capa.endPoint = CGPoint(x: 1, y: 1)
        layer.cornerRadius = radio
        layer.masksToBounds = radio > 0
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) no se usa")
    }
}

// Ícono según el nombre del producto (solo decoración)
func iconoProducto(_ producto: Producto) -> String {
    let nombre = (producto.nombre ?? "").lowercased()
    if nombre.contains("laptop") { return "laptopcomputer" }
    if nombre.contains("mouse") { return "computermouse.fill" }
    if nombre.contains("teclado") { return "keyboard.fill" }
    if nombre.contains("monitor") { return "display" }
    return "shippingbox.fill"
}

// Color según la categoría del producto (solo decoración)
func colorCategoria(_ categoria: String?) -> UIColor {
    switch (categoria ?? "").lowercased() {
    case "computo": return Tema.principal
    case "accesorios": return UIColor(red: 0.06, green: 0.46, blue: 0.43, alpha: 1) // verde azulado
    default: return Tema.principal
    }
}

// Cuadrado redondeado de color con un ícono blanco al centro
func imagenIcono(_ simbolo: String, color: UIColor) -> UIImage {
    let tam = CGSize(width: 42, height: 42)
    let configuracion = UIImage.SymbolConfiguration(pointSize: 18, weight: .semibold)
    let icono = UIImage(systemName: simbolo, withConfiguration: configuracion)?
        .withTintColor(.white, renderingMode: .alwaysOriginal)
    return UIGraphicsImageRenderer(size: tam).image { _ in
        color.setFill()
        UIBezierPath(roundedRect: CGRect(origin: .zero, size: tam), cornerRadius: 11).fill()
        if let icono = icono {
            let origen = CGPoint(x: (tam.width - icono.size.width) / 2, y: (tam.height - icono.size.height) / 2)
            icono.draw(at: origen)
        }
    }
}

// Papel de ticket: blanco con bordes dentados arriba y abajo
class PapelTicket: UIView {
    private let mascara = CAShapeLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        layer.mask = mascara
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) no se usa")
    }

    // Dibuja el contorno con "dientes" cada vez que cambia el tamaño
    override func layoutSubviews() {
        super.layoutSubviews()
        let ancho = bounds.width
        let alto = bounds.height
        let diente: CGFloat = 8
        let ruta = UIBezierPath()

        // Borde de arriba (zigzag de izquierda a derecha)
        ruta.move(to: CGPoint(x: 0, y: diente))
        var x: CGFloat = 0
        var subir = true
        while x < ancho {
            x = min(x + diente, ancho)
            ruta.addLine(to: CGPoint(x: x, y: subir ? 0 : diente))
            subir.toggle()
        }
        // Lado derecho
        ruta.addLine(to: CGPoint(x: ancho, y: alto - diente))
        // Borde de abajo (zigzag de derecha a izquierda)
        subir = false
        while x > 0 {
            x = max(x - diente, 0)
            ruta.addLine(to: CGPoint(x: x, y: subir ? alto - diente : alto))
            subir.toggle()
        }
        ruta.close()
        mascara.path = ruta.cgPath
    }
}

// Varias etiquetas una debajo de otra, alineadas a la derecha (para accessoryView de una celda)
func columnaEtiquetas(_ etiquetas: [UIView]) -> UIStackView {
    let pila = UIStackView(arrangedSubviews: etiquetas)
    pila.axis = .vertical
    pila.alignment = .trailing
    pila.spacing = 6
    pila.frame.size = pila.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    return pila
}

// Línea punteada (como las de un ticket impreso)
class LineaPunteada: UIView {
    private let linea = CAShapeLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        linea.strokeColor = UIColor.systemGray3.cgColor
        linea.lineWidth = 1
        linea.lineDashPattern = [4, 3]
        layer.addSublayer(linea)
        heightAnchor.constraint(equalToConstant: 1).isActive = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) no se usa")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let ruta = UIBezierPath()
        ruta.move(to: CGPoint(x: 0, y: 0.5))
        ruta.addLine(to: CGPoint(x: bounds.width, y: 0.5))
        linea.path = ruta.cgPath
    }
}
