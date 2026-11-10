import UIKit
import CoreData

// A6 · Mis ventas (vendedor)
// ① Indicadores propios: hoy y mes · ② Segmented Todas / Hoy / Mes
// ③ Búsqueda por cliente · ④ Venta propia · ⑤ Venta anulada (tachada, con etiqueta, sin botón)
class MisVentasViewController: UITableViewController, UISearchResultsUpdating {

    private var ventas: [Venta] = []
    private let indicadorHoy = IndicadorView(titulo: "Hoy")
    private let indicadorMes = IndicadorView(titulo: "Mes", color: .systemTeal)
    private let periodo = UISegmentedControl(items: ["Todas", "Hoy", "Mes"])
    private let buscador = UISearchController(searchResultsController: nil)

    init() {
        super.init(style: .insetGrouped)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) no se usa")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        definesPresentationContext = true

        // ① Indicadores y ② periodo
        periodo.selectedSegmentIndex = 0
        periodo.addTarget(self, action: #selector(cargar), for: .valueChanged)
        tableView.ponerCabecera([filaIndicadores(indicadorHoy, indicadorMes), periodo])

        // ③ Búsqueda por cliente
        buscador.searchResultsUpdater = self
        buscador.obscuresBackgroundDuringPresentation = false
        buscador.searchBar.placeholder = "Buscar por cliente"
        navigationItem.searchController = buscador
        navigationItem.hidesSearchBarWhenScrolling = false
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.ajustarCabecera()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cargar()
    }

    @objc private func cargar() {
        guard let yo = Sesion.shared.usuario else { return }

        // ① Indicadores propios (sin contar anuladas)
        let deHoy = buscarVentas(vendedor: yo, desde: inicioDeHoy(), cliente: "").filter { !$0.anulada }
        let delMes = buscarVentas(vendedor: yo, desde: inicioDelMes(), cliente: "").filter { !$0.anulada }
        indicadorHoy.mostrar(valor: soles(totalVentas(deHoy)), detalle: "\(deHoy.count) venta(s)")
        indicadorMes.mostrar(valor: soles(totalVentas(delMes)), detalle: "\(delMes.count) venta(s)")

        // Visibilidad: predicate por vendedor -> solo MIS ventas
        ventas = buscarVentas(vendedor: yo,
                              desde: fechaDesde(segmento: periodo.selectedSegmentIndex),
                              cliente: buscador.searchBar.text ?? "")
        tableView.reloadData()
    }

    func updateSearchResults(for searchController: UISearchController) {
        cargar()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ventas.count
    }

    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if ventas.isEmpty { return "No hay ventas para mostrar." }
        return "Solo aparecen tus ventas. Toca una venta para ver su comprobante."
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "celda")
            ?? UITableViewCell(style: .subtitle, reuseIdentifier: "celda")
        configurarCeldaVenta(celda, ventas[indexPath.row], mostrarVendedor: false)
        return celda
    }

    // Tocar una venta: ver su comprobante
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let boleta = BoletaViewController(venta: ventas[indexPath.row])
        present(UINavigationController(rootViewController: boleta), animated: true)
    }
    // No hay métodos de edición: el vendedor no puede anular (caso de prueba 7)
}
