import UIKit
import CoreData

// A1 · Login
// ① Logo y nombre · ② Usuario · ③ Clave oculta · ④ Mensaje de error genérico
// ⑤ Ingresar · ⑥ Ir a Crear cuenta
class LoginViewController: UIViewController {

    private let txtUsuario = crearCampo("Usuario")
    private let txtClave = crearCampo("Clave", seguro: true)
    private let lblError = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.backButtonTitle = "Volver al login"
        DatosDemo.cargarSiVacio()

        // ① Logo y nombre
        let logo = UIImageView(image: UIImage(systemName: "cart.fill"))
        logo.tintColor = .systemBlue
        logo.contentMode = .scaleAspectFit
        logo.heightAnchor.constraint(equalToConstant: 80).isActive = true

        let nombreApp = UILabel()
        nombreApp.text = "VentasTecsup"
        nombreApp.font = .boldSystemFont(ofSize: 30)
        nombreApp.textAlignment = .center

        // ④ Mensaje de error (oculto al inicio)
        lblError.textColor = .systemRed
        lblError.textAlignment = .center
        lblError.isHidden = true

        // ⑤ Ingresar
        let btnIngresar = UIButton(configuration: .filled())
        btnIngresar.setTitle("Ingresar", for: .normal)
        btnIngresar.addTarget(self, action: #selector(ingresar), for: .touchUpInside)

        // ⑥ Crear cuenta
        let btnCrear = UIButton(type: .system)
        btnCrear.setTitle("Crear cuenta", for: .normal)
        btnCrear.addTarget(self, action: #selector(irARegistro), for: .touchUpInside)

        montarPila([logo, nombreApp, txtUsuario, txtClave, lblError, btnIngresar, btnCrear])
    }

    @objc private func ingresar() {
        let usuario = txtUsuario.text?.trimmingCharacters(in: .whitespaces) ?? ""
        let clave = txtClave.text ?? ""

        // Busca un usuario con ese nombre (sin distinguir mayúsculas) y esa clave
        let req: NSFetchRequest<Usuario> = Usuario.fetchRequest()
        req.predicate = NSPredicate(format: "usuario ==[c] %@ AND clave == %@", usuario, clave)

        if let encontrado = (try? contexto().fetch(req))?.first {
            lblError.isHidden = true
            txtClave.text = ""
            Sesion.shared.iniciar(encontrado)
        } else {
            // Mensaje genérico: no dice si falló el usuario o la clave
            lblError.text = "Usuario o clave incorrectos"
            lblError.isHidden = false
        }
    }

    @objc private func irARegistro() {
        navigationController?.pushViewController(RegistroViewController(), animated: true)
    }
}
