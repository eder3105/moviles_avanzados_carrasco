import Foundation

// Nivel 3: retención mensual de renta de 5.ª categoría (simplificada)
// Renta anual proyectada = remuneración mensual x 14 (12 sueldos + 2 gratificaciones)
// Base = renta anual - 7 UIT. Impuesto por tramos. Retención mensual = impuesto anual / 12
enum RentaQuinta {
    static let tramos: [(hasta: Double, tasa: Double)] = [
        (5, 0.08), (20, 0.14), (35, 0.17), (45, 0.20), (Double.infinity, 0.30)
    ]

    static func retencionMensual(remuneracionMensual: Double) -> Double {
        let anual = remuneracionMensual * Parametros.sueldosAnuales
        let base = anual - Parametros.deduccionUIT * Parametros.uit
        if base <= 0 { return 0 }

        var impuesto = 0.0
        var desde = 0.0
        for tramo in tramos {
            let limite = tramo.hasta * Parametros.uit
            if base > desde {
                impuesto += (min(base, limite) - desde) * tramo.tasa
            }
            desde = limite
        }
        return redondear(impuesto / 12)
    }
}

final class Boleta {
    let datos: DatosBoleta

    init(datos: DatosBoleta) {
        self.datos = datos
    }

    // Sueldo básico ÷ 30 ÷ 8 (no se redondea; se redondea cada concepto)
    var valorHora: Double {
        datos.sueldoBasico / Parametros.diasMes / Parametros.horasDia
    }

    func calcular() -> ResultadoBoleta {
        calcular(con: datos.sistema)
    }

    func comparar() -> ComparativoPension {
        ComparativoPension(onp: calcular(con: .onp),
                           afp: calcular(con: .afp),
                           nombreAFP: datos.afp)
    }

    func calcular(con sistema: SistemaPension) -> ResultadoBoleta {
        // Remuneraciones
        let sueldoComputable = redondear(datos.sueldoBasico / Parametros.diasMes * Double(datos.diasLaborados))
        let asignacion = datos.tieneHijos ? Parametros.asignacionFamiliar : 0.0
        let he25 = redondear(valorHora * Parametros.recargoHE25 * datos.horasExtras25)
        let he35 = redondear(valorHora * Parametros.recargoHE35 * datos.horasExtras35)
        let totalRem = redondear(sueldoComputable + asignacion + he25 + he35)

        // Descuentos
        var onp = 0.0
        var fondo = 0.0
        var comision = 0.0
        var seguro = 0.0
        switch sistema {
        case .onp:
            onp = redondear(totalRem * Parametros.tasaONP)
        case .afp:
            if let t = Parametros.tasasAFP[datos.afp] {
                fondo = redondear(totalRem * t.fondo)
                comision = redondear(totalRem * t.comision)
                seguro = redondear(totalRem * t.seguro)
            }
        }
        let renta = datos.calcularRenta
            ? RentaQuinta.retencionMensual(remuneracionMensual: totalRem)
            : 0.0
        let totalDesc = redondear(onp + fondo + comision + seguro + datos.adelantos + renta)

        // Neto y aporte del empleador
        let neto = redondear(totalRem - totalDesc)
        let essalud = redondear(totalRem * Parametros.tasaEsSalud)

        // Arrays de conceptos para mostrar en pantalla
        let remuneraciones = [
            Concepto(nombre: "Sueldo computable", monto: sueldoComputable),
            Concepto(nombre: "Asignación familiar", monto: asignacion),
            Concepto(nombre: "Horas extras 25%", monto: he25),
            Concepto(nombre: "Horas extras 35%", monto: he35)
        ]

        var descuentos = [
            Concepto(nombre: "ONP", monto: onp),
            Concepto(nombre: "AFP fondo", monto: fondo),
            Concepto(nombre: "AFP comisión", monto: comision),
            Concepto(nombre: "AFP seguro", monto: seguro),
            Concepto(nombre: "Adelantos", monto: datos.adelantos)
        ]
        if datos.calcularRenta {
            descuentos.append(Concepto(nombre: "Renta 5.ª categoría", monto: renta))
        }

        let aportaciones = [
            Concepto(nombre: "EsSalud (9%)", monto: essalud)
        ]

        return ResultadoBoleta(remuneraciones: remuneraciones,
                               descuentos: descuentos,
                               aportaciones: aportaciones,
                               totalRemuneraciones: totalRem,
                               totalDescuentos: totalDesc,
                               neto: neto,
                               essalud: essalud)
    }
}
