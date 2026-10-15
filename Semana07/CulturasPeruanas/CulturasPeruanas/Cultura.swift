import UIKit

struct Cultura {
    let nombre: String
    let region: String
    let periodo: String
    let descripcion: String
    let simbolo: String
    let color: UIColor

    static let ejemplos: [Cultura] = [
        Cultura(
            nombre: "Cultura Caral",
            region: "Supe, costa central del Perú",
            periodo: "Aproximadamente 3000–1800 a. C.",
            descripcion: "Caral fue una de las civilizaciones más antiguas de América. Destacó por sus centros urbanos, plazas circulares y grandes construcciones ceremoniales.",
            simbolo: "sun.max.fill",
            color: UIColor(red: 0.78, green: 0.47, blue: 0.25, alpha: 1)
        ),
        Cultura(
            nombre: "Cultura Chavín",
            region: "Áncash, sierra norte",
            periodo: "Aproximadamente 1200–400 a. C.",
            descripcion: "Chavín fue un importante centro religioso y cultural. Su arte se reconoce por las figuras de felinos, aves y seres sobrenaturales tallados en piedra.",
            simbolo: "mountain.2.fill",
            color: UIColor(red: 0.32, green: 0.43, blue: 0.36, alpha: 1)
        ),
        Cultura(
            nombre: "Cultura Paracas",
            region: "Ica, costa sur",
            periodo: "Aproximadamente 700 a. C.–200 d. C.",
            descripcion: "Paracas destacó por sus textiles de gran complejidad y sus conocimientos de adaptación al ambiente desértico de la costa sur.",
            simbolo: "wind",
            color: UIColor(red: 0.70, green: 0.39, blue: 0.33, alpha: 1)
        ),
        Cultura(
            nombre: "Cultura Nazca",
            region: "Ica, costa sur",
            periodo: "Aproximadamente 100 a. C.–800 d. C.",
            descripcion: "Nazca es conocida por su cerámica policroma, sus acueductos y las famosas líneas y geoglifos trazados en el desierto.",
            simbolo: "bird.fill",
            color: UIColor(red: 0.75, green: 0.55, blue: 0.25, alpha: 1)
        ),
        Cultura(
            nombre: "Cultura Moche",
            region: "Costa norte del Perú",
            periodo: "Aproximadamente 100–800 d. C.",
            descripcion: "La sociedad Moche sobresalió por su cerámica escultórica, sus sistemas de irrigación y sus grandes complejos ceremoniales.",
            simbolo: "water.waves",
            color: UIColor(red: 0.27, green: 0.49, blue: 0.59, alpha: 1)
        ),
        Cultura(
            nombre: "Cultura Wari",
            region: "Ayacucho, sierra sur-central",
            periodo: "Aproximadamente 600–1000 d. C.",
            descripcion: "Wari desarrolló una organización política amplia, centros administrativos y una red de caminos que conectaba diferentes regiones andinas.",
            simbolo: "building.2.fill",
            color: UIColor(red: 0.48, green: 0.39, blue: 0.61, alpha: 1)
        ),
        Cultura(
            nombre: "Cultura Chimú",
            region: "La Libertad, costa norte",
            periodo: "Aproximadamente 900–1470 d. C.",
            descripcion: "Chimú tuvo como capital a Chan Chan, una extensa ciudad construida con adobe. También destacó en metalurgia y trabajos artesanales.",
            simbolo: "building.columns.fill",
            color: UIColor(red: 0.63, green: 0.43, blue: 0.30, alpha: 1)
        ),
        Cultura(
            nombre: "Cultura Inca",
            region: "Cusco y los Andes centrales",
            periodo: "Aproximadamente 1438–1533 d. C.",
            descripcion: "Los incas formaron el Tahuantinsuyo, un gran estado andino. Destacaron por su arquitectura de piedra, agricultura en terrazas y red vial.",
            simbolo: "mountain.2.circle.fill",
            color: UIColor(red: 0.68, green: 0.35, blue: 0.25, alpha: 1)
        )
    ]
}
