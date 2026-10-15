import Foundation

/// Un elemento importante de una cultura (sitio, objeto, técnica...).
struct Elemento {
    let titulo: String
    let descripcion: String
    let imagen: String   // nombre de la imagen dentro de Assets
}

/// Modelo de datos: una cultura peruana.
struct Cultura {
    let nombre: String
    let region: String
    let descripcion: String
    let imagen: String   // nombre de la imagen dentro de Assets
    let elementos: [Elemento]
}

extension Cultura {
    /// Lista de culturas que se muestra en la tabla.
    static let todas: [Cultura] = [
        Cultura(nombre: "Caral",
                region: "Valle de Supe, Lima (costa norcentral)",
                descripcion: "Considerada la civilización más antigua de América (c. 3000 a.C.). Su ciudad sagrada de Caral-Supe tiene pirámides escalonadas, plazas circulares hundidas y un avanzado manejo de la agricultura y el comercio. No se encontraron armas ni murallas, lo que sugiere una sociedad organizada en torno a la religión y la cooperación. Es Patrimonio Mundial de la UNESCO.",
                imagen: "caral",
                elementos: [
            Elemento(titulo: "Pirámide Mayor",
                     descripcion: "La Pirámide Mayor es la estructura más grande de Caral, con terrazas escalonadas y una gran escalinata central. Fue el principal centro ceremonial de la ciudad y muestra el nivel de organización que tuvo esta sociedad.",
                     imagen: "caral_1"),
            Elemento(titulo: "Anfiteatro y plazas circulares",
                     descripcion: "Las plazas circulares hundidas y el anfiteatro eran espacios para ceremonias y reuniones públicas. Estaban ligados a rituales de ofrenda y a la vida política y religiosa de la comunidad.",
                     imagen: "caral_2"),
            Elemento(titulo: "Quipu de Caral",
                     descripcion: "En las excavaciones de Caral se halló un quipu, un sistema de cuerdas anudadas usado para registrar información. Es uno de los más antiguos que se conocen y sugiere que ya existía un control de la producción y el intercambio.",
                     imagen: "caral_3")
                ]),
        Cultura(nombre: "Chavín",
                region: "Huari, Áncash (sierra norte)",
                descripcion: "Cultura formativa que floreció entre el 1200 y el 200 a.C. Su centro ceremonial, Chavín de Huántar, es famoso por sus galerías subterráneas, el Lanzón monolítico y las cabezas clavas. Su arte, con felinos, serpientes y aves estilizados, influyó en gran parte de los Andes centrales y se le llama el 'horizonte temprano'.",
                imagen: "chavin",
                elementos: [
            Elemento(titulo: "Templo de Chavín de Huántar",
                     descripcion: "Principal centro ceremonial de la cultura Chavín, en Áncash. Tiene plazas hundidas, plataformas y un templo con galerías subterráneas. Es Patrimonio Mundial de la UNESCO.",
                     imagen: "chavin_1"),
            Elemento(titulo: "El Lanzón",
                     descripcion: "Escultura monolítica de granito de unos 4,5 metros de alto, ubicada en una galería del Templo Antiguo. Representa a una deidad con rasgos humanos y de felino y era el centro de culto del templo.",
                     imagen: "chavin_2"),
            Elemento(titulo: "Cabezas clavas",
                     descripcion: "Esculturas de piedra con rostros humanos que se transforman en rasgos felinos. Estaban incrustadas en los muros del templo y muestran la iconografía religiosa de Chavín.",
                     imagen: "chavin_3")
                ]),
        Cultura(nombre: "Paracas",
                region: "Península de Paracas, Ica (costa sur)",
                descripcion: "Cultura desarrollada entre el 700 a.C. y el 200 d.C. Destaca por sus mantos funerarios bordados con vivos colores, la cerámica policroma y la práctica de la trepanación craneana. Sus fardos funerarios, hallados en la necrópolis de Wari Kayan, muestran un excepcional dominio textil.",
                imagen: "paracas",
                elementos: [
            Elemento(titulo: "Mantos de Paracas",
                     descripcion: "Grandes telas de algodón y lana de camélido, bordadas con figuras de seres míticos y colores intensos. Se usaban para envolver a los difuntos y son reconocidas por su altísima calidad.",
                     imagen: "paracas_1"),
            Elemento(titulo: "Necrópolis de Wari Kayan",
                     descripcion: "Cementerio descubierto en 1927 por Julio C. Tello en la península de Paracas. Se hallaron cientos de fardos funerarios con momias envueltas en mantos y acompañadas de ofrendas.",
                     imagen: "paracas_2"),
            Elemento(titulo: "Trepanación craneana",
                     descripcion: "Los paracas practicaron la trepanación, una cirugía que consiste en abrir una parte del cráneo. Muchos cráneos muestran signos de cicatrización, lo que indica que varios pacientes sobrevivían.",
                     imagen: "paracas_3")
                ]),
        Cultura(nombre: "Nazca",
                region: "Valles de Ica y Nazca, Ica (costa sur)",
                descripcion: "Cultura que se desarrolló entre el 100 y el 800 d.C. Es mundialmente conocida por las líneas y geoglifos de Nazca (colibrí, mono, araña), trazados sobre la pampa. Construyó acueductos subterráneos llamados puquios y produjo cerámica polícroma de gran calidad. Las Líneas de Nazca son Patrimonio Mundial de la UNESCO.",
                imagen: "nazca",
                elementos: [
            Elemento(titulo: "Líneas de Nazca",
                     descripcion: "Enormes geoglifos trazados en la pampa entre Nazca y Palpa: figuras de animales como el colibrí, el mono y la araña, además de líneas rectas. Son Patrimonio Mundial desde 1994.",
                     imagen: "nazca_1"),
            Elemento(titulo: "Acueductos de Cantalloc",
                     descripcion: "Los puquios son galerías subterráneas con aberturas en espiral que captan agua y la llevan a los campos. Muestran la ingeniería hidráulica nazca y aún se usan en la zona.",
                     imagen: "nazca_2"),
            Elemento(titulo: "Cerámica nazca",
                     descripcion: "Cerámica polícroma pintada antes de la cocción, con muchos colores. Representa animales, plantas, seres míticos y cabezas trofeo.",
                     imagen: "nazca_3")
                ]),
        Cultura(nombre: "Moche",
                region: "Valles de Moche y Chicama, La Libertad y Lambayeque (costa norte)",
                descripcion: "Cultura que floreció del 100 al 800 d.C. Fueron grandes metalurgistas y ceramistas: sus huacos retrato y escenas rituales son muy realistas. Construyeron las Huacas del Sol y de la Luna y el complejo de El Brujo. El hallazgo del Señor de Sipán mostró el esplendor de su orfebrería en oro, plata y cobre.",
                imagen: "moche",
                elementos: [
            Elemento(titulo: "Huaca del Sol y de la Luna",
                     descripcion: "Complejo de templos de adobe cerca de Trujillo. La Huaca de la Luna conserva murales con relieves policromos. Eran el centro político y religioso de los moche.",
                     imagen: "moche_1"),
            Elemento(titulo: "Señor de Sipán",
                     descripcion: "Tumba real descubierta en 1987 por Walter Alva en Huaca Rajada, Lambayeque. Contenía ornamentos de oro, plata y turquesa, y es uno de los hallazgos más importantes de la arqueología americana.",
                     imagen: "moche_2"),
            Elemento(titulo: "Huacos retrato",
                     descripcion: "Vasijas de cerámica que reproducen con gran realismo rostros de personas. Permiten conocer expresiones, peinados y adornos de los moche.",
                     imagen: "moche_3")
                ]),
        Cultura(nombre: "Wari",
                region: "Ayacucho (sierra sur)",
                descripcion: "Imperio andino que se expandió entre el 600 y el 1000 d.C. Su capital, Wari, cerca de Ayacucho, fue una de las primeras grandes ciudades urbanas de los Andes. Desarrollaron una compleja red de caminos, terrazas agrícolas y una administración estatal que luego fue heredada por los incas. Su iconografía y sus textiles fueron muy influyentes.",
                imagen: "wari",
                elementos: [
            Elemento(titulo: "Ciudad de Wari",
                     descripcion: "Capital del imperio Wari, cerca de Ayacucho. Fue una de las ciudades más grandes de los Andes de su época, con recintos amurallados y edificios de varios pisos.",
                     imagen: "wari_1"),
            Elemento(titulo: "Túnicas wari",
                     descripcion: "Túnicas de lana de camélido con diseños geométricos y figuras de seres con báculos. Los textiles eran símbolo de prestigio y poder.",
                     imagen: "wari_2"),
            Elemento(titulo: "Terrazas agrícolas",
                     descripcion: "Los wari construyeron andenes y canales para cultivar en las laderas. Esta técnica se extendió por los Andes y fue aprovechada luego por los incas.",
                     imagen: "wari_3")
                ]),
        Cultura(nombre: "Chimú",
                region: "Chan Chan, La Libertad (costa norte)",
                descripcion: "Reino que dominó la costa norte entre el 900 y el 1470 d.C. Su capital, Chan Chan, es la ciudad de adobe más grande de América y Patrimonio Mundial de la UNESCO. Sus muros están decorados con relieves de peces, aves y olas. Fueron expertos orfebres y construyeron grandes canales de riego. Fueron conquistados por los incas.",
                imagen: "chimu",
                elementos: [
            Elemento(titulo: "Chan Chan",
                     descripcion: "Capital chimú cerca de Trujillo, formada por grandes ciudadelas de adobe con relieves de peces, aves y olas. Es la ciudad de adobe más grande de América y Patrimonio Mundial.",
                     imagen: "chimu_1"),
            Elemento(titulo: "Palacio Tschudi",
                     descripcion: "Una de las ciudadelas mejor conservadas de Chan Chan. Tiene patios, corredores y paneles decorados con relieves de motivos marinos.",
                     imagen: "chimu_2"),
            Elemento(titulo: "Orfebrería chimú",
                     descripcion: "Trabajaron oro, plata y cobre con técnicas como el laminado, el repujado y el vaciado. Producían vasos ceremoniales, máscaras y adornos para la élite.",
                     imagen: "chimu_3")
                ]),
        Cultura(nombre: "Inca",
                region: "Cusco (sierra sur), con presencia en todo el Tahuantinsuyo",
                descripcion: "El mayor imperio de la América precolombina (siglos XV-XVI), con capital en el Cusco. Se organizó en cuatro suyos y se articuló mediante el Qhapaq Ñan, una extensa red de caminos. Sobresalieron en arquitectura de piedra, como Machu Picchu y Sacsayhuamán, en ingeniería agrícola con andenes y en el uso de quipus para registrar información.",
                imagen: "inca",
                elementos: [
            Elemento(titulo: "Machu Picchu",
                     descripcion: "Ciudadela inca del siglo XV, en Cusco, a unos 2400 m s. n. m. Es Patrimonio Mundial y una de las Nuevas Siete Maravillas del Mundo.",
                     imagen: "inca_1"),
            Elemento(titulo: "Sacsayhuamán",
                     descripcion: "Fortaleza ceremonial sobre el Cusco, con enormes muros de piedra ajustados sin mortero. Hoy es escenario de la fiesta del Inti Raymi.",
                     imagen: "inca_2"),
            Elemento(titulo: "Qhapaq Ñan",
                     descripcion: "Red vial inca de más de 30 000 km que atravesaba seis países andinos. Conectaba el Cusco con todo el Tahuantinsuyo y fue declarada Patrimonio Mundial en 2014.",
                     imagen: "inca_3")
                ])
    ]
}
