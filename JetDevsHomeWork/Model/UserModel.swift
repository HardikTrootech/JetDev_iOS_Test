//
//  UserModel.swift
//  JetDevsHomeWork
//
//  Created by Hardik on 15/12/22.
//

import Foundation

struct UserModel: Codable {
    
    var userId: Int?
    var userName: String?
    var userProfileUrl: String?
    var createdAt: String?
    var displayCreatedAt: String {
        if let createdAt = createdAt {
            let date = Utility.getDateFromString(string: createdAt)
            return "Created \(Utility.getTimeAgo(date: date))"
        }
        return ""
    }
    
    private enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case userName = "user_name"
        case userProfileUrl = "user_profile_url"
        case createdAt = "created_at"
    }
}
