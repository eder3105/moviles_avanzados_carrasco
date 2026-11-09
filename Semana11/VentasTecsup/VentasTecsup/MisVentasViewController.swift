import UIKit
import CoreData

// A6 · Mis ventas (vendedor)
// ① Indicadores propios: hoy y mes · ② Segmented Todas / Hoy / Mes
// ③ Búsqueda por cliente · ④ Venta propia · ⑤ Venta anulada (tachada, con etiqueta, sin botón)
class MisVentasViewController: UITableViewController, UISearchResultsUpdating {

    private var ventas: [Venta] = []
    private let lblIndicadores = UILabel()
    private let periodo = UISegmentedControl(items: ["Todas", "Hoy", "Mes"])
    private let buscador = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        definesPresentationContext = true

        lblIndicadores.numberOfLines = 0
        lblIndicadores.font = .boldSystemFont(ofSize: 16)
        periodo.selectedSegmentIndex = 0
        periodo.addTarget(self, action: #selector(cargar), for: .valueChanged)
        tableView.tableHeaderView = crearCabecera([lblIndicadores, periodo])

        // ③ Búsqueda por cliente
        buscador.searchResultsUpdater = self
        buscador.obscuresBackgroundDuringPresentation = false
        buscador.searchBar.placeholder = "Buscar por cliente"
        navigationItem.searchController = buscador
        navigationItem.hidesSearchBarWhenScrolling = false
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cargar()
    }

    @objc private func cargar() {
        guard let yo = Sesion.shared.usuario else { return }

        // ① Indicadores propios (sin contar anuladas)
        let deHoy = buscarVentas(vendedor: yo, desde: inicioDeHoy(), cliente: "")
        let delMes = buscarVentas(vendedor: yo, desde: inicioDelMes(), cliente: "")
        lblIndicadores.text = "Hoy: \(soles(totalVentas(deHoy)))   ·   Mes: \(soles(totalVentas(delMes)))"

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

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "celda")
            ?? UITableViewCell(style: .subtitle, reuseIdentifier: "celda")
        configurarCeldaVenta(celda, ventas[indexPath.row], mostrarVendedor: false)
        return celda
    }
    // No hay métodos de edición: el vendedor no puede anular (caso de prueba 7)
}
