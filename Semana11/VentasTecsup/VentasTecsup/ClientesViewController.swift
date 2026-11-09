import UIKit
import CoreData

// A4 · Clientes
// ① Botón + · ② Fila con iniciales, nombre, documento y total comprado
// ③ Categoría y total calculados con las ventas no anuladas
// Vendedor: crear, editar y consultar · Supervisor: además borrar
class ClientesViewController: UITableViewController {

    private var clientes: [Cliente] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // ① Botón + (ambos roles pueden crear)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self,
                                                            action: #selector(nuevoCliente))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cargar()
    }

    private func cargar() {
        let req: NSFetchRequest<Cliente> = Cliente.fetchRequest()
        req.sortDescriptors = [NSSortDescriptor(key: "nombre", ascending: true)]
        clientes = (try? contexto().fetch(req)) ?? []
        tableView.reloadData()
    }

    // MARK: - Tabla
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clientes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "celda")
            ?? UITableViewCell(style: .subtitle, reuseIdentifier: "celda")
        let c = clientes[indexPath.row]
        // ② Iniciales, nombre, documento y total comprado · ③ Categoría calculada
        celda.imageView?.image = imagenIniciales(c.nombre ?? "")
        celda.textLabel?.text = c.nombre
        celda.detailTextLabel?.text = "Doc. \(c.documento ?? "") · Comprado \(soles(Reglas.totalComprado(c))) · \(Reglas.categoria(c).rawValue)"
        celda.detailTextLabel?.numberOfLines = 0
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
