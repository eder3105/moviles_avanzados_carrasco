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

func registrarClienteNatural(contador: Int) -> ClienteNatural {
    print("\n--- REGISTRO DE CLIENTE NATURAL ---")
    let nombre = leerTexto(prompt: "Nombre completo:")
    let dni = leerTexto(prompt: "DNI:")
    let base = capturarDatosBase(codigoDefecto: "C00\(contador)")
    
    return ClienteNatural(
        codigo: base.codigo,
        direccion: base.direccion,
        fechaDeRegistro: base.fecha,
        numeroCuenta: base.cuenta,
        montoMinimoApertura: base.monto,
        nombreCompleto: nombre,
        dni: dni
    )
}

func registrarClienteJuridico(contador: Int) -> ClienteJuridico {
    print("\n--- REGISTRO DE CLIENTE JURÍDICO ---")
    let razonSocial = leerTexto(prompt: "Razón Social:")
    let ruc = leerTexto(prompt: "RUC:")
    let repLegal = leerTexto(prompt: "Representante Legal:")
    let base = capturarDatosBase(codigoDefecto: "C00\(contador)")
    
    return ClienteJuridico(
        codigo: base.codigo,
        direccion: base.direccion,
        fechaDeRegistro: base.fecha,
        numeroCuenta: base.cuenta,
        montoMinimoApertura: base.monto,
        razonSocial: razonSocial,
        ruc: ruc,
        representanteLegal: repLegal
    )
}

func ejecutarSistema() {
    var listaClientes: [Cliente] = []
    var contador = 1
    
    while true {
        print("\n==========================================")
        print("🏦 SISTEMA DE GESTIÓN BANCARIA DE CLIENTES")
        print("[1] Registrar Cliente Natural")
        print("[2] Registrar Cliente Jurídico")
        print("[3] Mostrar lista de clientes registrados")
        print("[0] Salir")
        print("==========================================")
        
        let opcion = leerTexto(prompt: "Seleccione una opción:")
        
        switch opcion {
        case "1":
            let cliente = registrarClienteNatural(contador: contador)
            listaClientes.append(cliente)
            contador += 1
            print("✅ Cliente Natural registrado con éxito.")
        case "2":
            let cliente = registrarClienteJuridico(contador: contador)
            listaClientes.append(cliente)
            contador += 1
            print("✅ Cliente Jurídico registrado con éxito.")
        case "3":
            if listaClientes.isEmpty {
                print("\n⚠️ No hay clientes registrados en el sistema.")
            } else {
                print("\n--- LISTA DE CLIENTES REGISTRADOS ---")
                for cliente in listaClientes {
                    cliente.mostrarDatos()
                    print("------------------------------------------")
                }
            }
        case "0":
            print("\n👋 ¡Gracias por usar el sistema!")
            return
        default:
            print("⚠️ Opción no válida. Intente nuevamente.")
        }
    }
}

ejecutarSistema()