import SwiftUI

/// Menú principal: cada opción navega a una pantalla con NavigationLink.
struct MenuPrincipal: View {
    var body: some View {
        NavigationStack {
            List {
                Section("Ejercicios") {
                    NavigationLink {
                        NotasTeoriaView()
                    } label: {
                        Label("Notas de teoría", systemImage: "graduationcap")
                    }

                    NavigationLink {
                        CTSView()
                    } label: {
                        Label("Cálculo de CTS", systemImage: "banknote")
                    }

                    NavigationLink {
                        PagoInstructoresView()
                    } label: {
                        Label("Pago de instructores", systemImage: "person.crop.rectangle")
                    }
                }

                Section("Trabajo grupal") {
                    NavigationLink {
                        CuentasView()
                    } label: {
                        Label("Cuentas por cobrar y por pagar", systemImage: "chart.bar.doc.horizontal")
                    }
                }
            }
            .navigationTitle("Menú Principal")
        }
    }
}

#Preview {
    MenuPrincipal()
}
