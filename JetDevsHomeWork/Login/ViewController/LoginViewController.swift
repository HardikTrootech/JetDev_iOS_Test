//
//  LoginViewController.swift
//  JetDevsHomeWork
//
//  Created by Hardik on 14/12/22.
//

import UIKit
import MaterialComponents
import RxSwift

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: MDCOutlinedTextField!
    @IBOutlet weak var passwordTextField: MDCOutlinedTextField!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    let viewModel = LoginViewModel()
    let disposeBag = DisposeBag()
    
    var isValidEmail = false
    var isValidPassword = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        // Do any additional setup after loading the view.
        self.configureViewControllers()
    }
    
    @IBAction func loginButtonTap(_ sender: UIButton) {
        if self.viewModel.validateCredentials() {
            print("Validate")
        }
    }
    
    @IBAction func closeButtonTap(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func configureViewControllers() {
        self.closeButton.setTitle("", for: .normal)
        self.configureTextField(emailTextField, label: "Email")
        self.configurePasswordTextField()
        self.configureLoginButton()
        self.viewModelBinding()
    }
    
    private func configurePasswordTextField() {
        let imageOpenEye = UIImage(systemName: "eye.fill")
        let imageCloseEye = UIImage(systemName: "eye.slash.fill")
        
        let passwordButton = UIButton(type: .custom)
        passwordButton.tintColor = .black
        passwordButton.frame = CGRect(
            x: CGFloat(0),
            y: CGFloat(0),
            width: CGFloat(45),
            height: CGFloat(passwordTextField.frame.height)
        )
        passwordButton.setImage(imageOpenEye, for: .selected)
        passwordButton.setImage(imageCloseEye, for: .normal)
        passwordButton.addTarget(self, action: #selector(passViewTap), for: .touchUpInside)
        
        passwordTextField.trailingView = passwordButton
        passwordTextField.trailingViewMode = .always
        passwordTextField.isSecureTextEntry = true
        self.configureTextField(passwordTextField, label: "Password")
    }
    
    @objc func passViewTap(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        passwordTextField.isSecureTextEntry = !sender.isSelected
    }
    
    private func configureLoginButton() {
        let isEnable = isValidEmail && isValidPassword
        loginButton.isEnabled = isEnable
        loginButton.backgroundColor = isEnable ? .loginBtnActive : .textFieldBorder
    }
    
    private func configureTextField(_ sender: MDCOutlinedTextField, label: String) {
        sender.label.text = label
        sender.setOutlineColor(UIColor.textFieldBorder, for: .normal)
        sender.setOutlineColor(UIColor.textFieldBorder, for: .editing)
        sender.setLeadingAssistiveLabelColor(.red, for: .normal)
    }
    
    private func viewModelBinding() {
        emailTextField.rx.text.orEmpty
            .bind(to: viewModel.emailViewModel.data)
            .disposed(by: disposeBag)
        
        emailTextField.rx.controlEvent([.editingChanged])
            .asObservable().subscribe({ [unowned self] _ in
                self.isValidEmail = self.viewModel.emailViewModel.validate()
                self.configureLoginButton()
            })
            .disposed(by: disposeBag)
       
        passwordTextField.rx.text.orEmpty
            .bind(to: viewModel.passwordViewModel.data)
            .disposed(by: disposeBag)
        
        passwordTextField.rx.controlEvent([.editingChanged])
            .asObservable().subscribe({ [unowned self] _ in
                self.isValidPassword = self.viewModel.passwordViewModel.validate()
                self.configureLoginButton()
            })
            .disposed(by: disposeBag)
        
        self.callBacks()
    }
    
    private func callBacks() {
        // Success
        viewModel.isSuccess.asObservable()
            .bind { _ in
            
            }
            .disposed(by: disposeBag)
        
        // Errors
        viewModel.errorMessage.asObservable()
            .bind { errorMessage in
                print(errorMessage)
            }
            .disposed(by: disposeBag)
        
        viewModel.emailViewModel.errorValue.asObservable()
            .bind { errorMessage in
                self.emailTextField.leadingAssistiveLabel.text = errorMessage
            }
            .disposed(by: disposeBag)
        
        viewModel.passwordViewModel.errorValue.asObservable()
            .bind { errorMessage in
                self.passwordTextField.leadingAssistiveLabel.text = errorMessage
            }
            .disposed(by: disposeBag)
    }
}
