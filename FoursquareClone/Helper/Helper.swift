import Foundation
import UIKit

class Helper {
    public static func makeAlert(title: String, message: String, controller: UIViewController){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okButton)
        controller.present(alert, animated: true,completion: nil)
    }
    public static func textFieldIsEmpty(textField: UITextField) -> Bool{
        return textField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true
    }
    public static func isValidEmail(_ email: String) -> Bool {
        let emailPattern = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailPattern)
        return emailPredicate.evaluate(with: email)
    }
}
