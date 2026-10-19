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
                }
            }
            .navigationTitle("Menú Principal")
        }
    }
}

#Preview {
    MenuPrincipal()
}
