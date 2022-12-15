//
//  EmailViewModel.swift
//  JetDevsHomeWork
//
//  Created by Hardik on 14/12/22.
//

import Foundation
import RxCocoa

class EmailViewModel: ValidateViewModel {
    
    var errorMessage: String = "Please enter valid email"
    
    var data: BehaviorRelay<String> = BehaviorRelay(value: "")
    
    var errorValue: BehaviorRelay<String> = BehaviorRelay(value: "")
    
    func validate() -> Bool {
        
        guard validatePattern(text: data.value) else {
            errorValue.accept(errorMessage)
            return false
        }
        errorValue.accept("")
        return true
    }
    
    func validatePattern(text: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: text)
    }
    
}
