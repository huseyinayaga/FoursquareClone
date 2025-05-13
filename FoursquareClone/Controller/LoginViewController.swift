import UIKit
import SnapKit

class LoginViewController: UIViewController {
    private let parseProccess = ParseProccess()
    private let titleLabel = Labels.titleLabel
    private let usernameTextField = TextFields.usernameTextField
    private let passwordTextField = TextFields.passwordTextField(placeholder: "Password")
    private let signInButton = Buttons.signInButton
    private let signUpButton = Buttons.signUpButton
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, usernameTextField, passwordTextField, signInButton, signUpButton])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        view.backgroundColor = .systemBackground
        setupLayout()
        signUpButton.addTarget(self, action: #selector(goToRegister), for: .touchUpInside)
        signInButton.addTarget(self, action: #selector(signInClicked), for: .touchUpInside)
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
    }
    @objc private func hideKeyboard(){
        view.endEditing(true)
    }
    @objc private func signInClicked(){
        if Helper.textFieldIsEmpty(textField: usernameTextField) ||
            Helper.textFieldIsEmpty(textField: passwordTextField) {
            print("Text fieldler bos")
            Helper.makeAlert(title: "Hata!", message: "Bos alanlar var lutfen doldurun", controller: self)
            return
        }else{
            login()
        }
        
    }
    private func login() {
        let overlay = UIView(frame: view.bounds)
        overlay.backgroundColor = UIColor.black.withAlphaComponent(0.5) // Yarı saydam siyah arka plan
        overlay.tag = 999 // Overlay'i tanımlamak için bir etiket ekliyoruz
        view.addSubview(overlay)
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        signInButton.isEnabled = false
        let username = usernameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        parseProccess.login(username: username, password: passwordTextField.text!) { success, message in
            DispatchQueue.main.async {
                
                overlay.removeFromSuperview()
                
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
                self.signInButton.isEnabled = true
                if success {
                    if let navigationController = self.navigationController {
                        let listTableVC = ListTableViewController()
                        navigationController.pushViewController(listTableVC, animated: true)
                        print("Geçiş sağlandı")
                        UserDefaults.standard.set(true, forKey: "loggedIn")
                    } else {
                        print("Çalışmıyor")
                    }
                } else {
                    Helper.makeAlert(title: "Hata!", message: message ?? "", controller: self)
                }
            }
        }
    }
    @objc private func goToRegister(){
        let registerViewController = RegisterViewController()
        navigationController?.pushViewController(registerViewController, animated: true)
    }
    private func setupLayout() {
        view.addSubview(stackView)
        
        // stackView'i ortalamak ve yanlarda boşluk bırakmak için SnapKit kısıtlamalarını uyguluyoruz
        stackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().inset(24)
        }
        
        // Özelleştirilmiş buton yüksekliği
        signUpButton.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
    }
}
