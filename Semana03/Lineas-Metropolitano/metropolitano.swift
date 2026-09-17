import Foundation

// ===== ESTRUCTURA =====
struct Estacion {
    let nombre: String
    let linea: String
    let tieneAscensor: Bool
    let viasCercanas: [String]
    let conectaMetropolitano: String?
}

// ===== DICCIONARIO 1: Estaciones por línea =====
// ★ Ahora es "var" (antes "let") porque el admin necesita poder
// agregar estaciones nuevas o crear líneas nuevas en tiempo de ejecución.
var estacionesPorLinea: [String: [String]] = [
    "Línea 1": ["Villa El Salvador", "Parque Industrial", "Pumacahua", "Villa María",
                 "María Auxiliadora", "San Juan", "Atocongo", "Jorge Chávez", "Ayacucho",
                 "Cabitos", "Angamos", "San Borja Sur", "La Cultura", "Arriola", "Gamarra",
                 "Miguel Grau", "El Ángel", "Presbítero Maestro", "Caja de Agua",
                 "Pirámide del Sol", "Los Jardines", "Los Postes", "San Carlos",
                 "San Martín", "Santa Rosa", "Bayóvar"],
    "Línea 2": ["Evitamiento", "Óvalo Santa Anita", "Colectora Industrial",
                 "Hermilio Valdizán", "Mercado Santa Anita"],
    "Línea 3": ["El Álamo", "Huandoy", "2 de Octubre", "Villa Sol", "Naranjal",
                 "Carlos Izaguirre", "Tomás Valle", "Bartolomé de las Casas", "José Granda",
                 "Caquetá", "Tacna", "Garcilaso de la Vega", "Estación Central",
                 "Parque de la Reserva", "Museo de Historia Natural", "César Canevaro",
                 "Conde de San Isidro", "Andrés Aramburú", "Huaca Pucllana",
                 "Parque Central de Miraflores", "Parque Reducto", "República de Panamá",
                 "Juana Alarco", "Cabitos (L3)", "Alejandro Velasco", "Las Gardenias",
                 "Los Héroes", "Pedro Miotta"]
]

