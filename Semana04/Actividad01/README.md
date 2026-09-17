# Actividad Propuesta 01 - Facturación de Cursos Libres Tecsup

## Requerimientos Funcionales
1. **Registro de Estudiante:** Capturar Nombre, DNI y condición de estudiante de Tecsup (Sí/No).
2. **Catálogo de Cursos:** Presentar un catálogo predefinido de cursos con sus respectivos precios unitarios.
3. **Selección Interactiva:** Permitir al estudiante seleccionar cursos del catálogo mediante su número de opción y definir la cantidad deseada.
4. **Cálculo de Importes Base:**
   - Subtotal: Suma de importes acumulados de los cursos seleccionados.
   - IGV (18%): Impuesto calculado sobre el Subtotal.
   - Total con IGV: Subtotal + IGV.
5. **Reglas de Descuento:**
   - Descuento por Cantidad (10%): Se aplica sobre el Total con IGV si la cantidad total de cursos comprados es 3 o más.
   - Descuento Especial Tecsup (S/ 400.00): Se descuenta solo si es alumno de Tecsup Y compró 3 o más cursos en total.
6. **Emisión de Factura:** Generar la boleta interactiva formateada en consola con el desglose completo.