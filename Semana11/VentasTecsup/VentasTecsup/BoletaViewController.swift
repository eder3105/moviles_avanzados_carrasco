import UIKit

// Comprobante de una venta (se abre al registrar una venta o al tocar una venta de la lista).
// Se dibuja como un ticket impreso: papel con bordes dentados, letra de ticketera y líneas punteadas.
class BoletaViewController: UIViewController {

    private let venta: Venta

    init(venta: Venta) {
        self.venta = venta
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) no se usa")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Comprobante"
        view.backgroundColor = Tema.fondo
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cerrar", style: .done, target: self,
                                                            action: #selector(cerrar))

        // Encabezado de la tienda
        let icono = UIImageView(image: UIImage(systemName: "cart.fill"))
        icono.tintColor = Tema.principal
        icono.contentMode = .scaleAspectFit
        icono.heightAnchor.constraint(equalToConstant: 30).isActive = true

        let operacionGravada = redondear(venta.subtotal - venta.descuento)
        var vistas: [UIView] = [
            icono,
            texto("VENTASTECSUP", tam: 18, peso: .bold, color: Tema.principal, centrado: true),
            texto("Tienda de tecnología", tam: 12, color: .darkGray, centrado: true),
            LineaPunteada(),
            texto("COMPROBANTE DE VENTA", tam: 14, peso: .bold, color: Tema.principal, centrado: true),
            texto("N° \(venta.numero)", tam: 13, color: .darkGray, centrado: true),
            LineaPunteada(),
            fila("FECHA", textoFecha(venta.fecha)),
            fila("VENDEDOR", venta.vendedor?.nombre ?? "—"),
            fila("CLIENTE", venta.cliente?.nombre ?? "—"),
            fila("DOC.", venta.cliente?.documento ?? "—"),
            LineaPunteada(),
            fila("CANT  DESCRIPCIÓN", "IMPORTE", peso: .bold),
            fila("\(venta.cantidad) x \(venta.producto?.nombre ?? "—")", soles(venta.subtotal)),
            texto("      P.U. \(soles(venta.precioUnitario))", tam: 12, color: .darkGray),
            LineaPunteada(),
            fila("SUBTOTAL", soles(venta.subtotal)),
            fila("DESCUENTO", venta.descuento > 0 ? "-" + soles(venta.descuento) : soles(0), resaltar: Tema.menta),
            fila("OP. GRAVADA", soles(operacionGravada)),
            fila("IGV 18%", soles(venta.igv), resaltar: Tema.ambar),
            LineaPunteada(),
            fila("TOTAL", soles(venta.total), peso: .heavy, tam: 18, resaltar: Tema.principal, solida: true)
        ]

        if venta.anulada {
            vistas.append(resaltado(texto("Motivo de anulación: \(venta.motivoAnulacion ?? "")", tam: 12,
                                           centrado: true), color: .systemRed))
        }
        vistas += [
            LineaPunteada(),
            texto("¡GRACIAS POR SU COMPRA!", tam: 13, peso: .semibold, color: Tema.principal, centrado: true),
            texto("* * *", tam: 12, color: .darkGray, centrado: true)
        ]

        let pila = UIStackView(arrangedSubviews: vistas)
        pila.axis = .vertical
        pila.spacing = 8
        pila.translatesAutoresizingMaskIntoConstraints = false