// ===== DICCIONARIO 2: Detalle completo de cada estación =====
// ★ "var" en vez de "let" por el mismo motivo (admin agrega/edita).
var detalleEstaciones: [String: Estacion] = [
    // ---------- LÍNEA 1 ----------
    "Villa El Salvador": Estacion(nombre: "Villa El Salvador", linea: "Línea 1", tieneAscensor: true, viasCercanas: ["Av. Pastor Sevilla"], conectaMetropolitano: nil),
    "Parque Industrial": Estacion(nombre: "Parque Industrial", linea: "Línea 1", tieneAscensor: true, viasCercanas: ["Av. Los Héroes"], conectaMetropolitano: nil),
    "Pumacahua": Estacion(nombre: "Pumacahua", linea: "Línea 1", tieneAscensor: false, viasCercanas: ["Av. Pumacahua"], conectaMetropolitano: nil),
    "Villa María": Estacion(nombre: "Villa María", linea: "Línea 1", tieneAscensor: true, viasCercanas: ["Av. San Martín"], conectaMetropolitano: nil),
    "María Auxiliadora": Estacion(nombre: "María Auxiliadora", linea: "Línea 1", tieneAscensor: false, viasCercanas: ["Av. San Juan"], conectaMetropolitano: nil),
    "San Juan": Estacion(nombre: "San Juan", linea: "Línea 1", tieneAscensor: true, viasCercanas: ["Av. San Juan", "Av. Pachacútec"], conectaMetropolitano: nil),
    "Atocongo": Estacion(nombre: "Atocongo", linea: "Línea 1", tieneAscensor: true, viasCercanas: ["Av. Los Héroes", "Panamericana Sur"], conectaMetropolitano: nil),
    "Jorge Chávez": Estacion(nombre: "Jorge Chávez", linea: "Línea 1", tieneAscensor: false, viasCercanas: ["Av. Circunvalación"], conectaMetropolitano: nil),
    "Ayacucho": Estacion(nombre: "Ayacucho", linea: "Línea 1", tieneAscensor: true, viasCercanas: ["Av. Ayacucho"], conectaMetropolitano: nil),
    "Cabitos": Estacion(nombre: "Cabitos", linea: "Línea 1", tieneAscensor: false, viasCercanas: ["Av. Aviación"], conectaMetropolitano: nil),
    "Angamos": Estacion(nombre: "Angamos", linea: "Línea 1", tieneAscensor: true, viasCercanas: ["Av. Angamos", "Av. Aviación"], conectaMetropolitano: nil),
    "San Borja Sur": Estacion(nombre: "San Borja Sur", linea: "Línea 1", tieneAscensor: true, viasCercanas: ["Av. San Borja Sur"], conectaMetropolitano: nil),
    "La Cultura": Estacion(nombre: "La Cultura", linea: "Línea 1", tieneAscensor: true, viasCercanas: ["Av. Javier Prado", "Av. Aviación"], conectaMetropolitano: "Sí, conexión con el Metropolitano (Corpac)"),
    "Arriola": Estacion(nombre: "Arriola", linea: "Línea 1", tieneAscensor: true, viasCercanas: ["Av. Aviación"], conectaMetropolitano: nil),
    "Gamarra": Estacion(nombre: "Gamarra", linea: "Línea 1", tieneAscensor: true, viasCercanas: ["Av. Aviación", "Jr. Gamarra"], conectaMetropolitano: nil),
    "Miguel Grau": Estacion(nombre: "Miguel Grau", linea: "Línea 1", tieneAscensor: true, viasCercanas: ["Av. Grau"], conectaMetropolitano: nil),
    "El Ángel": Estacion(nombre: "El Ángel", linea: "Línea 1", tieneAscensor: false, viasCercanas: ["Av. Circunvalación"], conectaMetropolitano: nil),
    "Presbítero Maestro": Estacion(nombre: "Presbítero Maestro", linea: "Línea 1", tieneAscensor: false, viasCercanas: ["Av. Locumba"], conectaMetropolitano: nil),
    "Caja de Agua": Estacion(nombre: "Caja de Agua", linea: "Línea 1", tieneAscensor: true, viasCercanas: ["Av. Próceres de la Independencia"], conectaMetropolitano: nil),
    "Pirámide del Sol": Estacion(nombre: "Pirámide del Sol", linea: "Línea 1", tieneAscensor: true, viasCercanas: ["Av. Próceres de la Independencia"], conectaMetropolitano: nil),
    "Los Jardines": Estacion(nombre: "Los Jardines", linea: "Línea 1", tieneAscensor: false, viasCercanas: ["Av. Los Jardines"], conectaMetropolitano: nil),
    "Los Postes": Estacion(nombre: "Los Postes", linea: "Línea 1", tieneAscensor: true, viasCercanas: ["Av. Próceres de la Independencia"], conectaMetropolitano: nil),
    "San Carlos": Estacion(nombre: "San Carlos", linea: "Línea 1", tieneAscensor: true, viasCercanas: ["Av. El Sol"], conectaMetropolitano: nil),
    "San Martín": Estacion(nombre: "San Martín", linea: "Línea 1", tieneAscensor: false, viasCercanas: ["Av. San Martín"], conectaMetropolitano: nil),
    "Santa Rosa": Estacion(nombre: "Santa Rosa", linea: "Línea 1", tieneAscensor: true, viasCercanas: ["Av. Santa Rosa"], conectaMetropolitano: nil),
    "Bayóvar": Estacion(nombre: "Bayóvar", linea: "Línea 1", tieneAscensor: true, viasCercanas: ["Av. Próceres de la Independencia"], conectaMetropolitano: nil),
    // ---------- LÍNEA 2 ----------
    "Evitamiento": Estacion(nombre: "Evitamiento", linea: "Línea 2", tieneAscensor: true, viasCercanas: ["Vía de Evitamiento"], conectaMetropolitano: nil),
    "Óvalo Santa Anita": Estacion(nombre: "Óvalo Santa Anita", linea: "Línea 2", tieneAscensor: true, viasCercanas: ["Óvalo Santa Anita"], conectaMetropolitano: nil),
    "Colectora Industrial": Estacion(nombre: "Colectora Industrial", linea: "Línea 2", tieneAscensor: true, viasCercanas: ["Av. Colectora Industrial"], conectaMetropolitano: nil),
    "Hermilio Valdizán": Estacion(nombre: "Hermilio Valdizán", linea: "Línea 2", tieneAscensor: true, viasCercanas: ["Av. Hermilio Valdizán"], conectaMetropolitano: nil),
    "Mercado Santa Anita": Estacion(nombre: "Mercado Santa Anita", linea: "Línea 2", tieneAscensor: true, viasCercanas: ["Av. Los Postes"], conectaMetropolitano: nil),
    // ---------- LÍNEA 3 (proyecto) ----------
    "El Álamo": Estacion(nombre: "El Álamo", linea: "Línea 3", tieneAscensor: true, viasCercanas: ["Comas"], conectaMetropolitano: nil),
    "Huandoy": Estacion(nombre: "Huandoy", linea: "Línea 3", tieneAscensor: true, viasCercanas: ["Comas"], conectaMetropolitano: nil),
    "2 de Octubre": Estacion(nombre: "2 de Octubre", linea: "Línea 3", tieneAscensor: true, viasCercanas: ["Av. 2 de Octubre"], conectaMetropolitano: nil),
    "Villa Sol": Estacion(nombre: "Villa Sol", linea: "Línea 3", tieneAscensor: true, viasCercanas: ["Los Olivos"], conectaMetropolitano: nil),
    "Naranjal": Estacion(nombre: "Naranjal", linea: "Línea 3", tieneAscensor: true, viasCercanas: ["Av. Naranjal"], conectaMetropolitano: "Estación Naranjal (Metropolitano)"),
    "Carlos Izaguirre": Estacion(nombre: "Carlos Izaguirre", linea: "Línea 3", tieneAscensor: true, viasCercanas: ["Av. Carlos Izaguirre"], conectaMetropolitano: nil),
    "Tomás Valle": Estacion(nombre: "Tomás Valle", linea: "Línea 3", tieneAscensor: true, viasCercanas: ["Av. Tomás Valle"], conectaMetropolitano: "Estación Tomás Valle (Metropolitano)"),
    "Bartolomé de las Casas": Estacion(nombre: "Bartolomé de las Casas", linea: "Línea 3", tieneAscensor: true, viasCercanas: ["Independencia"], conectaMetropolitano: nil),
    "José Granda": Estacion(nombre: "José Granda", linea: "Línea 3", tieneAscensor: true, viasCercanas: ["San Martín de Porres"], conectaMetropolitano: nil),
    "Caquetá": Estacion(nombre: "Caquetá", linea: "Línea 3", tieneAscensor: true, viasCercanas: ["Av. Caquetá"], conectaMetropolitano: nil),
    "Tacna": Estacion(nombre: "Tacna", linea: "Línea 3", tieneAscensor: true, viasCercanas: ["Av. Tacna", "Cercado de Lima"], conectaMetropolitano: nil),
    "Garcilaso de la Vega": Estacion(nombre: "Garcilaso de la Vega", linea: "Línea 3", tieneAscensor: true, viasCercanas: ["Av. Garcilaso de la Vega"], conectaMetropolitano: nil),
    "Estación Central": Estacion(nombre: "Estación Central", linea: "Línea 3", tieneAscensor: true, viasCercanas: ["Av. Paseo Colón"], conectaMetropolitano: "Sí, interconexión con Línea 2 (futura) y Metropolitano"),
    "Parque de la Reserva": Estacion(nombre: "Parque de la Reserva", linea: "Línea 3", tieneAscensor: true, viasCercanas: ["Cercado de Lima"], conectaMetropolitano: nil),
    "Museo de Historia Natural": Estacion(nombre: "Museo de Historia Natural", linea: "Línea 3", tieneAscensor: true, viasCercanas: ["Jesús María"], conectaMetropolitano: nil),
    "César Canevaro": Estacion(nombre: "César Canevaro", linea: "Línea 3", tieneAscensor: true, viasCercanas: ["Lince"], conectaMetropolitano: nil),
    "Conde de San Isidro": Estacion(nombre: "Conde de San Isidro", linea: "Línea 3", tieneAscensor: true, viasCercanas: ["San Isidro"], conectaMetropolitano: nil),
    "Andrés Aramburú": Estacion(nombre: "Andrés Aramburú", linea: "Línea 3", tieneAscensor: true, viasCercanas: ["San Isidro"], conectaMetropolitano: nil),
    "Huaca Pucllana": Estacion(nombre: "Huaca Pucllana", linea: "Línea 3", tieneAscensor: true, viasCercanas: ["Av. Arequipa", "Miraflores"], conectaMetropolitano: nil),
    "Parque Central de Miraflores": Estacion(nombre: "Parque Central de Miraflores", linea: "Línea 3", tieneAscensor: true, viasCercanas: ["Miraflores"], conectaMetropolitano: nil),
    "Parque Reducto": Estacion(nombre: "Parque Reducto", linea: "Línea 3", tieneAscensor: true, viasCercanas: ["Miraflores"], conectaMetropolitano: nil),
    "República de Panamá": Estacion(nombre: "República de Panamá", linea: "Línea 3", tieneAscensor: true, viasCercanas: ["Av. República de Panamá"], conectaMetropolitano: "Estación Panamá (Metropolitano)"),
    "Juana Alarco": Estacion(nombre: "Juana Alarco", linea: "Línea 3", tieneAscensor: true, viasCercanas: ["Miraflores"], conectaMetropolitano: nil),
    "Cabitos (L3)": Estacion(nombre: "Cabitos (L3)", linea: "Línea 3", tieneAscensor: true, viasCercanas: ["Miraflores"], conectaMetropolitano: "Interconexión con estación Cabitos de Línea 1"),
    "Alejandro Velasco": Estacion(nombre: "Alejandro Velasco", linea: "Línea 3", tieneAscensor: true, viasCercanas: ["Surquillo"], conectaMetropolitano: nil),
    "Las Gardenias": Estacion(nombre: "Las Gardenias", linea: "Línea 3", tieneAscensor: true, viasCercanas: ["Santiago de Surco"], conectaMetropolitano: nil),
    "Los Héroes": Estacion(nombre: "Los Héroes", linea: "Línea 3", tieneAscensor: true, viasCercanas: ["Av. Los Héroes", "Santiago de Surco"], conectaMetropolitano: nil),
    "Pedro Miotta": Estacion(nombre: "Pedro Miotta", linea: "Línea 3", tieneAscensor: true, viasCercanas: ["San Juan de Miraflores"], conectaMetropolitano: nil)
]

