//
//  APIService.swift
//  JetDevsHomeWork
//
//  Created by Hardik on 15/12/22.
//

import Foundation
import Alamofire

enum EEndPoints: String {
    case userLogin = "login"
}

class APIService: NSObject {
    
    private static let baseUrl = "https://jetdevs.mocklab.io/"
    static func call(
        url: EEndPoints,
        method: HTTPMethod,
        parameters: [String: Any] = [:],
        encoding: ParameterEncoding = JSONEncoding.default,
        onError: @escaping ((String) -> Void),
        onSuccess: @escaping ((Any) -> Void)
    ) {

        if Connectivity.isConnectedToInternet {
            if let endPoint = (baseUrl + url.rawValue).addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) {
                let headers: HTTPHeaders = [.accept("application/json"), .contentType("application/json")]
                AF.request(endPoint, method: method, parameters: parameters, encoding: encoding, headers: headers)
                    .validate(statusCode: 200..<300)
                    .response { response in
                    debugPrint(response)
                    switch(response.result) {
                    case .success(let data):
                        if let data = data {
                            if let model: APIResponse = try? Utility.getModel(data: data) {
                                if let errorMessage = model.errorMessage, !errorMessage.isEmpty {
                                    onError(errorMessage)
                                } else if let result = Utility.dataToJSON(data: data) as? [String: Any] {
                                    if let dataJson = result["data"] {
                                        onSuccess(dataJson)
                                    } else {
                                        onError(errorResultDataNotFound)
                                    }
                                } else {
                                    onError(errorDataToJsonFailed)
                                }
                            } else {
                                onError(errorModelConvertionFailed)
                            }
                        } else {
                            onError(errorResponseDataNotFound)
                        }
                    case .failure(let error):
                        var message = error.localizedDescription
                        if let httpStatusCode = response.response?.statusCode {
                            switch(httpStatusCode) {
                            case 404:
                                message = errorRequestWasNotMatched
                                if let data = response.data {
                                    if let dict = Utility.dataToJSON(data: data) as? [String: Any] {
                                        if let error = dict["errors"] as? [String] {
                                            message = error.first ?? errorDefaultMessage
                                        }
                                    }
                                }
                            default:
                                break
                            }
                        }
                        onError(message)
                    }
                }
            } else {
                onError(errorInvalidEndpoint)
            }
        } else {
            onError(errorNoInternet)
        }
    }
}

class Connectivity {
    class var isConnectedToInternet: Bool {
        return (NetworkReachabilityManager()?.isReachable) ?? false
    }
}
