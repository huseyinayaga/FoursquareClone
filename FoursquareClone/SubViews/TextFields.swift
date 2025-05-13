import Foundation
import UIKit

struct TextFields {
    static var usernameTextField: UITextField {
        let textField = UITextField()
        textField.placeholder = "Username"
        textField.borderStyle = .roundedRect
        return textField
    }
    static var emailTextField: UITextField {
        let textField = UITextField()
        textField.placeholder = "example@gmail.com"
        textField.keyboardType = .emailAddress
        textField.borderStyle = .roundedRect
        return textField
    }
    static func passwordTextField(placeholder: String) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        return textField
    }
    static func createTextField(placeholder: String) ->UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        return textField
    }
}