// ===== DICCIONARIO 3: Conexiones con el Metropolitano =====
var conexionesMetropolitano: [String: String] = [
    "La Cultura": "Estación Corpac (Metropolitano) — Línea 1",
    "Naranjal": "Estación Naranjal (Metropolitano) — Línea 3 (proyecto)",
    "Tomás Valle": "Estación Tomás Valle (Metropolitano) — Línea 3 (proyecto)",
    "Estación Central": "Estación Central (Metropolitano) — Línea 2 y Línea 3 (proyecto)",
    "República de Panamá": "Estación Panamá (Metropolitano) — Línea 3 (proyecto)"
]

// ===== DICCIONARIO ADICIONAL: Interconexiones entre líneas =====
let interconexionesEntreLineas: [String: String] = [
    "Estación Central": "Interconexión entre Línea 2 y Línea 3",
    "Cabitos / Cabitos (L3)": "Interconexión entre Línea 1 y Línea 3"
]

// ============================================================
// ★★★ NUEVO 1: PUNTOS DE INTERÉS CERCANOS A CADA ESTACIÓN ★★★
// Pedido del docente: "qué encuentra la gente al llegar a una estación".
// Es un diccionario aparte (no se tocó el struct Estacion) para no
// reescribir las 59 estaciones ya existentes. Está simulado con fines
// académicos, igual que los ascensores y las vías cercanas.
// El admin puede agregar más puntos desde el modo administrador.
// ============================================================
var puntosDeInteresPorEstacion: [String: [String]] = [
    "La Cultura": ["Museo de la Nación", "Universidad Ricardo Palma"],
    "Angamos": ["Real Plaza Primavera", "Clínica Angamos"],
    "Gamarra": ["Emporio Comercial Gamarra"],
    "Tacna": ["Hospital 2 de Mayo", "Parque de la Muralla"],
    "Huaca Pucllana": ["Huaca Pucllana (sitio arqueológico)", "Óvalo Gutiérrez"],
    "Parque Central de Miraflores": ["Parque Kennedy", "Municipalidad de Miraflores"],
    "Estación Central": ["Palacio de Justicia", "Parque Universitario"],
    "Óvalo Santa Anita": ["Mercado Mayorista de Santa Anita"],
    "San Borja Sur": ["Centro Comercial San Borja Plaza"],
    "Caja de Agua": ["Hospital de San Juan de Lurigancho"]
]

