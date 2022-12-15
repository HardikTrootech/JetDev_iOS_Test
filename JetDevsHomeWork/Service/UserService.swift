//
//  UserService.swift
//  JetDevsHomeWork
//
//  Created by Hardik on 15/12/22.
//

import Foundation

struct UserService {
    
    private static let userKey = "USER_DATA"
    private static func setLocalUser(value: Data) {
        let defaults = UserDefaults.standard
        defaults.set(value, forKey: userKey)
        defaults.synchronize()
    }
    
    static func getUser() -> UserModel? {
        if let localData: Data = getData(type: Data.self) {
            if let user: UserModel = try? Utility.getModel(data: localData) {
                return user
            }
        }
        return nil
    }
    
    private static func getData(type: Data.Type) -> Data? {
        let defaults = UserDefaults.standard
        let value = defaults.object(forKey: userKey) as? Data
        return value
    }
    
    static func getUserFromJson(_ dict: Any) -> UserModel? {
        if let data = Utility.jsonToData(json: dict) {
            self.setLocalUser(value: data)
            if let model: UserModel = try? Utility.getModel(data: data) {
                return model
            }
        }
        return nil
    }
}
