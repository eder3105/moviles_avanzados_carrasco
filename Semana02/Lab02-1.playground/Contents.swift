import Foundation

let  parcial = 0.3
let trabajo = 0.3
let final = 0.4

print ("Nombre del Alumno")
let alumno = readLine() ?? ""
print("Nota del Examen Parcial : ")
let exaparcial = Double(readLine() ?? "") ?? 0
//commit del ingreso de datos
print ("Nota de trabajo : ")
let extrabajo = Double(readLine() ?? "") ?? 0
print("Nota del Examen Final : ")
let exfinal = Double(readLine() ?? "") ?? 0
//commit del calculo
let promedioFinal = (exaparcial * parcial) + (extrabajo * trabajo) + (exfinal * final)
//commit de mostrar los datos