// ============================================================
// ★★★ NUEVO 2: TIEMPO ENTRE ESTACIONES CONSECUTIVAS ★★★
// Pedido del docente: "cuánto me falta para llegar a la siguiente estación".
// Clave = "EstacionOrigen-EstacionSiguiente", valor = minutos.
// Si un tramo no está en el diccionario, se simula con 3 minutos por
// defecto (mismo criterio que los datos simulados de ascensores).
// ============================================================
var tiemposEntreEstaciones: [String: Int] = [
    "Villa El Salvador-Parque Industrial": 2,
    "Parque Industrial-Pumacahua": 2,
    "La Cultura-Arriola": 3,
    "Angamos-San Borja Sur": 2,
    "Estación Central-Parque de la Reserva": 2
]
let minutosPorDefecto = 3 // tramo simulado cuando no hay dato específico

// ============================================================
// ★★★ NUEVO 3 (parte A): TARJETA DE TRANSPORTE ★★★
// Simula saldo, recarga y cobro de pasaje.
// ============================================================
class TarjetaTransporte {
    private(set) var saldo: Double
    let tarifa: Double = 2.50 // tarifa fija simulada del pasaje

    init(saldoInicial: Double = 5.0) {
        self.saldo = saldoInicial
    }

    func recargar(monto: Double) {
        saldo += monto
    }

