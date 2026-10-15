import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        resultLabel.text = "Introduce tu Peso y Altura"
    }

    @IBAction func CalcularResultado(_ sender: Any) {
        let weight = Double(weightTextField.text ?? "") ?? 0
        let height = Double(heightTextField.text ?? "") ?? 0

        if weight == 0 || height == 0 {
            resultLabel.text = "Por favor, ingresa valores válidos."
            return
        }

        let bmi = weight / (height * height)

        var status = ""
        if bmi < 18.5 {
            status = "Bajo peso"
        } else if bmi < 24.9 {
            status = "Peso normal"
        } else if bmi < 29.9 {
            status = "Sobrepeso"
        } else {
            status = "Obesidad"
        }

        resultLabel.text = "IMC: \(String(format: "%.2f", bmi)) - \(status)"
    }
}
