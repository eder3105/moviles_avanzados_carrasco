import UIKit

// Recuerda al usuario conectado mientras la app está abierta
class Sesion {
    static let shared = Sesion()
    private(set) var usuario: Usuario?
    private init() {}

    var esSupervisor: Bool {
        return usuario?.rol == "Supervisor"
    }

    // Guarda al usuario y muestra las pestañas según su rol
    func iniciar(_ usuario: Usuario) {
        self.usuario = usuario
        cambiarPantallaPrincipal(MainTabBarController())
    }

    // Olvida al usuario y vuelve al login
    func cerrar() {
        usuario = nil
        cambiarPantallaPrincipal(UINavigationController(rootViewController: LoginViewController()))
    }

    private func cambiarPantallaPrincipal(_ pantalla: UIViewController) {
        guard let escena = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let ventana = (escena.delegate as? SceneDelegate)?.window else { return }
        ventana.rootViewController = pantalla
        UIView.transition(with: ventana, duration: 0.3, options: .transitionCrossDissolve, animations: nil)
    }
}
