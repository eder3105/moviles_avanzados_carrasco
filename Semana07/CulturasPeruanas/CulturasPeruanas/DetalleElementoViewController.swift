import UIKit

/// Pantalla 3: detalle del elemento seleccionado (título, imagen y descripción).
class DetalleElementoViewController: UIViewController {

    @IBOutlet weak var imgElemento: UIImageView!
    @IBOutlet weak var lblTitulo: UILabel!
    @IBOutlet weak var txtDescripcion: UITextView!

    /// La asigna ElementosViewController en prepare(for:sender:)
    var elemento: Elemento?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never

        guard let elemento = elemento else { return }
        title = elemento.titulo
        imgElemento.image = UIImage(named: elemento.imagen)
        lblTitulo.text = elemento.titulo
        txtDescripcion.text = elemento.descripcion
    }
}