    // Devuelve true si el cobro fue exitoso (había saldo suficiente)
    func pagarPasaje() -> Bool {
        if saldo >= tarifa {
            saldo -= tarifa
            return true
        }
        return false
    }
}
var tarjetaUsuario = TarjetaTransporte() // instancia global simulada

// ===== FUNCIÓN CLAVE: Normalizar texto para búsquedas flexibles =====
func normalizar(_ texto: String) -> String {
    let sinTildes = texto.folding(options: .diacriticInsensitive, locale: .current)
    return sinTildes.lowercased().replacingOccurrences(of: " ", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
}

// Diccionarios normalizados
// ★ Ahora son "var" y se recalculan con actualizarNormalizados()
// cada vez que el admin agrega una línea o estación nueva.
var lineasNormalizadas: [String: String] = Dictionary(uniqueKeysWithValues: estacionesPorLinea.keys.map { (normalizar($0), $0) })
var estacionesNormalizadas: [String: String] = Dictionary(uniqueKeysWithValues: detalleEstaciones.keys.map { (normalizar($0), $0) })

// ★ NUEVO: recalcula los diccionarios normalizados tras un cambio del admin
func actualizarNormalizados() {
    lineasNormalizadas = Dictionary(uniqueKeysWithValues: estacionesPorLinea.keys.map { (normalizar($0), $0) })
    estacionesNormalizadas = Dictionary(uniqueKeysWithValues: detalleEstaciones.keys.map { (normalizar($0), $0) })
}

// ===== FUNCIONES DE SELECCIÓN GUIADA =====
func seleccionarLinea() -> String? {
    print("\n  ¿A qué línea pertenece?")
    let lineasDisponibles = Array(estacionesPorLinea.keys) // ★ ahora dinámico (por si el admin crea líneas nuevas)
    for (i, l) in lineasDisponibles.enumerated() {
        print("    \(i + 1) · \(l)")
    }
    print("  ➤ ", terminator: "")
    if let entrada = readLine(), let indice = Int(entrada), indice >= 1, indice <= lineasDisponibles.count {
        return lineasDisponibles[indice - 1]
    } else {
        print("  ⚠️ Línea no válida.")
        return nil
    }
}

func seleccionarEstacion(titulo: String) -> String? {
    print("\n  \(titulo)")
    guard let linea = seleccionarLinea(), let estaciones = estacionesPorLinea[linea] else {
        return nil
    }
    lineaSeparadora()
    print("  Estaciones de \(linea):")
    for (index, estacion) in estaciones.enumerated() {
        print("    [\(index + 1)] \(estacion)")
    }
    lineaSeparadora()
    print("  Elige el número de la estación:")
    print("  ➤ ", terminator: "")
    if let entrada = readLine(), let indice = Int(entrada), indice >= 1, indice <= estaciones.count {
        return estaciones[indice - 1]
    } else {
        print("  ⚠️ Número de estación no válido.")
        return nil
    }
}

// ===== FUNCIONES DE CONSULTA =====
func mostrarEstacionesDeLinea(_ entrada: String) {
    let clave = normalizar(entrada)
    if let lineaReal = lineasNormalizadas[clave], let estaciones = estacionesPorLinea[lineaReal] {
        print("Estaciones de \(lineaReal):")
        for estacion in estaciones {
            print("  - \(estacion)")
        }
    } else {
        print("Línea no encontrada. Prueba escribiendo: Línea 1, Línea 2 o Línea 3")
    }
}

func buscarInfoEstacion(_ entrada: String) {
    let clave = normalizar(entrada)
    if let nombreReal = estacionesNormalizadas[clave], let info = detalleEstaciones[nombreReal] {
        print("Estación: \(info.nombre)")
        print("Línea: \(info.linea)")
        print("¿Tiene ascensor?: \(info.tieneAscensor ? "Sí" : "No")")
        print("Vías cercanas: \(info.viasCercanas.joined(separator: ", "))")
        if let conexion = info.conectaMetropolitano {
            print("Conexión Metropolitano: \(conexion)")
        } else {
            print("No conecta directamente con el Metropolitano.")
        }
        // ★ NUEVO 1: mostrar puntos de interés cercanos
        let puntos = puntosDeInteresPorEstacion[nombreReal] ?? []
        if puntos.isEmpty {
            print("Puntos de interés cercanos: sin datos registrados aún.")
        } else {
            print("Puntos de interés cercanos: \(puntos.joined(separator: ", "))")
        }
        // ★ NUEVO 2: mostrar tiempo a la siguiente estación
        print(tiempoASiguienteEstacion(nombreReal))
    } else {
        print("Estación no encontrada en la base de datos.")
    }
}

// ★ NUEVO 2: calcula el tiempo hasta la siguiente estación de la misma línea
func tiempoASiguienteEstacion(_ nombreEstacion: String) -> String {
    guard let info = detalleEstaciones[nombreEstacion],
          let estaciones = estacionesPorLinea[info.linea],
          let idx = estaciones.firstIndex(of: nombreEstacion) else {
        return "No se pudo calcular el tiempo a la siguiente estación."
    }
    if idx == estaciones.count - 1 {
        return "\(nombreEstacion) es la última estación de \(info.linea)."
    }
    let siguiente = estaciones[idx + 1]
    let minutos = tiemposEntreEstaciones["\(nombreEstacion)-\(siguiente)"] ?? minutosPorDefecto
    return "Tiempo estimado hasta \(siguiente): \(minutos) min (simulado)."
}

// ===== PLANIFICADOR DE RUTAS =====
func planearRuta(_ origenEntrada: String, _ destinoEntrada: String) {
    let claveOrigen = normalizar(origenEntrada)
    let claveDestino = normalizar(destinoEntrada)

    guard let nombreOrigen = estacionesNormalizadas[claveOrigen],
          let origen = detalleEstaciones[nombreOrigen] else {
        print("No se encontró la estación de origen.")
        return
    }
    guard let nombreDestino = estacionesNormalizadas[claveDestino],
          let destino = detalleEstaciones[nombreDestino] else {
        print("No se encontró la estación de destino.")
        return
    }

    if origen.linea == destino.linea {
        print("Toma la \(origen.linea) directamente: \(origen.nombre) → \(destino.nombre)")
        // ★ NUEVO 3: cuántas estaciones faltan para llegar
        let faltan = estacionesEntre(nombreOrigen, nombreDestino, linea: origen.linea)
        print("Te faltan \(faltan) estación(es) para llegar a tu destino.")
    } else {
        var transbordoEncontrado = false
        for (estacion, descripcion) in interconexionesEntreLineas {
            if descripcion.contains(origen.linea) && descripcion.contains(destino.linea) {
                print("Ruta sugerida:")
                print("  1. Toma \(origen.linea) desde \(origen.nombre) hasta \(estacion)")
                print("  2. Haz transbordo en \(estacion)")
                print("  3. Continúa en \(destino.linea) hasta \(destino.nombre)")
                // ★ NUEVO 3: conteo de estaciones en cada tramo
                let tramo1 = estacionesEntre(nombreOrigen, estacion, linea: origen.linea)
                let tramo2 = estacionesEntre(estacion, nombreDestino, linea: destino.linea)
                print("Te faltan \(tramo1) estación(es) hasta el transbordo y \(tramo2) más tras el transbordo (total: \(tramo1 + tramo2)).")
                transbordoEncontrado = true
                break
            }
        }
        if !transbordoEncontrado {
            print("No hay un transbordo directo conocido entre \(origen.linea) y \(destino.linea) en este sistema.")
        }
    }

    if let conexion = destino.conectaMetropolitano {
        print("Dato extra: \(destino.nombre) conecta con el Metropolitano → \(conexion)")
    }
}

// ★ NUEVO 3: cuenta cuántas estaciones hay entre dos estaciones de la misma línea
func estacionesEntre(_ origen: String, _ destino: String, linea: String) -> Int {
    guard let estaciones = estacionesPorLinea[linea],
          let i1 = estaciones.firstIndex(of: origen),
          let i2 = estaciones.firstIndex(of: destino) else { return 0 }
    return abs(i2 - i1)
}

// ============================================================
// ★★★ NUEVO (parte B): MENÚ DE TARJETA DE TRANSPORTE ★★★
// ============================================================
func menuTarjeta() {
    lineaSeparadora()
    print("   💳 TARJETA DE TRANSPORTE")
    lineaSeparadora()
    print("   Saldo actual: S/ \(String(format: "%.2f", tarjetaUsuario.saldo))")
    print("   1 · Recargar")
    print("   2 · Simular pago de pasaje (S/ \(String(format: "%.2f", tarjetaUsuario.tarifa)))")
    print("   3 · Volver")
    print("   ➤ ", terminator: "")
    switch readLine() ?? "" {
    case "1":
        print("   Ingresa el monto a recargar: ")
        print("   ➤ ", terminator: "")
        if let entrada = readLine(), let monto = Double(entrada), monto > 0 {
            tarjetaUsuario.recargar(monto: monto)
            print("   ✅ Recarga exitosa. Nuevo saldo: S/ \(String(format: "%.2f", tarjetaUsuario.saldo))")
        } else {
            print("   ⚠️ Monto no válido.")
        }
    case "2":
        if tarjetaUsuario.pagarPasaje() {
            print("   ✅ Pasaje cobrado. Saldo restante: S/ \(String(format: "%.2f", tarjetaUsuario.saldo))")
        } else {
            print("   ⚠️ Saldo insuficiente. Recarga tu tarjeta.")
        }
    default:
        break
    }
    lineaSeparadora()
}

// ============================================================
// ★★★ NUEVO: MODO ADMINISTRADOR (sin contraseña) ★★★
// Permite: agregar estación a una línea existente, crear una línea
// completamente nueva, y editar una estación ya creada.
// ============================================================
func modoAdministrador() {
    lineaSeparadora()
    print("   🛠️ MODO ADMINISTRADOR")
    lineaSeparadora()
    print("   1 · Agregar estación a una línea existente")
    print("   2 · Crear una línea completamente nueva")
    print("   3 · Editar una estación existente")
    print("   4 · Volver")
    print("   ➤ ", terminator: "")
    switch readLine() ?? "" {
    case "1":
        guard let linea = seleccionarLinea() else { return }
        agregarEstacion(aLinea: linea)
    case "2":
        crearLineaNueva()
    case "3":
        if let estacion = seleccionarEstacion(titulo: "Selecciona la estación a editar:") {
            editarEstacion(estacion)
        }
    default:
        break
    }
    lineaSeparadora()
}

// ★ NUEVO: pide los datos de una estación por consola y la registra
func agregarEstacion(aLinea linea: String) {
    print("   Nombre de la nueva estación: ")
    print("   ➤ ", terminator: "")
    let nombre = readLine() ?? "Estación sin nombre"

    print("   ¿Tiene ascensor? (s/n): ")
    print("   ➤ ", terminator: "")
    let ascensor = (readLine() ?? "n").lowercased() == "s"

    print("   Vías cercanas (separadas por coma): ")
    print("   ➤ ", terminator: "")
    let vias = (readLine() ?? "").split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }

    print("   ¿Conecta con el Metropolitano? (dejar vacío si no): ")
    print("   ➤ ", terminator: "")
    let conexionTexto = readLine() ?? ""
    let conexion: String? = conexionTexto.isEmpty ? nil : conexionTexto

    print("   Puntos de interés cercanos (separados por coma, opcional): ")
    print("   ➤ ", terminator: "")
    let puntosTexto = readLine() ?? ""
    let puntos = puntosTexto.isEmpty ? [] : puntosTexto.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }

    let nueva = Estacion(nombre: nombre, linea: linea, tieneAscensor: ascensor, viasCercanas: vias, conectaMetropolitano: conexion)
    detalleEstaciones[nombre] = nueva
    estacionesPorLinea[linea, default: []].append(nombre)
    if !puntos.isEmpty { puntosDeInteresPorEstacion[nombre] = puntos }
    actualizarNormalizados()

    print("   ✅ Estación '\(nombre)' agregada a \(linea).")
}

