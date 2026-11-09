import UIKit
import CoreData

// A9 · Resumen (supervisor)
// ① Saludo con nombre y rol · ② Indicadores con comparación contra el día anterior
// ③ Gráfico de barras de los últimos 7 días · ④ Ranking de vendedores del mes
// ⑤ Productos con stock bajo
class ResumenViewController: UIViewController {

    private let lblSaludo = UILabel()
    private let lblIndicadores = UILabel()
    private let grafico = GraficoBarras()
    private let lblRanking = UILabel()
    private let lblStockBajo = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        lblSaludo.font = .boldSystemFont(ofSize: 22)
        lblSaludo.numberOfLines = 0
        lblIndicadores.numberOfLines = 0
        lblRanking.numberOfLines = 0
        lblStockBajo.numberOfLines = 0
        grafico.heightAnchor.constraint(equalToConstant: 180).isActive = true

        let pila = UIStackView(arrangedSubviews: [
            lblSaludo,
            crearTitulo("Indicadores de hoy"), lblIndicadores,
            crearTitulo("Ventas de los últimos 7 días (S/)"), grafico,
            crearTitulo("Ranking de vendedores del mes"), lblRanking,
            crearTitulo("Productos con stock bajo (5 o menos)"), lblStockBajo
        ])
        pila.axis = .vertical
        pila.spacing = 12
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
            pila.topAnchor.constraint(equalTo: scroll.contentLayoutGuide.topAnchor, constant: 20),
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

    private func cargar() {
        let usuario = Sesion.shared.usuario
        let cal = Calendar.current
        let hoy = inicioDeHoy()
        let ayer = cal.date(byAdding: .day, value: -1, to: hoy)!

        // ① Saludo
        lblSaludo.text = "Hola, \(usuario?.nombre ?? "") (\(usuario?.rol ?? ""))"

        // ② Indicadores: hoy contra ayer
        let ventasHoy = ventasValidas(desde: hoy, hasta: nil)
        let ventasAyer = ventasValidas(desde: ayer, hasta: hoy)
        let totalHoy = totalVentas(ventasHoy)
        let totalAyer = totalVentas(ventasAyer)
        let comparacion: String
        if totalAyer == 0 {
            comparacion = totalHoy > 0 ? "▲ Ayer no hubo ventas" : "Sin ventas hoy ni ayer"
        } else {
            let cambio = (totalHoy - totalAyer) / totalAyer * 100
            comparacion = String(format: "%@ %.1f %% respecto a ayer", cambio >= 0 ? "▲" : "▼", abs(cambio))
        }
        lblIndicadores.text = """
        Hoy: \(soles(totalHoy)) en \(ventasHoy.count) venta(s)
        Ayer: \(soles(totalAyer)) en \(ventasAyer.count) venta(s)
        \(comparacion)
        """

        // ③ Últimos 7 días
        let formatoDia = DateFormatter()
        formatoDia.dateFormat = "dd/MM"
        var valores: [Double] = []
        var etiquetas: [String] = []
        for i in stride(from: 6, through: 0, by: -1) {
            let dia = cal.date(byAdding: .day, value: -i, to: hoy)!
            let siguiente = cal.date(byAdding: .day, value: 1, to: dia)!
            valores.append(totalVentas(ventasValidas(desde: dia, hasta: siguiente)))
            etiquetas.append(formatoDia.string(from: dia))
        }
        grafico.etiquetas = etiquetas
        grafico.valores = valores

        // ④ Ranking de vendedores del mes (usa la relación venta ▸ vendedor)
        var porVendedor: [String: Double] = [:]
        for venta in ventasValidas(desde: inicioDelMes(), hasta: nil) {
            porVendedor[venta.vendedor?.nombre ?? "—", default: 0] += venta.total
        }
        let ranking = porVendedor.sorted { $0.value > $1.value }
        if ranking.isEmpty {
            lblRanking.text = "Sin ventas este mes."
        } else {
            lblRanking.text = ranking.enumerated()
                .map { "\($0.offset + 1). \($0.element.key): \(soles($0.element.value))" }
                .joined(separator: "\n")
        }

        // ⑤ Productos con stock bajo
        let reqStock: NSFetchRequest<Producto> = Producto.fetchRequest()
        reqStock.predicate = NSPredicate(format: "stock <= 5")
        reqStock.sortDescriptors = [NSSortDescriptor(key: "stock", ascending: true)]
        let bajos = (try? contexto().fetch(reqStock)) ?? []
        if bajos.isEmpty {
            lblStockBajo.text = "Todo el stock está bien."
            lblStockBajo.textColor = .label
        } else {
            lblStockBajo.text = bajos.map { "• \($0.nombre ?? ""): \($0.stock)" }.joined(separator: "\n")
            lblStockBajo.textColor = .systemRed
        }
    }
}
