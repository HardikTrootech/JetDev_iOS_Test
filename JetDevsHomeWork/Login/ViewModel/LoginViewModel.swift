//
//  LoginViewModel.swift
//  JetDevsHomeWork
//
//  Created by Hardik on 14/12/22.
//

import Foundation
import RxCocoa
import RxSwift

protocol ValidateViewModel {
    var errorMessage: String { get }
    var data: BehaviorRelay<String> { get set }
    var errorValue: BehaviorRelay<String> { get set }
    
    func validate() -> Bool
}

class LoginModel {
    var email = ""
    var password = ""
    
    convenience init(email: String, password: String) {
        self.init()
        self.email = email
        self.password = password
    }
}

class LoginViewModel {
    let model: LoginModel = LoginModel()
    let disposeBag = DisposeBag()
    
    let emailViewModel = EmailViewModel()
    let passwordViewModel = PasswordViewModel()
    
    let isSuccess: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    let isLoading: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    let errorMessage: BehaviorRelay<String> = BehaviorRelay<String>(value: "")
    
    func validateCredentials() -> Bool {
        return emailViewModel.validate() && passwordViewModel.validate()
    }
    
    func loginUser() {
        model.email = emailViewModel.data.value
        model.password = passwordViewModel.data.value
    }
}
