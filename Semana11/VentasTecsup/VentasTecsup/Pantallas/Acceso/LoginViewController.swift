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
        navigationItem.backButtonTitle = "Volver al login"
        Tema.aplicarApariencia() // colores de la tienda en toda la app (solo decoración)
        DatosDemo.cargarSiVacio()

        // Fondo lila y una franja superior con degradado de bordes redondeados (solo decoración)
        view.backgroundColor = Tema.fondo
        let franja = FondoDegradado()
        franja.layer.cornerRadius = 36
        franja.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner] // solo esquinas de abajo
        franja.layer.masksToBounds = true
        franja.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(franja)
        NSLayoutConstraint.activate([
            franja.topAnchor.constraint(equalTo: view.topAnchor),
            franja.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            franja.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            franja.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 250)
        ])

        // ① Logo: cuadrado blanco redondeado con un carrito índigo
        let fondoLogo = UIView()
        fondoLogo.backgroundColor = .white
        fondoLogo.layer.cornerRadius = 24
        fondoLogo.translatesAutoresizingMaskIntoConstraints = false
        let carrito = UIImageView(image: UIImage(systemName: "cart.fill"))
        carrito.tintColor = Tema.principal
        carrito.contentMode = .scaleAspectFit
        carrito.translatesAutoresizingMaskIntoConstraints = false
        fondoLogo.addSubview(carrito)
        NSLayoutConstraint.activate([
            fondoLogo.widthAnchor.constraint(equalToConstant: 84),
            fondoLogo.heightAnchor.constraint(equalToConstant: 84),
            carrito.centerXAnchor.constraint(equalTo: fondoLogo.centerXAnchor),
            carrito.centerYAnchor.constraint(equalTo: fondoLogo.centerYAnchor),
            carrito.widthAnchor.constraint(equalToConstant: 42),
            carrito.heightAnchor.constraint(equalToConstant: 42)
        ])
        let filaLogo = UIStackView(arrangedSubviews: [fondoLogo])
        filaLogo.axis = .vertical
        filaLogo.alignment = .center

        let nombreApp = UILabel()
        nombreApp.text = "VentasTecsup"
        nombreApp.font = .systemFont(ofSize: 30, weight: .bold)
        nombreApp.textColor = .white
        nombreApp.textAlignment = .center

        let lema = UILabel()
        lema.text = "Sistema de ventas de la tienda"
        lema.font = .systemFont(ofSize: 15)
        lema.textColor = UIColor.white.withAlphaComponent(0.85)
        lema.textAlignment = .center

        // Saludo sobre el formulario
        let bienvenida = UILabel()
        bienvenida.text = "Iniciar sesión"
        bienvenida.font = .systemFont(ofSize: 22, weight: .bold)
        bienvenida.textColor = Tema.principal

        // ④ Mensaje de error (oculto al inicio)
        lblError.textColor = .systemRed
        lblError.backgroundColor = UIColor.systemRed.withAlphaComponent(0.12)
        lblError.font = .systemFont(ofSize: 14, weight: .semibold)
        lblError.textAlignment = .center
        lblError.layer.cornerRadius = 10
        lblError.clipsToBounds = true
        lblError.heightAnchor.constraint(equalToConstant: 36).isActive = true
        lblError.isHidden = true

        // ⑤ Ingresar: botón índigo
        let btnIngresar = crearBotonPrincipal("Ingresar")
        btnIngresar.addTarget(self, action: #selector(ingresar), for: .touchUpInside)

        // ⑥ Crear cuenta
        let btnCrear = UIButton(type: .system)
        btnCrear.setTitle("¿No tienes cuenta? Crear cuenta", for: .normal)
        btnCrear.setTitleColor(Tema.principal, for: .normal)
        btnCrear.addTarget(self, action: #selector(irARegistro), for: .touchUpInside)

        let pila = montarPila([filaLogo, nombreApp, lema, bienvenida, txtUsuario, txtClave, lblError,
                               btnIngresar, btnCrear])
        pila.setCustomSpacing(16, after: filaLogo)
        pila.setCustomSpacing(4, after: nombreApp)
        pila.setCustomSpacing(70, after: lema)      // deja el formulario debajo de la franja
        pila.setCustomSpacing(20, after: lblError)
    }

    // Hora y batería en blanco sobre la franja de color
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Barra superior transparente sobre el degradado
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // La pantalla de registro sí muestra la barra (para volver al login)
        navigationController?.setNavigationBarHidden(false, animated: animated)
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