// ★ NUEVO: crea una línea nueva vacía y permite agregarle estaciones
func crearLineaNueva() {
    print("   Nombre de la nueva línea (ej. Línea 4): ")
    print("   ➤ ", terminator: "")
    let nombreLinea = readLine() ?? "Línea nueva"

    if estacionesPorLinea[nombreLinea] != nil {
        print("   ⚠️ Esa línea ya existe.")
        return
    }
    estacionesPorLinea[nombreLinea] = []
    actualizarNormalizados()
    print("   ✅ Línea '\(nombreLinea)' creada. Ahora agrega sus estaciones:")

    var seguir = true
    while seguir {
        agregarEstacion(aLinea: nombreLinea)
        print("   ¿Agregar otra estación a \(nombreLinea)? (s/n): ")
        print("   ➤ ", terminator: "")
        seguir = (readLine() ?? "n").lowercased() == "s"
    }
}

// ★ NUEVO: el admin puede editar una estación ya creada (ascensor,
// vías, conexión Metropolitano y puntos de interés)
func editarEstacion(_ nombre: String) {
    guard let actual = detalleEstaciones[nombre] else {
        print("   ⚠️ Estación no encontrada.")
        return
    }

    print("   ¿Tiene ascensor? (s/n) [actual: \(actual.tieneAscensor ? "s" : "n")]: ")
    print("   ➤ ", terminator: "")
    let ascensor = (readLine() ?? (actual.tieneAscensor ? "s" : "n")).lowercased() == "s"

    print("   Vías cercanas separadas por coma [actual: \(actual.viasCercanas.joined(separator: ", "))]: ")
    print("   ➤ ", terminator: "")
    let viasEntrada = readLine() ?? ""
    let vias = viasEntrada.isEmpty ? actual.viasCercanas : viasEntrada.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }

    print("   Conexión Metropolitano (vacío = sin cambio, 'ninguna' = quitar): ")
    print("   ➤ ", terminator: "")
    let conexionEntrada = readLine() ?? ""
    var conexion = actual.conectaMetropolitano
    if conexionEntrada.lowercased() == "ninguna" { conexion = nil }
    else if !conexionEntrada.isEmpty { conexion = conexionEntrada }

    print("   Puntos de interés separados por coma (vacío = sin cambio): ")
    print("   ➤ ", terminator: "")
    let puntosEntrada = readLine() ?? ""
    if !puntosEntrada.isEmpty {
        puntosDeInteresPorEstacion[nombre] = puntosEntrada.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
    }

    detalleEstaciones[nombre] = Estacion(nombre: actual.nombre, linea: actual.linea, tieneAscensor: ascensor, viasCercanas: vias, conectaMetropolitano: conexion)
    print("   ✅ Estación '\(nombre)' actualizada.")
}

