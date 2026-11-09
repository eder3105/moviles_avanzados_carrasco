import UIKit

// Gráfico de barras sencillo dibujado a mano (sin librerías)
class GraficoBarras: UIView {

    var etiquetas: [String] = []
    var valores: [Double] = [] {
        didSet { setNeedsDisplay() } // vuelve a dibujar cuando cambian los datos
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 12
        contentMode = .redraw
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) no se usa")
    }

    override func draw(_ rect: CGRect) {
        guard !valores.isEmpty else { return }
        let area = rect.insetBy(dx: 8, dy: 4)
        let maximo = max(valores.max() ?? 0, 1)
        let anchoColumna = area.width / CGFloat(valores.count)
        let altoTexto: CGFloat = 16
        let altoUtil = area.height - altoTexto * 2
        let atributos: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 10),
                                                         .foregroundColor: UIColor.secondaryLabel]

        for (i, valor) in valores.enumerated() {
            let alto = CGFloat(valor / maximo) * altoUtil
            let x = area.minX + CGFloat(i) * anchoColumna + anchoColumna * 0.15
            let barra = CGRect(x: x, y: area.minY + altoTexto + altoUtil - alto,
                               width: anchoColumna * 0.7, height: alto)
            UIColor.systemBlue.setFill()
            UIBezierPath(roundedRect: barra, cornerRadius: 4).fill()

            // Monto encima de la barra
            (String(format: "%.0f", valor) as NSString)
                .draw(at: CGPoint(x: x, y: barra.minY - altoTexto + 2), withAttributes: atributos)
            // Día debajo
            if i < etiquetas.count {
                (etiquetas[i] as NSString)
                    .draw(at: CGPoint(x: x, y: area.maxY - altoTexto + 2), withAttributes: atributos)
            }
        }
    }
}