        // Papel del ticket
        let papel = PapelTicket()
        papel.translatesAutoresizingMaskIntoConstraints = false
        papel.addSubview(pila)

        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scroll)
        scroll.addSubview(papel)

        NSLayoutConstraint.activate([
            scroll.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scroll.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            papel.topAnchor.constraint(equalTo: scroll.contentLayoutGuide.topAnchor, constant: 24),
            papel.leadingAnchor.constraint(equalTo: scroll.contentLayoutGuide.leadingAnchor, constant: 24),
            papel.trailingAnchor.constraint(equalTo: scroll.contentLayoutGuide.trailingAnchor, constant: -24),
            papel.bottomAnchor.constraint(equalTo: scroll.contentLayoutGuide.bottomAnchor, constant: -24),
            papel.widthAnchor.constraint(equalTo: scroll.frameLayoutGuide.widthAnchor, constant: -48),

            pila.topAnchor.constraint(equalTo: papel.topAnchor, constant: 28),
            pila.leadingAnchor.constraint(equalTo: papel.leadingAnchor, constant: 20),
            pila.trailingAnchor.constraint(equalTo: papel.trailingAnchor, constant: -20),
            pila.bottomAnchor.constraint(equalTo: papel.bottomAnchor, constant: -28)
        ])

        // Sello rojo "ANULADA" encima del ticket (solo si la venta fue anulada)
        if venta.anulada {
            let sello = UILabel()
            sello.text = " ANULADA "
            sello.font = .systemFont(ofSize: 36, weight: .black)
            sello.textColor = .systemRed
            sello.layer.borderColor = UIColor.systemRed.cgColor
            sello.layer.borderWidth = 4
            sello.layer.cornerRadius = 8
            sello.alpha = 0.75
            sello.transform = CGAffineTransform(rotationAngle: -.pi / 10)
            sello.translatesAutoresizingMaskIntoConstraints = false
            scroll.addSubview(sello)
            NSLayoutConstraint.activate([
                sello.centerXAnchor.constraint(equalTo: papel.centerXAnchor),
                sello.centerYAnchor.constraint(equalTo: papel.centerYAnchor)
            ])
        }
    }

    @objc private func cerrar() {
        dismiss(animated: true)
    }

    // Texto con letra de ticketera (monoespaciada)
    private func texto(_ contenido: String, tam: CGFloat, peso: UIFont.Weight = .regular,
                       color: UIColor = .black, centrado: Bool = false) -> UILabel {
        let lbl = UILabel()
        lbl.text = contenido
        lbl.font = .monospacedSystemFont(ofSize: tam, weight: peso)
        lbl.textColor = color
        lbl.textAlignment = centrado ? .center : .left
        lbl.numberOfLines = 0
        return lbl
    }

    // Fila del ticket: texto a la izquierda y monto a la derecha
    // resaltar: pone un fondo de color suave detrás de la fila
    // (descuento en verde, IGV en naranja, total en índigo)
    private func fila(_ izquierda: String, _ derecha: String,
                      peso: UIFont.Weight = .regular, tam: CGFloat = 13,
                      resaltar: UIColor? = nil, solida: Bool = false) -> UIView {
        // Si la fila va resaltada, la letra toma el tono oscuro de ese color (o blanca si es sólida)
        let colorLetra: UIColor = solida ? .white : (resaltar.map { tonoOscuro($0) } ?? .black)
        let lblIzq = texto(izquierda, tam: tam, peso: peso, color: colorLetra)
        let lblDer = texto(derecha, tam: tam, peso: peso, color: colorLetra)
        lblDer.textAlignment = .right
        lblDer.setContentCompressionResistancePriority(.required, for: .horizontal)
        lblDer.setContentHuggingPriority(.required, for: .horizontal)
        let fila = UIStackView(arrangedSubviews: [lblIzq, lblDer])
        fila.axis = .horizontal
        fila.spacing = 8
        fila.alignment = .firstBaseline
        if let color = resaltar {
            return resaltado(fila, color: color, solida: solida)
        }
        return fila
    }

    // Envuelve una vista en un recuadro redondeado con fondo de color suave
    private func resaltado(_ contenido: UIView, color: UIColor, solida: Bool = false) -> UIView {
        contenido.translatesAutoresizingMaskIntoConstraints = false
        let caja = UIView()
        caja.backgroundColor = solida ? color : color.withAlphaComponent(0.25)
        caja.layer.cornerRadius = 8
        caja.addSubview(contenido)
        NSLayoutConstraint.activate([
            contenido.topAnchor.constraint(equalTo: caja.topAnchor, constant: 6),
            contenido.leadingAnchor.constraint(equalTo: caja.leadingAnchor, constant: 8),
            contenido.trailingAnchor.constraint(equalTo: caja.trailingAnchor, constant: -8),
            contenido.bottomAnchor.constraint(equalTo: caja.bottomAnchor, constant: -6)
        ])
        return caja
    }
}
