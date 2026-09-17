import Foundation

class Cliente {
    var codigo: String
    var direccion: String
    var fechaDeRegistro: String
    var numeroCuenta: String
    var montoMinimoApertura: Double
    
    init(codigo: String, direccion: String, fechaDeRegistro: String, numeroCuenta: String, montoMinimoApertura: Double) {
        self.codigo = codigo
        self.direccion = direccion
        self.fechaDeRegistro = fechaDeRegistro
        self.numeroCuenta = numeroCuenta
        self.montoMinimoApertura = montoMinimoApertura
    }
    
    func mostrarDatos() {
        print("📄 Código: \(codigo)")
        print("📍 Dirección: \(direccion)")
        print("📅 Fecha de registro: \(fechaDeRegistro)")
        print("🏦 Nº Cuenta: \(numeroCuenta)")
        print(String(format: "💰 Monto mínimo de apertura: S/ %.2f", montoMinimoApertura))
    }
}

class ClienteNatural: Cliente {
    var nombreCompleto: String
    var dni: String
    
    init(codigo: String, direccion: String, fechaDeRegistro: String, numeroCuenta: String, montoMinimoApertura: Double, nombreCompleto: String, dni: String) {
        self.nombreCompleto = nombreCompleto
        self.dni = dni
        super.init(codigo: codigo, direccion: direccion, fechaDeRegistro: fechaDeRegistro, numeroCuenta: numeroCuenta, montoMinimoApertura: montoMinimoApertura)
    }
    
    override func mostrarDatos() {
        print("\n👤 Cliente Natural:")
        print("Nombre: \(nombreCompleto)")
        print("DNI: \(dni)")
        super.mostrarDatos()
    }
}

class ClienteJuridico: Cliente {
    var razonSocial: String
    var ruc: String
    var representanteLegal: String
    
    init(codigo: String, direccion: String, fechaDeRegistro: String, numeroCuenta: String, montoMinimoApertura: Double, razonSocial: String, ruc: String, representanteLegal: String) {
        self.razonSocial = razonSocial
        self.ruc = ruc
        self.representanteLegal = representanteLegal
        super.init(codigo: codigo, direccion: direccion, fechaDeRegistro: fechaDeRegistro, numeroCuenta: numeroCuenta, montoMinimoApertura: montoMinimoApertura)
    }
    
    override func mostrarDatos() {
        print("\n🏢 Cliente Jurídico:")
        print("Razón Social: \(razonSocial)")
        print("RUC: \(ruc)")
        print("Representante Legal: \(representanteLegal)")
        super.mostrarDatos()
    }
}

func leerTexto(prompt: String) -> String {
    print(prompt, terminator: " ")
    return readLine()?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
}

func leerDouble(prompt: String) -> Double {
    while true {
        if let valor = Double(leerTexto(prompt: prompt)), valor >= 0 {
            return valor
        }
        print("⚠️ Ingrese un monto válido.")
    }
}

func capturarDatosBase(codigoDefecto: String) -> (codigo: String, direccion: String, fecha: String, cuenta: String, monto: Double) {
    let codigo = leerTexto(prompt: "Código (\(codigoDefecto)):")
    let codigoFinal = codigo.isEmpty ? codigoDefecto : codigo
    let direccion = leerTexto(prompt: "Dirección:")
    let fecha = leerTexto(prompt: "Fecha de registro (AAAA-MM-DD):")
    let cuenta = leerTexto(prompt: "Número de cuenta:")
    let monto = leerDouble(prompt: "Monto mínimo de apertura (S/):")
    
    return (codigoFinal, direccion, fecha, cuenta, monto)
}