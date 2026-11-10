import UIKit
import CoreData

// A4 · Clientes
// ① Botón + · ② Fila con iniciales, nombre, documento y total comprado
// ③ Categoría y total calculados con las ventas no anuladas
// Vendedor: crear, editar y consultar · Supervisor: además borrar
class ClientesViewController: UITableViewController, UISearchResultsUpdating {

    private var clientes: [Cliente] = []
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

        // ① Botón + (ambos roles pueden crear)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self,
                                                            action: #selector(nuevoCliente))

        // Búsqueda por nombre o documento
        buscador.searchResultsUpdater = self
        buscador.obscuresBackgroundDuringPresentation = false
        buscador.searchBar.placeholder = "Buscar por nombre o documento"
        navigationItem.searchController = buscador
        navigationItem.hidesSearchBarWhenScrolling = false
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cargar()
    }

    private func cargar() {
        let req: NSFetchRequest<Cliente> = Cliente.fetchRequest()
        let texto = buscador.searchBar.text ?? ""
        if !texto.isEmpty {
            req.predicate = NSPredicate(format: "nombre CONTAINS[cd] %@ OR documento CONTAINS[cd] %@", texto, texto)
        }
        req.sortDescriptors = [NSSortDescriptor(key: "nombre", ascending: true)]
        clientes = (try? contexto().fetch(req)) ?? []
        tableView.reloadData()
    }

    func updateSearchResults(for searchController: UISearchController) {
        cargar()
    }

    // MARK: - Tabla
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clientes.count
    }

    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if clientes.isEmpty { return "No hay clientes para mostrar." }
        // ③ Nota de la maqueta
        return "Categoría y «comprado» se calculan con las ventas no anuladas; no se guardan."
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "celda")
            ?? UITableViewCell(style: .subtitle, reuseIdentifier: "celda")
        let cliente = clientes[indexPath.row]
        let categoria = Reglas.categoria(cliente)

        // ② Iniciales, nombre, documento y total comprado
        var c = celda.defaultContentConfiguration()
        c.image = imagenIniciales(cliente.nombre ?? "", color: categoria.color)
        c.imageProperties.maximumSize = CGSize(width: 40, height: 40)
        c.text = cliente.nombre
        c.textProperties.font = .systemFont(ofSize: 16, weight: .semibold)
        c.secondaryText = "Doc. \(cliente.documento ?? "")"
        c.secondaryTextProperties.color = .secondaryLabel
        celda.contentConfiguration = c

        // ③ Total comprado en texto oscuro y categoría en etiqueta sólida
        //    (VIP dorado, Frecuente azul, Regular gris)
        let comprado = UILabel()
        comprado.text = soles(Reglas.totalComprado(cliente))
        comprado.font = .systemFont(ofSize: 15, weight: .bold)
        celda.accessoryView = columnaEtiquetas([comprado,
                                                Etiqueta(categoria.rawValue, color: categoria.color, solida: true)])

        // Los clientes VIP tienen toda la fila en dorado suave
        var fondo = celda.defaultBackgroundConfiguration()
        fondo.backgroundColor = categoria == .vip ? Tema.ambar.withAlphaComponent(0.15) : Tema.tarjeta
        celda.backgroundConfiguration = fondo
        return celda
    }

    // Tocar una fila: editar (ambos roles)
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        formulario(clientes[indexPath.row])
    }

    // Borrar: solo el supervisor
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return Sesion.shared.esSupervisor
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        let ctx = contexto()
        ctx.delete(clientes[indexPath.row])
        do {
            try ctx.save()
            cargar()
        } catch {
            // Delete rule Deny: no se puede borrar un cliente con ventas (caso de prueba 9)
            ctx.rollback()
            tableView.reloadData()
            mostrarAlerta("No se puede borrar", "Este cliente tiene ventas registradas.")
        }
    }

    // MARK: - Crear / editar
    @objc private func nuevoCliente() {
        formulario(nil)
    }

    private func formulario(_ cliente: Cliente?) {
        let alerta = UIAlertController(title: cliente == nil ? "Nuevo cliente" : "Editar cliente",
                                       message: nil, preferredStyle: .alert)
        alerta.addTextField { campo in
            campo.placeholder = "Nombre o razón social"
            campo.autocapitalizationType = .words
            campo.text = cliente?.nombre
        }
        alerta.addTextField { campo in
            campo.placeholder = "Documento (DNI o RUC)"
            campo.keyboardType = .numberPad
            campo.text = cliente?.documento
        }
        alerta.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        alerta.addAction(UIAlertAction(title: "Guardar", style: .default) { _ in
            let nombre = alerta.textFields?[0].text?.trimmingCharacters(in: .whitespaces) ?? ""
            let documento = alerta.textFields?[1].text?.trimmingCharacters(in: .whitespaces) ?? ""
            guard !nombre.isEmpty, !documento.isEmpty else {
                self.mostrarAlerta("Datos incompletos", "Completa nombre y documento.")
                return
            }
            let ctx = contexto()
            let c = cliente ?? Cliente(context: ctx)
            c.nombre = nombre
            c.documento = documento
            do {
                try ctx.save()
            } catch {
                ctx.rollback()
            }
            self.cargar()
        })
        present(alerta, animated: true)
    }
}
