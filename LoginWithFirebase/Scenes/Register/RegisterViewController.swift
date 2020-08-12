//
//  RegisterViewController.swift
//  LoginWithFirebase
//
//  Created by mac on 5/23/19.
//  Copyright © 2019 sunasterisk. All rights reserved.
//

final class RegisterViewController: UIViewController {
    @IBOutlet private weak var usernameTextField: DesignableUITextField!
    @IBOutlet private weak var emailTextField: DesignableUITextField!
    @IBOutlet private weak var passwordTextField: DesignableUITextField!
    @IBOutlet private weak var RegisterButton: UIButton!
    
    private var viewModel: RegisterViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }
    
    private func config() {
        usernameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        viewModel = RegisterViewModel()
        
        viewModel.bind { [weak self] in
            guard let self = self else { return }
            let vc = HomeViewController.instantiate()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        viewModel.bindError { [weak self] errorDescription in
            guard let self = self else { return }
            self.showError(message: errorDescription)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        usernameTextField.text = ""
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    @IBAction private func handleRegisterTapped(_ sender: Any) {
        viewModel.registerWithAccount(username: usernameTextField.text, email: emailTextField.text, password: passwordTextField.text)
    }
}

extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case usernameTextField:
            emailTextField.becomeFirstResponder()
        case emailTextField:
            passwordTextField.becomeFirstResponder()
        default:
            passwordTextField.resignFirstResponder()
        }
        return true
    }
}

extension RegisterViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.main
}
