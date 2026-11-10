import UIKit

// Gráfico de barras sencillo dibujado a mano (sin librerías).
// La última barra (hoy) va en azul intenso; las demás en azul suave.
class GraficoBarras: UIView {

    var etiquetas: [String] = []
    var valores: [Double] = [] {
        didSet { setNeedsDisplay() } // vuelve a dibujar cuando cambian los datos
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        contentMode = .redraw
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) no se usa")
    }

    override func draw(_ rect: CGRect) {
        guard !valores.isEmpty else { return }
        let area = rect.insetBy(dx: 2, dy: 2)
        let maximo = max(valores.max() ?? 0, 1)
        let anchoColumna = area.width / CGFloat(valores.count)
        let altoTexto: CGFloat = 16
        let altoUtil = area.height - altoTexto * 2
        let atributos: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 10),
                                                         .foregroundColor: UIColor.secondaryLabel]

        for (i, valor) in valores.enumerated() {
            let alto = max(CGFloat(valor / maximo) * altoUtil, 2)
            let x = area.minX + CGFloat(i) * anchoColumna + anchoColumna * 0.18
            let anchoBarra = anchoColumna * 0.64
            let barra = CGRect(x: x, y: area.minY + altoTexto + altoUtil - alto, width: anchoBarra, height: alto)
            let esHoy = i == valores.count - 1
            (esHoy ? Tema.principal : Tema.principal.withAlphaComponent(0.35)).setFill()
            UIBezierPath(roundedRect: barra, cornerRadius: 5).fill()

            // Monto encima de la barra
            if valor > 0 {
                let texto = String(format: "%.0f", valor) as NSString
                let medida = texto.size(withAttributes: atributos)
                texto.draw(at: CGPoint(x: x + (anchoBarra - medida.width) / 2, y: barra.minY - altoTexto + 2),
                           withAttributes: atributos)
            }
            // Día debajo
            if i < etiquetas.count {
                let dia = etiquetas[i] as NSString
                let medida = dia.size(withAttributes: atributos)
                dia.draw(at: CGPoint(x: x + (anchoBarra - medida.width) / 2, y: area.maxY - altoTexto + 2),
                         withAttributes: atributos)
            }
        }
    }
}
