import UIKit

// Pestaña Cuenta: nombre, usuario, rol y botón Cerrar sesión
class CuentaViewController: UITableViewController {

    init() {
        super.init(style: .insetGrouped)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) no se usa")
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 1 ? 2 : 1
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 1 ? "Datos de la cuenta" : nil
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let usuario = Sesion.shared.usuario

        switch indexPath.section {
        case 0:
            // Perfil: iniciales, nombre y rol
            let celda = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
            var c = celda.defaultContentConfiguration()
            c.image = imagenIniciales(usuario?.nombre ?? "")
            c.imageProperties.maximumSize = CGSize(width: 52, height: 52)
            c.text = usuario?.nombre
            c.textProperties.font = .systemFont(ofSize: 20, weight: .bold)
            c.secondaryText = usuario?.rol
            c.secondaryTextProperties.color = tonoOscuro(Tema.principal)
            celda.contentConfiguration = c
            var fondo = celda.defaultBackgroundConfiguration()
            fondo.backgroundColor = Tema.principal.withAlphaComponent(0.18)
            celda.backgroundConfiguration = fondo
            celda.selectionStyle = .none
            return celda

        case 1:
            let celda = UITableViewCell(style: .value1, reuseIdentifier: nil)
            var c = celda.defaultContentConfiguration()
            c.text = indexPath.row == 0 ? "Usuario" : "Rol"
            c.secondaryText = indexPath.row == 0 ? usuario?.usuario : usuario?.rol
            celda.contentConfiguration = c
            celda.selectionStyle = .none
            return celda

        default:
            // Botón Cerrar sesión
            let celda = UITableViewCell()
            var c = celda.defaultContentConfiguration()
            c.text = "Cerrar sesión"
            c.textProperties.color = .white
            c.textProperties.alignment = .center
            c.textProperties.font = .systemFont(ofSize: 17, weight: .bold)
            celda.contentConfiguration = c
            var fondo = celda.defaultBackgroundConfiguration()
            fondo.backgroundColor = .systemRed // todo el cuadro en rojo
            celda.backgroundConfiguration = fondo
            return celda
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 2 {
            Sesion.shared.cerrar()
        }
    }
}
