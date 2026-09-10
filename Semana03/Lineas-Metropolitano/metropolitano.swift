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
let estacionesPorLinea: [String: [String]] = [
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
let detalleEstaciones: [String: Estacion] = [
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