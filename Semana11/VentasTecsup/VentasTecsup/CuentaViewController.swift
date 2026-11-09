import UIKit

// Pestaña Cuenta: nombre, usuario, rol y botón Cerrar sesión
class CuentaViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        let usuario = Sesion.shared.usuario

        let icono = UIImageView(image: UIImage(systemName: "person.crop.circle.fill"))
        icono.tintColor = .systemBlue
        icono.contentMode = .scaleAspectFit
        icono.heightAnchor.constraint(equalToConstant: 80).isActive = true

        let lblNombre = UILabel()
        lblNombre.text = usuario?.nombre
        lblNombre.font = .boldSystemFont(ofSize: 22)
        lblNombre.textAlignment = .center

        let lblUsuario = UILabel()
        lblUsuario.text = "Usuario: \(usuario?.usuario ?? "")"
        lblUsuario.textAlignment = .center

        let lblRol = UILabel()
        lblRol.text = "Rol: \(usuario?.rol ?? "")"
        lblRol.textAlignment = .center

        var configuracion = UIButton.Configuration.filled()
        configuracion.title = "Cerrar sesión"
        configuracion.baseBackgroundColor = .systemRed
        let btnCerrar = UIButton(configuration: configuracion)
        btnCerrar.addTarget(self, action: #selector(cerrarSesion), for: .touchUpInside)

        montarPila([icono, lblNombre, lblUsuario, lblRol, btnCerrar])
    }

    @objc private func cerrarSesion() {
        Sesion.shared.cerrar()
    }
}
