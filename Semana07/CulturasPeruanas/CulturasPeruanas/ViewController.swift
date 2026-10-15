import UIKit

final class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private let tabla = UITableView(frame: .zero, style: .insetGrouped)
    private let culturas = Cultura.ejemplos

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        title = "Culturas del Perú"
        navigationController?.navigationBar.prefersLargeTitles = true
        configurarTabla()
    }

    private func configurarTabla() {
        tabla.translatesAutoresizingMaskIntoConstraints = false
        tabla.delegate = self
        tabla.dataSource = self
        tabla.register(UITableViewCell.self, forCellReuseIdentifier: "CulturaCell")
        tabla.rowHeight = 86
        view.addSubview(tabla)

        NSLayoutConstraint.activate([
            tabla.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tabla.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tabla.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tabla.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        culturas.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "CulturaCell", for: indexPath)
        let cultura = culturas[indexPath.row]
        var contenido = celda.defaultContentConfiguration()
        contenido.text = cultura.nombre
        contenido.secondaryText = cultura.region
        contenido.image = UIImage(systemName: cultura.simbolo)
        contenido.imageProperties.tintColor = cultura.color
        contenido.imageProperties.preferredSymbolConfiguration = UIImage.SymbolConfiguration(pointSize: 30, weight: .medium)
        celda.contentConfiguration = contenido
        celda.accessoryType = .disclosureIndicator
        celda.backgroundColor = .secondarySystemGroupedBackground
        return celda
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detalle = DetalleCulturaViewController(cultura: culturas[indexPath.row])
        navigationController?.pushViewController(detalle, animated: true)
    }
}
