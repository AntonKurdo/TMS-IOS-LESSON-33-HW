import UIKit


class LoginViewController: UIViewController {
    
    private var buttonBottomConstraint_withCloseKB: NSLayoutConstraint?
    private var buttonBottomConstraint_withOpenKB: NSLayoutConstraint?
    private var emailTextField = UITextField(placeholder: "Email...")
    private var passwordTextField = UITextField(placeholder: "Password...")
    private var button = UIButton(title: "Sign In", color: .systemCyan)
    private var keyboardHelper: KeyboardHelper?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "Login"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        setupTextFields()
        setupButton()
        setupKeyboardHelper()
    }
    
    private func setupTextFields() {
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
 
        emailTextField.becomeFirstResponder()
        let prevEmail = KeychainService.shared.getValue(for: "login")
        if prevEmail != nil {
            emailTextField.text = prevEmail
        }
        
        passwordTextField.isSecureTextEntry = true
        
        NSLayoutConstraint.activate([
            emailTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            emailTextField.heightAnchor.constraint(equalToConstant: 40),
            emailTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            passwordTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            passwordTextField.heightAnchor.constraint(equalToConstant: 40),
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 24),
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            
        ])
    }
    
    private func setupButton() {
        view.addSubview(button)
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            button.heightAnchor.constraint(equalToConstant: 50),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        let action = UIAction { _ in
            guard let email = self.emailTextField.text, let password = self.passwordTextField.text else { return }
            if(email.count > 0 && password.count > 0) {
                self.button.loadingIndicator(true)
                AuthService.shared.signIn(login: email, password: password) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        self.button.loadingIndicator(false)
                    }
                }
              
                self.navigationController?.replaceTopViewController(with: MainViewController(), animated: true)
            } else {
                if(email.count == 0) {
                    self.emailTextField.shake()
                }
                if(password.count == 0) {
                    self.passwordTextField.shake()
                }
            }
        }
        button.addAction(action, for: .touchUpInside)

    }
    
    
    private func setupKeyboardHelper() {
        keyboardHelper = KeyboardHelper {  animation, keyboardFrame, duration in
            switch animation {
            case .keyboardWillShow:
                self.buttonBottomConstraint_withCloseKB?.isActive = false
                self.buttonBottomConstraint_withOpenKB = self.button.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -keyboardFrame.height - 32)
                self.buttonBottomConstraint_withOpenKB?.isActive = true
                UIView.animate(withDuration: duration) {
                    self.view.layoutIfNeeded()
                }
                UIView.animate(withDuration: duration) {
                    self.view.layoutIfNeeded()
                }
            case .keyboardWillHide:
                self.buttonBottomConstraint_withOpenKB?.isActive = false
                self.buttonBottomConstraint_withCloseKB?.isActive = true
                UIView.animate(withDuration: duration) {
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
}




