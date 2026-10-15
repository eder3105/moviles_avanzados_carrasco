import UIKit

/// Celda personalizada: imagen + nombre de la cultura.
class CulturaTableViewCell: UITableViewCell {

    @IBOutlet weak var imgCultura: UIImageView!
    @IBOutlet weak var lblNombre: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        imgCultura.layer.cornerRadius = 10
        imgCultura.clipsToBounds = true
        imgCultura.contentMode = .scaleAspectFill
    }

    func configurar(con cultura: Cultura) {
        lblNombre.text = cultura.nombre
        imgCultura.image = UIImage(named: cultura.imagen)
    }
}
