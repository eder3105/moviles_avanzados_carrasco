import UIKit

final class DetalleCulturaViewController: UIViewController {
    private let cultura: Cultura

    init(cultura: Cultura) {
        self.cultura = cultura
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) no está implementado")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Detalle"
        construirVista()
    }

    private func construirVista() {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        let contenido = UIStackView()
        contenido.axis = .vertical
        contenido.spacing = 18
        contenido.alignment = .fill
        contenido.translatesAutoresizingMaskIntoConstraints = false

        let imagenFondo = UIView()
        imagenFondo.backgroundColor = cultura.color.withAlphaComponent(0.14)
        imagenFondo.layer.cornerRadius = 22
        imagenFondo.heightAnchor.constraint(equalToConstant: 220).isActive = true

        let imagen = UIImageView(image: UIImage(systemName: cultura.simbolo))
        imagen.translatesAutoresizingMaskIntoConstraints = false
        imagen.tintColor = cultura.color
        imagen.contentMode = .scaleAspectFit
        imagen.preferredSymbolConfiguration = UIImage.SymbolConfiguration(pointSize: 100, weight: .regular)
        imagenFondo.addSubview(imagen)
        NSLayoutConstraint.activate([
            imagen.centerXAnchor.constraint(equalTo: imagenFondo.centerXAnchor),
            imagen.centerYAnchor.constraint(equalTo: imagenFondo.centerYAnchor),
            imagen.widthAnchor.constraint(equalToConstant: 160),
            imagen.heightAnchor.constraint(equalToConstant: 150)
        ])

        let nombre = UILabel()
        nombre.text = cultura.nombre
        nombre.font = .systemFont(ofSize: 28, weight: .bold)
        nombre.numberOfLines = 0

        let region = crearEtiqueta(titulo: "Región", texto: cultura.region)
        let periodo = crearEtiqueta(titulo: "Periodo histórico", texto: cultura.periodo)
        let descripcion = crearEtiqueta(titulo: "Descripción", texto: cultura.descripcion)

        contenido.addArrangedSubview(imagenFondo)
        contenido.addArrangedSubview(nombre)
        contenido.addArrangedSubview(region)
        contenido.addArrangedSubview(periodo)
        contenido.addArrangedSubview(descripcion)

        view.addSubview(scroll)
        scroll.addSubview(contenido)

        NSLayoutConstraint.activate([
            scroll.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scroll.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contenido.topAnchor.constraint(equalTo: scroll.contentLayoutGuide.topAnchor, constant: 20),
            contenido.leadingAnchor.constraint(equalTo: scroll.frameLayoutGuide.leadingAnchor, constant: 22),
            contenido.trailingAnchor.constraint(equalTo: scroll.frameLayoutGuide.trailingAnchor, constant: -22),
            contenido.bottomAnchor.constraint(equalTo: scroll.contentLayoutGuide.bottomAnchor, constant: -28)
        ])
    }

    private func crearEtiqueta(titulo: String, texto: String) -> UIStackView {
        let encabezado = UILabel()
        encabezado.text = titulo
        encabezado.font = .systemFont(ofSize: 17, weight: .semibold)
        encabezado.textColor = .secondaryLabel

        let detalle = UILabel()
        detalle.text = texto
        detalle.font = .systemFont(ofSize: 17)
        detalle.numberOfLines = 0

        let grupo = UIStackView(arrangedSubviews: [encabezado, detalle])
        grupo.axis = .vertical
        grupo.spacing = 6
        return grupo
    }
}
