import UIKit
import CoreData

// A2 · Crear cuenta
// ① Título y volver al login · ② Nombre completo · ③ Usuario único, con aviso si ya existe
// ④ Clave (mínimo 6) y su confirmación · ⑤ Rol · ⑥ Registrarme (entra directo a la app)
class RegistroViewController: UIViewController {

    private let txtNombre = crearCampo("Nombre completo")
    private let txtUsuario = crearCampo("Usuario")
    private let lblAviso = UILabel()
    private let txtClave = crearCampo("Clave (mínimo 6 caracteres)", seguro: true)
    private let txtConfirmar = crearCampo("Confirmar clave", seguro: true)
    private let selectorRol = UISegmentedControl(items: ["Vendedor", "Supervisor"])

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Crear cuenta"
        view.backgroundColor = Tema.fondo

        txtNombre.autocapitalizationType = .words
        txtUsuario.addTarget(self, action: #selector(revisarUsuario), for: .editingChanged)

        lblAviso.textColor = .systemRed
        lblAviso.font = .systemFont(ofSize: 13)
        lblAviso.isHidden = true

        selectorRol.selectedSegmentIndex = 0

        let btnRegistrar = crearBotonPrincipal("Registrarme")
        btnRegistrar.addTarget(self, action: #selector(registrar), for: .touchUpInside)

        let pila = montarPila([crearTitulo("Datos personales"), txtNombre,
                               crearTitulo("Acceso"), txtUsuario, lblAviso, txtClave, txtConfirmar,
                               crearTitulo("Rol"), selectorRol, btnRegistrar])
        pila.setCustomSpacing(8, after: pila.arrangedSubviews[0])
        pila.setCustomSpacing(24, after: txtNombre)
        pila.setCustomSpacing(8, after: pila.arrangedSubviews[2])
        pila.setCustomSpacing(24, after: txtConfirmar)
        pila.setCustomSpacing(30, after: selectorRol)
    }

    // Usuario único sin distinguir mayúsculas: "lparedes" y "LPAREDES" son el mismo
    private func existeUsuario(_ usuario: String) -> Bool {
        let req: NSFetchRequest<Usuario> = Usuario.fetchRequest()
        req.predicate = NSPredicate(format: "usuario ==[c] %@", usuario)
        return ((try? contexto().count(for: req)) ?? 0) > 0
    }

    // ③ Aviso mientras escribe
    @objc private func revisarUsuario() {
        let usuario = txtUsuario.text?.trimmingCharacters(in: .whitespaces) ?? ""
        let repetido = !usuario.isEmpty && existeUsuario(usuario)
        lblAviso.text = "El usuario «\(usuario)» ya existe"
        lblAviso.isHidden = !repetido
    }

    @objc private func registrar() {
        view.endEditing(true)
        let nombre = txtNombre.text?.trimmingCharacters(in: .whitespaces) ?? ""
        let usuario = txtUsuario.text?.trimmingCharacters(in: .whitespaces) ?? ""
        let clave = txtClave.text ?? ""
        let confirmar = txtConfirmar.text ?? ""

        guard !nombre.isEmpty, !usuario.isEmpty, !clave.isEmpty else {
            mostrarAlerta("Datos incompletos", "Completa nombre, usuario y clave.")
            return
        }
        guard !existeUsuario(usuario) else {
            mostrarAlerta("Usuario repetido", "Ya existe una cuenta con el usuario «\(usuario)».")
            return
        }
        guard clave.count >= 6 else {
            mostrarAlerta("Clave muy corta", "La clave debe tener mínimo 6 caracteres.")
            return
        }
        guard clave == confirmar else {
            mostrarAlerta("Las claves no coinciden", "Escribe la misma clave en ambos campos.")
            return
        }

        let ctx = contexto()
        let nuevo = Usuario(context: ctx)
        nuevo.nombre = nombre
        nuevo.usuario = usuario
        nuevo.clave = clave // Solo en práctica: en una app real se guarda un hash
        nuevo.rol = selectorRol.titleForSegment(at: selectorRol.selectedSegmentIndex)

        do {
            try ctx.save()
            Sesion.shared.iniciar(nuevo) // ⑥ Entra directo a la app
        } catch {
            ctx.rollback()
            mostrarAlerta("Error", "No se pudo crear la cuenta: \(error.localizedDescription)")
        }
    }
}
