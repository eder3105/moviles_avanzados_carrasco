import UIKit

/// Pantalla 1: lista de culturas peruanas.
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    let culturas = Cultura.todas

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Culturas Peruanas"
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.dataSource = self
        tableView.delegate = self
    }

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return culturas.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celda", for: indexPath) as! CulturaTableViewCell
        cell.configurar(con: culturas[indexPath.row])
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    // MARK: - Navegación (segue "mostrarElementos" definido en Main.storyboard)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mostrarElementos",
           let destino = segue.destination as? ElementosViewController,
           let celda = sender as? UITableViewCell,
           let indexPath = tableView.indexPath(for: celda) {
            destino.cultura = culturas[indexPath.row]
        }
    }
}
