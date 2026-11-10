import UIKit
import CoreData

// A9 · Resumen (supervisor)
// ① Saludo con nombre y rol · ② Indicadores con comparación contra el día anterior
// ③ Gráfico de barras de los últimos 7 días · ④ Ranking de vendedores del mes
// ⑤ Productos con stock bajo
class ResumenViewController: UIViewController {

    private let lblSaludo = UILabel()
    private let lblFecha = UILabel()
    // Tarjeta principal con degradado: ventas de hoy
    private let tarjetaHoy = FondoDegradado(radio: 20)
    private let lblTotalHoy = UILabel()
    private let lblComparacion = UILabel()
    private let lblAyer = UILabel()
    private let grafico = GraficoBarras()
    private let pilaRanking = UIStackView()
    private let pilaStock = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Tema.fondo

        lblSaludo.font = .systemFont(ofSize: 26, weight: .bold)
        lblSaludo.numberOfLines = 0
        lblFecha.font = .systemFont(ofSize: 15)
        lblFecha.textColor = .secondaryLabel

        armarTarjetaHoy()
        grafico.heightAnchor.constraint(equalToConstant: 170).isActive = true
        for pila in [pilaRanking, pilaStock] {
            pila.axis = .vertical
            pila.spacing = 10
        }

        let pila = UIStackView(arrangedSubviews: [
            lblSaludo,
            lblFecha,
            tarjetaHoy,
            crearTarjeta(titulo: "Últimos 7 días (S/)", contenido: grafico),
            crearTarjeta(titulo: "Ranking de vendedores del mes", contenido: pilaRanking, color: Tema.ambar),
            crearTarjeta(titulo: "Productos con stock bajo (5 o menos)", contenido: pilaStock, color: .systemRed)
        ])
        pila.axis = .vertical
        pila.spacing = 16
        pila.setCustomSpacing(2, after: lblSaludo)
        pila.translatesAutoresizingMaskIntoConstraints = false

        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scroll)
        scroll.addSubview(pila)
        NSLayoutConstraint.activate([
            scroll.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scroll.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            pila.topAnchor.constraint(equalTo: scroll.contentLayoutGuide.topAnchor, constant: 16),
            pila.leadingAnchor.constraint(equalTo: scroll.contentLayoutGuide.leadingAnchor, constant: 20),
            pila.trailingAnchor.constraint(equalTo: scroll.contentLayoutGuide.trailingAnchor, constant: -20),
            pila.bottomAnchor.constraint(equalTo: scroll.contentLayoutGuide.bottomAnchor, constant: -20),
            pila.widthAnchor.constraint(equalTo: scroll.frameLayoutGuide.widthAnchor, constant: -40)
        ])
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cargar()
    }

    // ② Tarjeta con degradado: título, total grande, comparación y ayer (solo decoración)
    private func armarTarjetaHoy() {
        let lblTitulo = UILabel()
        lblTitulo.text = "Ventas de hoy"
        lblTitulo.font = .systemFont(ofSize: 15, weight: .semibold)
        lblTitulo.textColor = UIColor.white.withAlphaComponent(0.85)

        lblTotalHoy.font = .systemFont(ofSize: 36, weight: .bold)
        lblTotalHoy.textColor = .white
        lblTotalHoy.adjustsFontSizeToFitWidth = true
        lblTotalHoy.minimumScaleFactor = 0.6

        lblComparacion.font = .systemFont(ofSize: 14, weight: .semibold)
        lblComparacion.textColor = .white
        lblComparacion.numberOfLines = 0

        lblAyer.font = .systemFont(ofSize: 13)
        lblAyer.textColor = UIColor.white.withAlphaComponent(0.8)

        let pila = UIStackView(arrangedSubviews: [lblTitulo, lblTotalHoy, lblComparacion, lblAyer])
        pila.axis = .vertical
        pila.spacing = 4
        pila.translatesAutoresizingMaskIntoConstraints = false
        tarjetaHoy.addSubview(pila)
        NSLayoutConstraint.activate([
            pila.topAnchor.constraint(equalTo: tarjetaHoy.topAnchor, constant: 18),
            pila.leadingAnchor.constraint(equalTo: tarjetaHoy.leadingAnchor, constant: 20),
            pila.trailingAnchor.constraint(equalTo: tarjetaHoy.trailingAnchor, constant: -20),
            pila.bottomAnchor.constraint(equalTo: tarjetaHoy.bottomAnchor, constant: -18)
        ])
    }

    // Fetch request de ventas válidas (no anuladas) en un rango de fechas
    private func ventasValidas(desde: Date, hasta: Date?) -> [Venta] {
        let req: NSFetchRequest<Venta> = Venta.fetchRequest()
        if let hasta = hasta {
            req.predicate = NSPredicate(format: "anulada == NO AND fecha >= %@ AND fecha < %@",
                                        desde as NSDate, hasta as NSDate)
        } else {
            req.predicate = NSPredicate(format: "anulada == NO AND fecha >= %@", desde as NSDate)
        }
        return (try? contexto().fetch(req)) ?? []
    }

    // Vacía una pila y le pone filas nuevas
    private func llenar(_ pila: UIStackView, con filas: [UIView]) {
        pila.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for (i, fila) in filas.enumerated() {
            if i > 0 { pila.addArrangedSubview(separador()) }
            pila.addArrangedSubview(fila)
        }
    }

    private func textoGris(_ texto: String) -> UILabel {
        let lbl = UILabel()
        lbl.text = texto
        lbl.textColor = .secondaryLabel
        lbl.font = .systemFont(ofSize: 15)
        return lbl
    }

    private func cargar() {
        let usuario = Sesion.shared.usuario
        let cal = Calendar.current
        let hoy = inicioDeHoy()
        let ayer = cal.date(byAdding: .day, value: -1, to: hoy)!

        // ① Saludo
        lblSaludo.text = "Hola, \(usuario?.nombre ?? "")"
        let formatoLargo = DateFormatter()
        formatoLargo.locale = Locale(identifier: "es_PE")
        formatoLargo.dateFormat = "EEEE d 'de' MMMM"
        lblFecha.text = "\(usuario?.rol ?? "") · \(formatoLargo.string(from: Date()).capitalized)"

        // ② Indicadores: hoy contra ayer
        let ventasHoy = ventasValidas(desde: hoy, hasta: nil)
        let ventasAyer = ventasValidas(desde: ayer, hasta: hoy)
        let totalHoy = totalVentas(ventasHoy)
        let totalAyer = totalVentas(ventasAyer)

        var comparacion = "\(ventasHoy.count) venta(s)"
        if totalAyer > 0 {
            let cambio = (totalHoy - totalAyer) / totalAyer * 100
            comparacion += String(format: " · %@ %.1f %% vs ayer", cambio >= 0 ? "▲" : "▼", abs(cambio))
        } else if totalHoy > 0 {
            comparacion += " · ▲ ayer sin ventas"
        }
        lblTotalHoy.text = soles(totalHoy)
        lblComparacion.text = comparacion
        lblAyer.text = "Ayer: \(soles(totalAyer)) en \(ventasAyer.count) venta(s)"

        // ③ Últimos 7 días
        let formatoDia = DateFormatter()
        formatoDia.dateFormat = "dd/MM"
        var valores: [Double] = []
        var etiquetas: [String] = []
        for i in stride(from: 6, through: 0, by: -1) {
            let dia = cal.date(byAdding: .day, value: -i, to: hoy)!
            let siguiente = cal.date(byAdding: .day, value: 1, to: dia)!
            valores.append(totalVentas(ventasValidas(desde: dia, hasta: siguiente)))
            etiquetas.append(i == 0 ? "Hoy" : formatoDia.string(from: dia))
        }
        grafico.etiquetas = etiquetas
        grafico.valores = valores

        // ④ Ranking de vendedores del mes (usa la relación venta ▸ vendedor)
        var porVendedor: [String: Double] = [:]
        for venta in ventasValidas(desde: inicioDelMes(), hasta: nil) {
            porVendedor[venta.vendedor?.nombre ?? "—", default: 0] += venta.total
        }
        let ranking = porVendedor.sorted { $0.value > $1.value }
        // Colores de los puestos: oro, plata y bronce
        let coloresPuesto: [UIColor] = [Tema.ambar, .systemGray,
                                        UIColor(red: 0.72, green: 0.45, blue: 0.20, alpha: 1)]
        if ranking.isEmpty {
            llenar(pilaRanking, con: [textoGris("Sin ventas este mes.")])
        } else {
            llenar(pilaRanking, con: ranking.enumerated().map { (i, item) -> UIView in
                let puesto = Etiqueta("\(i + 1)°", color: i < 3 ? coloresPuesto[i] : .systemGray, solida: true)
                let nombre = UILabel()
                nombre.text = item.key
                nombre.font = .systemFont(ofSize: 15, weight: .medium)
                let monto = Etiqueta(soles(item.value), color: Tema.principal, solida: true)
                let fila = UIStackView(arrangedSubviews: [puesto, nombre, monto])
                fila.axis = .horizontal
                fila.spacing = 10
                fila.alignment = .center
                return fila
            })
        }

        // ⑤ Productos con stock bajo
        let reqStock: NSFetchRequest<Producto> = Producto.fetchRequest()
        reqStock.predicate = NSPredicate(format: "stock <= 5")
        reqStock.sortDescriptors = [NSSortDescriptor(key: "stock", ascending: true)]
        let bajos = (try? contexto().fetch(reqStock)) ?? []
        if bajos.isEmpty {
            llenar(pilaStock, con: [textoGris("Todo el stock está bien ✓")])
        } else {
            llenar(pilaStock, con: bajos.map { p -> UIView in
                let nombre = UILabel()
                nombre.text = p.nombre
                nombre.font = .systemFont(ofSize: 15, weight: .medium)
                let fila = UIStackView(arrangedSubviews: [nombre,
                                                          Etiqueta("Stock \(p.stock)", color: .systemRed, solida: true)])
                fila.axis = .horizontal
                fila.alignment = .center
                return fila
            })
        }
    }
}
