import Foundation

enum Validador {

    // Acepta "2500", "2500.50" y "2500,50"
    static func numero(_ texto: String) -> Double? {
        let limpio = texto
            .trimmingCharacters(in: .whitespaces)
            .replacingOccurrences(of: ",", with: ".")
        guard let valor = Double(limpio), valor.isFinite else { return nil }
        return valor
    }

    // Campo opcional: vacío = 0; si hay texto debe ser número >= 0
    static func noNegativo(_ texto: String) -> Double? {
        let t = texto.trimmingCharacters(in: .whitespaces)
        if t.isEmpty { return 0 }
        guard let valor = numero(t), valor >= 0 else { return nil }
        return valor
    }

    static func validar(sueldo: String,
                        dias: String,
                        tieneHijos: Bool,
                        sistema: SistemaPension,
                        afp: String,
                        horas25: String,
                        horas35: String,
                        adelantos: String,
                        calcularRenta: Bool) -> Result<DatosBoleta, ErrorBoleta> {

        guard let s = numero(sueldo), s > 0 else {
            return .failure(ErrorBoleta(mensaje: "El sueldo básico debe ser un número mayor que cero."))
        }
        guard let d = Int(dias.trimmingCharacters(in: .whitespaces)), d >= 1, d <= 30 else {
            return .failure(ErrorBoleta(mensaje: "Los días laborados deben ser un número entero entre 1 y 30."))
        }
        if sistema == .afp && Parametros.tasasAFP[afp] == nil {
            return .failure(ErrorBoleta(mensaje: "Elige una AFP de la lista."))
        }
        guard let h25 = noNegativo(horas25) else {
            return .failure(ErrorBoleta(mensaje: "Las horas extras al 25% deben ser un número mayor o igual a cero."))
        }
        guard let h35 = noNegativo(horas35) else {
            return .failure(ErrorBoleta(mensaje: "Las horas extras al 35% deben ser un número mayor o igual a cero."))
        }
        guard let adel = noNegativo(adelantos) else {
            return .failure(ErrorBoleta(mensaje: "Los adelantos deben ser un número mayor o igual a cero."))
        }

        let datos = DatosBoleta(sueldoBasico: s,
                                diasLaborados: d,
                                tieneHijos: tieneHijos,
                                sistema: sistema,
                                afp: afp,
                                horasExtras25: h25,
                                horasExtras35: h35,
                                adelantos: adel,
                                calcularRenta: calcularRenta)
        return .success(datos)
    }
}
