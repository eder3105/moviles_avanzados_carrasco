import UIKit
import CoreData

// A7 · Ventas del equipo (supervisor)
// ① Chips por vendedor · ② Venta con el nombre del vendedor (relación venta ▸ vendedor)
// ③ Deslizar para Anular (solo supervisor) · ④ Nota de la relación
// A8 · Anular venta: ① resumen y aviso de stock · ② motivo obligatorio · ③ Anular deshabilitado sin motivo
class VentasEquipoViewController: UITableViewController, UISearchResultsUpdating {

    private var ventas: [Venta] = []
    private var vendedores: [Usuario] = []
    private let chips = UISegmentedControl()
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

        chips.addTarget(self, action: #selector(cargar), for: .valueChanged)
        periodo.selectedSegmentIndex = 0
        periodo.addTarget(self, action: #selector(cargar), for: .valueChanged)
        tableView.ponerCabecera([crearTitulo("Vendedor"), chips, crearTitulo("Periodo"), periodo])

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
        actualizarChips()
        cargar()
    }

    // ① Chips: "Todos" + cada vendedor
    private func actualizarChips() {
        let req: NSFetchRequest<Usuario> = Usuario.fetchRequest()
        req.predicate = NSPredicate(format: "rol == %@", "Vendedor")
        req.sortDescriptors = [NSSortDescriptor(key: "nombre", ascending: true)]
        let anterior = chips.selectedSegmentIndex >= 0 ? chips.titleForSegment(at: chips.selectedSegmentIndex) : nil

        vendedores = (try? contexto().fetch(req)) ?? []
        let titulos = ["Todos"] + vendedores.map { $0.usuario ?? "" }
        chips.removeAllSegments()
        for (indice, titulo) in titulos.enumerated() {
            chips.insertSegment(withTitle: titulo, at: indice, animated: false)
        }
        chips.selectedSegmentIndex = titulos.firstIndex(of: anterior ?? "Todos") ?? 0
    }

    // El supervisor ve todas; filtra por vendedor, periodo y cliente con NSPredicate
    @objc private func cargar() {
        let vendedor: Usuario? = chips.selectedSegmentIndex > 0 ? vendedores[chips.selectedSegmentIndex - 1] : nil
        ventas = buscarVentas(vendedor: vendedor,
                              desde: fechaDesde(segmento: periodo.selectedSegmentIndex),
                              cliente: buscador.searchBar.text ?? "")
        tableView.reloadData()
    }

    func updateSearchResults(for searchController: UISearchController) {
        cargar()
    }

    // MARK: - Tabla
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ventas.count
    }

    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        let vacio = ventas.isEmpty ? "No hay ventas para mostrar.\n\n" : ""
        // ④ Nota de la relación
        return vacio + "Desliza una venta a la izquierda para anularla. Toca una venta para ver su comprobante.\n"
            + "El vendedor de cada fila se obtiene con la relación venta ▸ vendedor (To One)."
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "celda")
            ?? UITableViewCell(style: .subtitle, reuseIdentifier: "celda")
        // ② Muestra el nombre del vendedor
        configurarCeldaVenta(celda, ventas[indexPath.row], mostrarVendedor: true)
        return celda
    }

    // Tocar una venta: ver su comprobante
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let boleta = BoletaViewController(venta: ventas[indexPath.row])
        present(UINavigationController(rootViewController: boleta), animated: true)
    }

    // ③ Deslizar para Anular (solo supervisor y solo ventas no anuladas)
    override func tableView(_ tableView: UITableView,
                            trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let venta = ventas[indexPath.row]
        guard Sesion.shared.esSupervisor, !venta.anulada else {
            return UISwipeActionsConfiguration(actions: [])
        }
        let anular = UIContextualAction(style: .normal, title: "Anular") { [weak self] _, _, terminado in
            self?.pedirAnulacion(venta)
            terminado(true)
        }
        anular.backgroundColor = .systemRed
        anular.image = UIImage(systemName: "xmark.circle")
        return UISwipeActionsConfiguration(actions: [anular])
    }

    // MARK: - A8 · Anular con motivo
    private func pedirAnulacion(_ venta: Venta) {
        let resumen = """
        Cliente: \(venta.cliente?.nombre ?? "—")
        Producto: \(venta.producto?.nombre ?? "—") × \(venta.cantidad)
        Vendedor: \(venta.vendedor?.nombre ?? "—")
        Total: \(soles(venta.total))

        El stock se devolverá (+\(venta.cantidad) unidades).
        """
        let alerta = UIAlertController(title: "Anular venta", message: resumen, preferredStyle: .alert)
        alerta.addTextField { campo in
            campo.placeholder = "Motivo (obligatorio)"
            campo.autocapitalizationType = .sentences
        }

        let accionAnular = UIAlertAction(title: "Anular", style: .destructive) { [weak self] _ in
            let motivo = alerta.textFields?.first?.text?.trimmingCharacters(in: .whitespaces) ?? ""
            guard !motivo.isEmpty else { return }
            venta.anulada = true
            venta.motivoAnulacion = motivo
            venta.producto?.stock += venta.cantidad // devuelve el stock
            let ctx = contexto()
            do {
                try ctx.save()
            } catch {
                ctx.rollback()
            }
            self?.cargar()
        }
        // ③ Deshabilitado mientras el motivo esté vacío
        accionAnular.isEnabled = false
        if let campo = alerta.textFields?.first {
            campo.addAction(UIAction { [weak accionAnular, weak campo] _ in
                let texto = campo?.text?.trimmingCharacters(in: .whitespaces) ?? ""
                accionAnular?.isEnabled = !texto.isEmpty
            }, for: .editingChanged)
        }

        alerta.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        alerta.addAction(accionAnular)
        present(alerta, animated: true)
    }
}
