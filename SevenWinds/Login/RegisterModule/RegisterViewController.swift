import UIKit
import SnapKit

class RegisterViewController: UIViewController {
    
    var presenter : RegisterViewToPresenterProtocol?
    
    private let emailTextField = SWTextFieldView()
    private let passwordTextField = SWTextFieldView()
    private let confirmPasswordTextField = SWTextFieldView()
    private let registerButton = SWButton()
    
    private var credentials: Credentials = Credentials(password: "", login: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(confirmPasswordTextField)
        view.addSubview(registerButton)
        
        emailTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(18)
            make.trailing.equalToSuperview().offset(-18)
            make.height.equalTo(73)
            make.top.equalTo(view.snp.top).offset(190)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(18)
            make.trailing.equalToSuperview().offset(-18)
            make.height.equalTo(73)
            make.top.equalTo(emailTextField.snp.bottom).offset(24)
        }
        
        confirmPasswordTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(18)
            make.trailing.equalToSuperview().offset(-18)
            make.height.equalTo(73)
            make.top.equalTo(passwordTextField.snp.bottom).offset(24)
        }
        
        registerButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(18)
            make.trailing.equalToSuperview().offset(-18)
            make.height.equalTo(48)
            make.top.equalTo(confirmPasswordTextField.snp.bottom).offset(30)
        }
        
        navigationItem.title = LoginLocalization.registerTitle.localized
        registerButton.setTitle(LoginLocalization.registerButtonTitle.localized, for: .normal)
        registerButton.addTarget(self, action: #selector(register), for: .touchUpInside)
        registerButton.isEnabled = false
        passwordTextField.inputTextView.delegate = self
        passwordTextField.inputTextView.textContentType = .newPassword
        confirmPasswordTextField.inputTextView.delegate = self
        passwordTextField.inputTextView.isSecureTextEntry = true
        confirmPasswordTextField.inputTextView.isSecureTextEntry = true
        emailTextField.inputTextView.delegate = self
    }
    
    @objc private func register() {
        presenter?.register(with: credentials)
    }
}

extension RegisterViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == confirmPasswordTextField.inputTextView {
            confirmPasswordTextField.inputTextView.backgroundColor = .systemBackground
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let passwordConfirmed = confirmPasswordTextField.inputTextView.text ==  passwordTextField.inputTextView.text
        switch textField {
        case emailTextField.inputTextView:
            credentials = Credentials(password: credentials.password, login: emailTextField.inputTextView.text ?? "")
        case passwordTextField.inputTextView:
            credentials = Credentials(password: credentials.password, login: passwordTextField.inputTextView.text ?? "")
        case confirmPasswordTextField.inputTextView:
            confirmPasswordTextField.inputTextView.backgroundColor = passwordConfirmed ? .systemBackground : .red
        default:
            return
        }
        
        registerButton.isEnabled = passwordConfirmed && !credentials.password.isEmpty && !credentials.login.isEmpty
    }
}

extension RegisterViewController: RegisterPresenterToViewProtocol {
    func onRegisterSuccess() {}
    
    func onRegisterError(message: String) {
        let alert = UIAlertController(title: "Ошибка во время регистрации", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