// ===== INTERFAZ DE CONSOLA =====
func lineaSeparadora() {
    print(String(repeating: "─", count: 50))
}

func mostrarMenu() {
    print("""
    
    ┌─────────────────────────────────────────┐
    │        METRO DE LIMA · CONSOLA          │
    └─────────────────────────────────────────┘
      🚉  1 · Estaciones por línea
      🔍  2 · Buscar una estación
      🔄  3 · Conexiones con el Metropolitano
      🗺️  4 · Planear ruta entre dos estaciones
      💳  5 · Tarjeta de transporte
      🛠️  6 · Modo administrador
      🚪  7 · Salir
    -------------------------------------------
    """)
    print("   Elige una opción ➜ ", terminator: "")
}

// ===== MENÚ PRINCIPAL =====
var opcion = ""
repeat {
    mostrarMenu()
    opcion = readLine() ?? ""

    switch opcion {
    case "1":
        lineaSeparadora()
        print("   ¿Qué línea deseas consultar? (Línea 1 / Línea 2 / Línea 3)")
        print("   ➤ ", terminator: "")
        let linea = readLine() ?? ""
        lineaSeparadora()
        mostrarEstacionesDeLinea(linea)
        lineaSeparadora()

    case "2":
        lineaSeparadora()
        print("   🔍 BUSCAR INFORMACIÓN DE ESTACIÓN")
        if let estacionSeleccionada = seleccionarEstacion(titulo: "Selecciona la estación a consultar:") {
            lineaSeparadora()
            buscarInfoEstacion(estacionSeleccionada)
        }
        lineaSeparadora()

    case "3":
        lineaSeparadora()
        print("   🔄  CONEXIONES CON EL METROPOLITANO")
        lineaSeparadora()
        for (estacionMetro, conexion) in conexionesMetropolitano {
            print("   • \(estacionMetro) → \(conexion)")
        }
        lineaSeparadora()

    case "4":
        lineaSeparadora()
        print("   🗺️ PLANIFICADOR DE RUTAS")
        lineaSeparadora()
        print("   Primero, elige tu estación de ORIGEN:")
        guard let origen = seleccionarEstacion(titulo: "Origen del viaje") else {
            lineaSeparadora()
            break
        }
        lineaSeparadora()
        print("   Ahora, elige tu estación de DESTINO:")
        guard let destino = seleccionarEstacion(titulo: "Destino del viaje") else {
            lineaSeparadora()
            break
        }
        lineaSeparadora()
        planearRuta(origen, destino)
        lineaSeparadora()

    case "5":
        menuTarjeta()

    case "6":
        modoAdministrador()

    case "7":
        print("\n   ¡Gracias por usar el sistema! 👋\n")

    default:
        print("\n   ⚠️  Opción no válida, intenta de nuevo.\n")
    }

} while opcion != "7"
