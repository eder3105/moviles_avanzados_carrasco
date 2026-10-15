import UIKit

/// Celda de la pantalla 2: imagen grande + título del elemento.
class ElementoTableViewCell: UITableViewCell {

    @IBOutlet weak var imgElemento: UIImageView!
    @IBOutlet weak var lblTitulo: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        imgElemento.layer.cornerRadius = 12
        imgElemento.clipsToBounds = true
        imgElemento.contentMode = .scaleAspectFill
    }

    func configurar(con elemento: Elemento) {
        lblTitulo.text = elemento.titulo
        imgElemento.image = UIImage(named: elemento.imagen)
    }
}
