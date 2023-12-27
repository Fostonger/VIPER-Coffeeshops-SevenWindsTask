import UIKit
import SnapKit

class LoginViewController: UIViewController {
    
    var presenter : LoginViewToPresenterProtocol?
    
    private let emailTextField = SWTextFieldView()
    private let passwordTextField = SWTextFieldView()
    private let loginButton = SWButton()
    private let openRegisterButton: UIButton = {
        let button = UIButton()
        button.tintColor = SevenWindsColors.lightBrown.uiColor
        button.titleLabel?.font = SevenWindsFonts.sfUiDisplay(weight: 200).font
        button.setTitle(LoginLocalization.createAccount.localized, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        view.backgroundColor = .white
    }
    
    private func setupUI() {
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        
        emailTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(18)
            make.trailing.equalToSuperview().offset(-18)
            make.height.equalTo(73)
            make.top.equalTo(view.snp.top).offset(190)
        }
        emailTextField.setupView(placeholder: "Example@gmail.com", labelText: LoginLocalization.email.localized)
        
        passwordTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(18)
            make.trailing.equalToSuperview().offset(-18)
            make.height.equalTo(73)
            make.top.equalTo(emailTextField.snp.bottom).offset(24)
        }
        passwordTextField.setupView(placeholder: "*****", labelText: LoginLocalization.password.localized)
        
        loginButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(18)
            make.trailing.equalToSuperview().offset(-18)
            make.height.equalTo(48)
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
        }
        
        navigationItem.title = LoginLocalization.loginTitle.localized
        loginButton.setTitle(LoginLocalization.loginButtonTitle.localized, for: .normal)
        loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        loginButton.isEnabled = false
        passwordTextField.inputTextView.delegate = self
        passwordTextField.inputTextView.textContentType = .password
//        passwordTextField.inputTextView.isSecureTextEntry = true
        emailTextField.inputTextView.delegate = self
    }
    
    @objc private func login() {
        let credentials = Credentials(password: passwordTextField.inputTextView.text ?? "",
                                      login: emailTextField.inputTextView.text ?? "")
        presenter?.login(with: credentials)
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let firstTFLenght = (textField.text?.count ?? 0) - range.length + string.count
        let secondTF: Int
        switch textField {
        case emailTextField.inputTextView:
            secondTF = passwordTextField.inputTextView.text?.count ?? 0
        case passwordTextField.inputTextView:
            secondTF = emailTextField.inputTextView.text?.count ?? 0
        default:
            return true
        }
        
        loginButton.isEnabled = firstTFLenght > 0 && secondTF > 0
        return true
    }
}

extension LoginViewController: LoginPresenterToViewProtocol {
    func onLoginSuccess() {}
    
    func onLoginError(message: String) {
        let alert = UIAlertController(title: "Ошибка во время входа", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
