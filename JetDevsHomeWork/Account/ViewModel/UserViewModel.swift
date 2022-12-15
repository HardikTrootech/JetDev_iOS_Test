//
//  UserViewModel.swift
//  JetDevsHomeWork
//
//  Created by Hardik on 15/12/22.
//

import Foundation
import RxCocoa
import RxSwift

class UserViewModel {
    
    let model: BehaviorRelay<UserModel?> = BehaviorRelay<UserModel?>(value: nil)
    let disposeBag = DisposeBag()
}
