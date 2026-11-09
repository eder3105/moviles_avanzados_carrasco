import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    // La app arranca en el login (A1), creado por código
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let escena = (scene as? UIWindowScene) else { return }
        let ventana = UIWindow(windowScene: escena)
        ventana.rootViewController = UINavigationController(rootViewController: LoginViewController())
        ventana.makeKeyAndVisible()
        window = ventana
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Guarda los cambios pendientes de Core Data al salir de la app
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}
