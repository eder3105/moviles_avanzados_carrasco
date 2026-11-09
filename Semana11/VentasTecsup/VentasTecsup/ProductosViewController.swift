import UIKit
import CoreData

// A3 · Productos
// ① Título y + (solo supervisor) · ② Búsqueda · ③ Chips de categoría (predicate)
// ④ Stock en color: verde > 10, ámbar 6 a 10, rojo 5 o menos
// ⑤ Deslizar para borrar (solo supervisor; bloqueado si tiene ventas)
class ProductosViewController: UITableViewController, UISearchResultsUpdating {

    private var productos: [Producto] = []
    private var categorias: [String] = []
    private let chips = UISegmentedControl()
    private let buscador = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        definesPresentationContext = true

        // ② Búsqueda
        buscador.searchResultsUpdater = self
        buscador.obscuresBackgroundDuringPresentation = false
        buscador.searchBar.placeholder = "Buscar producto"
        navigationItem.searchController = buscador
        navigationItem.hidesSearchBarWhenScrolling = false

        // ③ Chips de categoría
        chips.addTarget(self, action: #selector(cargar), for: .valueChanged)
        tableView.tableHeaderView = crearCabecera([chips])

        // ① Botón + solo para el supervisor
        if Sesion.shared.esSupervisor {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self,
                                                                action: #selector(nuevoProducto))
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        actualizarChips()
        cargar()
    }

    // Arma los chips con las categorías que existen ("Todas" + cada categoría)
    private func actualizarChips() {
        let req: NSFetchRequest<Producto> = Producto.fetchRequest()
        let todos = (try? contexto().fetch(req)) ?? []
        let anterior = chips.selectedSegmentIndex >= 0 ? chips.titleForSegment(at: chips.selectedSegmentIndex) : nil

        categorias = Array(Set(todos.compactMap { $0.categoria })).sorted()
        let titulos = ["Todas"] + categorias
        chips.removeAllSegments()
        for (indice, titulo) in titulos.enumerated() {
            chips.insertSegment(withTitle: titulo, at: indice, animated: false)
        }
        chips.selectedSegmentIndex = titulos.firstIndex(of: anterior ?? "Todas") ?? 0
    }

    // Fetch request con NSPredicate: texto en el nombre + categoría elegida
    @objc private func cargar() {
        let req: NSFetchRequest<Producto> = Producto.fetchRequest()
        var condiciones: [NSPredicate] = []
        let texto = buscador.searchBar.text ?? ""
        if !texto.isEmpty {
            condiciones.append(NSPredicate(format: "nombre CONTAINS[cd] %@", texto))
        }
        if chips.selectedSegmentIndex > 0 {
            condiciones.append(NSPredicate(format: "categoria == %@", categorias[chips.selectedSegmentIndex - 1]))
        }
        req.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: condiciones)
        req.sortDescriptors = [NSSortDescriptor(key: "nombre", ascending: true)]
        productos = (try? contexto().fetch(req)) ?? []
        tableView.reloadData()
    }

    func updateSearchResults(for searchController: UISearchController) {
        cargar()
    }

    // MARK: - Tabla
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "celda")
            ?? UITableViewCell(style: .subtitle, reuseIdentifier: "celda")
        let p = productos[indexPath.row]
        celda.textLabel?.text = p.nombre
        celda.detailTextLabel?.text = "\(p.categoria ?? "") · \(soles(p.precio))"

        // ④ Stock en color
        let etiqueta = UILabel()
        etiqueta.text = "Stock \(p.stock)"
        etiqueta.font = .boldSystemFont(ofSize: 14)
        etiqueta.textColor = colorStock(p.stock)
        etiqueta.sizeToFit()
        celda.accessoryView = etiqueta
        celda.selectionStyle = Sesion.shared.esSupervisor ? .default : .none
        return celda
    }

    // Tocar una fila: editar (solo supervisor)
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard Sesion.shared.esSupervisor else { return }
        formulario(productos[indexPath.row])
    }

    // ⑤ Deslizar para borrar: solo el supervisor
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return Sesion.shared.esSupervisor
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        let ctx = contexto()
        ctx.delete(productos[indexPath.row])
        do {
            try ctx.save()
            actualizarChips()
            cargar()
        } catch {
            // Delete rule Deny: Core Data no deja guardar si el producto tiene ventas
            ctx.rollback()
            tableView.reloadData()
            mostrarAlerta("No se puede borrar", "Este producto tiene ventas registradas.")
        }
    }

    // MARK: - Crear / editar
    @objc private func nuevoProducto() {
        formulario(nil)
    }

    private func formulario(_ producto: Producto?) {
        let alerta = UIAlertController(title: producto == nil ? "Nuevo producto" : "Editar producto",
                                       message: nil, preferredStyle: .alert)
        alerta.addTextField { campo in
            campo.placeholder = "Nombre"
            campo.text = producto?.nombre
        }
        alerta.addTextField { campo in
            campo.placeholder = "Categoría"
            campo.text = producto?.categoria
        }
        alerta.addTextField { campo in
            campo.placeholder = "Precio (ej. 35.50)"
            campo.keyboardType = .decimalPad
            if let p = producto { campo.text = String(p.precio) }
        }
        alerta.addTextField { campo in
            campo.placeholder = "Stock"
            campo.keyboardType = .numberPad
            if let p = producto { campo.text = String(p.stock) }
        }
        alerta.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        alerta.addAction(UIAlertAction(title: "Guardar", style: .default) { _ in
            let campos = alerta.textFields ?? []
            let nombre = campos[0].text?.trimmingCharacters(in: .whitespaces) ?? ""
            let categoria = campos[1].text?.trimmingCharacters(in: .whitespaces) ?? ""
            let textoPrecio = (campos[2].text ?? "").replacingOccurrences(of: ",", with: ".")
            guard !nombre.isEmpty, !categoria.isEmpty,
                  let precio = Double(textoPrecio), precio > 0,
                  let stock = Int64(campos[3].text ?? ""), stock >= 0 else {
                self.mostrarAlerta("Datos inválidos", "Revisa nombre, categoría, precio y stock.")
                return
            }
            let ctx = contexto()
            let p = producto ?? Producto(context: ctx)
            p.nombre = nombre
            p.categoria = categoria
            p.precio = precio
            p.stock = stock
            do {
                try ctx.save()
            } catch {
                ctx.rollback()
            }
            self.actualizarChips()
            self.cargar()
        })
        present(alerta, animated: true)
    }
}
