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
    
    let userModel: BehaviorRelay<UserModel?> = BehaviorRelay<UserModel?>(value: nil)
    let isLoading: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    let errorMessage: BehaviorRelay<String> = BehaviorRelay<String>(value: "")
    
    func validateCredentials() -> Bool {
        return emailViewModel.validate() && passwordViewModel.validate()
    }
    
    func loginUser() {
        model.email = emailViewModel.data.value
        model.password = passwordViewModel.data.value
        let reqParams = [
            "email": model.email,
            "password": model.password
        ]
        isLoading.accept(true)
        APIService.call(url: .userLogin, method: .post, parameters: reqParams, onError: { errorMessage in
            self.isLoading.accept(false)
            self.errorMessage.accept(errorMessage)
            print("APIService On Error: \(errorMessage)")
        }, onSuccess: { data in
            self.isLoading.accept(false)
            print("APIService On Success: \(data as? [String: Any])")
            if let dict = (data as? [String: Any]), let userJson = dict["user"] {
                if let user = UserService.getUserFromJson(userJson) {
                    self.userModel.accept(user)
                } else {
                    self.errorMessage.accept(errorDefaultMessage)
                }
            } else {
                self.errorMessage.accept(errorDefaultMessage)
            }
        })
    }
}
