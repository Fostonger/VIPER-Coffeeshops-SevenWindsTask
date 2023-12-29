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
        view.backgroundColor = .white
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
        
        emailTextField.setupView(placeholder: "example@gmail.com", labelText: LoginLocalization.email.localized)
        passwordTextField.setupView(placeholder: "*****", labelText: LoginLocalization.password.localized)
        confirmPasswordTextField.setupView(placeholder: "*****", labelText: LoginLocalization.confirmPassword.localized)
        
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
        let passwordConfirmed: Bool
        var firstTF = (textField.text?.count ?? 0) - range.length + string.count
        let secondTF: Int
        
        let text = textField.text ?? ""
        let lowerRangeBound = text.index(text.startIndex, offsetBy: range.lowerBound)
        let upperRangeBound = text.index(text.startIndex, offsetBy: range.upperBound)
        
        let newText = text.replacingCharacters(
            in: lowerRangeBound..<upperRangeBound,
            with: string
        )
        
        switch textField {
        case emailTextField.inputTextView:
            secondTF = passwordTextField.inputTextView.text?.count ?? 0
            passwordConfirmed = confirmPasswordTextField.inputTextView.text ==  passwordTextField.inputTextView.text
            setPasswordErrorColor(isPasswordValid: true)
        case passwordTextField.inputTextView:
            secondTF = emailTextField.inputTextView.text?.count ?? 0
            passwordConfirmed = confirmPasswordTextField.inputTextView.text == newText
            let confirmPasswordIsEmpty = confirmPasswordTextField.inputTextView.text?.isEmpty ?? true
            setPasswordErrorColor(isPasswordValid: passwordConfirmed || confirmPasswordIsEmpty)
        default:
            passwordConfirmed = passwordTextField.inputTextView.text == newText
            secondTF = emailTextField.inputTextView.text?.count ?? 0
            firstTF = passwordTextField.inputTextView.text?.count ?? 0
            setPasswordErrorColor(isPasswordValid: passwordConfirmed || newText.isEmpty)
        }
        
        registerButton.isEnabled = firstTF > 0 && secondTF > 0 && passwordConfirmed
        return true
    }
    
    private func setPasswordErrorColor(isPasswordValid: Bool) {
        confirmPasswordTextField.inputTextView.backgroundColor = isPasswordValid ? .systemBackground : .red
        passwordTextField.inputTextView.backgroundColor = isPasswordValid ? .systemBackground : .red
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
