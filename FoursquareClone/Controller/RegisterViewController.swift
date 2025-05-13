import UIKit

class RegisterViewController: UIViewController {
    private let parseProccess = ParseProccess()
    private let usernameTextField = TextFields.usernameTextField
    private let emailTextField = TextFields.emailTextField
    private let passwordTextField = TextFields.passwordTextField(placeholder: "Password")
    private let confirmPasswordTextField = TextFields.passwordTextField(placeholder: "Password Confirm")
    private let signUpButton = Buttons.signUpButton
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [usernameTextField,emailTextField,passwordTextField,confirmPasswordTextField,signUpButton])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        signUpButton.addTarget(self, action: #selector(signUpClicked), for: .touchUpInside)
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
    }
    
}





extension RegisterViewController {
    private func setupLayout(){
        view.backgroundColor = .systemBackground
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().inset(24)
        }
        usernameTextField.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
    }
    @objc private func hideKeyboard(){
        view.endEditing(true)
    }
    private func register(){
        let overlay = UIView(frame: view.bounds)
        overlay.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        overlay.tag = 999
        view.addSubview(overlay)
        signUpButton.isEnabled = false
        
        parseProccess.register(username: usernameTextField.text!,
                               password: passwordTextField.text!,
                               email: emailTextField.text!) { success, message in
            DispatchQueue.main.async {
                overlay.removeFromSuperview()
                self.signUpButton.isEnabled = true
                if success {
                    Helper.makeAlert(title: "Basarili", message: "Kaydiniz basarili bir sekilde olusturuldu", controller: self)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        let loginViewController = LoginViewController()
                        self.navigationController?.pushViewController(loginViewController, animated: true)
                    }
                }else{
                    if let message = message {
                        Helper.makeAlert(title: "Hata!!!", message: message, controller: self)
                    }
                }
            }
            
            
        }
    }
    @objc private func signUpClicked(){
        if Helper.textFieldIsEmpty(textField: usernameTextField) ||
            Helper.textFieldIsEmpty(textField: emailTextField) ||
            Helper.textFieldIsEmpty(textField: passwordTextField) ||
            Helper.textFieldIsEmpty(textField: confirmPasswordTextField){
            Helper.makeAlert(title: "Hata!!!", message: "Bos alan birakilmaz", controller: self)
            return
        }
        guard Helper.isValidEmail(emailTextField.text!) else{
            Helper.makeAlert(title: "Hata!!!", message: "Gecersiz email formati", controller: self)
            return
        }
        if passwordTextField.text != confirmPasswordTextField.text {
            Helper.makeAlert(title: "Sifreler Uyusmuyor", message: "Girdiginiz sifreler birbiriyle uyusmuyor", controller: self)
            return
        }
        register()
    }
}
