import UIKit

// Pestañas según el rol
// Vendedor: Productos, Clientes, Venta, Mis ventas, Cuenta
// Supervisor: Resumen, Ventas, Productos, Clientes, Cuenta
class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Envuelve cada pantalla en un Navigation Controller con su ícono
        func pestana(_ pantalla: UIViewController, _ titulo: String, _ icono: String) -> UINavigationController {
            pantalla.title = titulo
            let nav = UINavigationController(rootViewController: pantalla)
            nav.tabBarItem = UITabBarItem(title: titulo, image: UIImage(systemName: icono), selectedImage: nil)
            return nav
        }

        if Sesion.shared.esSupervisor {
            viewControllers = [
                pestana(ProductosViewController(), "Productos", "shippingbox.fill"),
                pestana(ClientesViewController(), "Clientes", "person.2.fill"),
                pestana(CuentaViewController(), "Cuenta", "person.crop.circle")
            ]
        } else {
            viewControllers = [
                pestana(ProductosViewController(), "Productos", "shippingbox.fill"),
                pestana(ClientesViewController(), "Clientes", "person.2.fill"),
                pestana(CuentaViewController(), "Cuenta", "person.crop.circle")
            ]
        }
    }
}
