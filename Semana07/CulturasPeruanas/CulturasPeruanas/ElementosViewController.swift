import UIKit

/// Pantalla 2: elementos de la cultura seleccionada (imagen + título).
/// Arriba de la tabla se muestran la región y la descripción de la cultura.
class ElementosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    /// La asigna ViewController en prepare(for:sender:)
    var cultura: Cultura!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = cultura.nombre
        navigationItem.largeTitleDisplayMode = .never
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableHeaderView = crearEncabezado()
    }

    /// Encabezado de la tabla con región y descripción de la cultura.
    private func crearEncabezado() -> UIView {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false

        let texto = NSMutableAttributedString(
            string: "Región: " + cultura.region + "\n\n",
            attributes: [.font: UIFont.boldSystemFont(ofSize: 15),
                         .foregroundColor: UIColor.secondaryLabel])
        texto.append(NSAttributedString(
            string: cultura.descripcion,
            attributes: [.font: UIFont.systemFont(ofSize: 16),
                         .foregroundColor: UIColor.label]))
        label.attributedText = texto

        let contenedor = UIView()
        contenedor.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contenedor.topAnchor, constant: 16),
            label.bottomAnchor.constraint(equalTo: contenedor.bottomAnchor, constant: -16),
            label.leadingAnchor.constraint(equalTo: contenedor.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: contenedor.trailingAnchor, constant: -16)
        ])
        return contenedor
    }

    /// Ajusta la altura del encabezado cuando ya se conoce el ancho de la tabla.
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard let header = tableView.tableHeaderView else { return }
        let ancho = tableView.bounds.width
        let alto = header.systemLayoutSizeFitting(
            CGSize(width: ancho, height: UIView.layoutFittingCompressedSize.height),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel).height
        if header.frame.height != alto || header.frame.width != ancho {
            header.frame = CGRect(x: 0, y: 0, width: ancho, height: alto)
            tableView.tableHeaderView = header
        }
    }

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cultura.elementos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celdaElemento", for: indexPath) as! ElementoTableViewCell
        cell.configurar(con: cultura.elementos[indexPath.row])
        return cell
    }

    // MARK: - Navegación (segue "mostrarDetalle" definido en Main.storyboard)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mostrarDetalle",
           let destino = segue.destination as? DetalleElementoViewController,
           let celda = sender as? UITableViewCell,
           let indexPath = tableView.indexPath(for: celda) {
            destino.elemento = cultura.elementos[indexPath.row]
        }
    }
}
