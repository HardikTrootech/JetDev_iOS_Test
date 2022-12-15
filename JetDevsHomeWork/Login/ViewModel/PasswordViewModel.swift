//
//  PasswordViewModel.swift
//  JetDevsHomeWork
//
//  Created by Hardik on 14/12/22.
//

import Foundation
import RxCocoa

class PasswordViewModel: ValidateViewModel {
    var errorMessage: String = "Password lenght should be between 6 to 12 "
    
    var data: BehaviorRelay<String> = BehaviorRelay(value: "")
    
    var errorValue: BehaviorRelay<String> = BehaviorRelay(value: "")
    
    func validate() -> Bool {
        
        guard validateLength(text: data.value, size: (6, 12)) else {
            errorValue.accept(errorMessage)
            return false
        }
        errorValue.accept("")
        return true
    }
    
    func validateLength(text: String, size: (min: Int, max: Int)) -> Bool {
        return (size.min...size.max).contains(text.count)
    }
    
}
