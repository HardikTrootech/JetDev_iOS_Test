//
//  APIResponseModel.swift
//  JetDevsHomeWork
//
//  Created by Hardik on 15/12/22.
//

import Foundation

struct APIResponse: Codable {
    let result: Int?
    let errorMessage: String?
    
    private enum CodingKeys: String, CodingKey {
        case result, errorMessage = "error_message"
    }
}
