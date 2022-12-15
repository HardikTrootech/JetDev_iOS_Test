//
//  Constants.swift
//  JetDevsHomeWork
//
//  Created by Gary.yao on 2021/10/29.
//

import UIKit

let screenFrame: CGRect = UIScreen.main.bounds
let screenWidth = screenFrame.size.width
let screenHeight = screenFrame.size.height

let isIPhoneX = (screenWidth >= 375.0 && screenHeight >= 812.0) ? true : false
let isIPad = UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad ? true : false

let statusBarHeight: CGFloat = isIPhoneX ? 44.0 : 20.0
let navigationBarHeight: CGFloat = 44.0
let statusBarNavigationBarHeight: CGFloat = isIPhoneX ? 88.0 : 64.0

let tabbarSafeBottomMargin: CGFloat = isIPhoneX ? 34.0 : 0.0
let tabBarHeight: CGFloat = isIPhoneX ? (tabBarTrueHeight+34.0) : tabBarTrueHeight
let tabBarTrueHeight: CGFloat = 49.0

let errorResultDataNotFound = "Result data not found"
let errorDataToJsonFailed = "Data to json failed"
let errorModelConvertionFailed = "Model convertion failed"
let errorResponseDataNotFound = "Response data not found"
let errorInvalidEndpoint = "Invalid endpoint"
let errorNoInternet = "No internet connection"
let errorDefaultMessage = "Something went worng"
let errorRequestWasNotMatched = "Request was not matched"

class Utility {
    static func dataToJSON(data: Data) -> Any? {
       do {
           return try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
       } catch let myJSONError {
           print(myJSONError)
       }
       return nil
    }
    
    static func jsonToData(json: Any) -> Data? {
        do {
            return try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted)
        } catch let myJSONError {
            print(myJSONError)
        }
        return nil
    }
    
    static func getModel<T: Decodable>(data: Data) throws -> T? {
        let decoder = JSONDecoder()
        do {
            return try decoder.decode(T.self, from: data)
        } catch (let error) {
            print("Decoding Error: \(error.localizedDescription)")
        }
        return nil
    }
    
    static func clearAllLocalData() {
        if let domain = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: domain)
            UserDefaults.standard.synchronize()
        }
    }
    
    static func showAlert(
        controller: UIViewController,
        title: String = "APP",
        message: String,
        buttonText: String = "Ok",
        action: @escaping () -> ()
    ) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                
        let okAction = UIAlertAction(title: buttonText, style: .default) { _ in
            action()
        }
        
        alertController.addAction(okAction)
        controller.present(alertController, animated: true, completion: nil)
    }
//    2020-12-07T04:30:49.822Z
    static func getDateFromString(string: String, formate: String = "YYYY-MM-dd'T'HH:mm:ss.SSS'Z'") -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = formate
        if let date = formatter.date(from: string) {
            return date.toLocalTime()
        }
        return Date()
    }
    
    static func getTimeAgo(date: Date) -> String {
        var timeAgo: String {
            let currentDate = Date().toLocalTime()
            
            if currentDate.years(from: date) > 0 {
                return "\(abs(date.years(from: currentDate))) year\((date.years(from: currentDate) > 1) ? "s": "") ago"
            }
            
            if currentDate.months(from:  date) > 0 {
                return "\(abs(date.months(from: currentDate))) month\((date.months(from: currentDate) > 1) ? "s": "") ago"
            }
            
            if currentDate.weeks(from: date) > 0 {
                return "\(abs(date.weeks(from: currentDate))) week\((date.weeks(from: currentDate) > 1) ? "s": "") ago"
            }
            
            if currentDate.days(from: date) > 0 {
                return "\(abs(date.days(from: currentDate))) day\((date.days(from: currentDate) > 1) ? "s": "") ago"
            }
            
            if currentDate.hours(from: date) > 0 {
                return "\(abs(date.hours(from: currentDate))) hour\((date.hours(from: currentDate) > 1) ? "s": "") ago"
            }
            
            if currentDate.minutes(from: date) > 0 {
                return "\(abs(date.minutes(from: currentDate))) minute\((date.minutes(from: currentDate) > 1) ? "s": "") ago"
            }
            
            if currentDate.seconds(from: date) > 0 {
                return "\(abs(date.seconds(from: currentDate))) second\((date.seconds(from: currentDate) > 1) ? "s": "") ago"
            }
            
            return "Now"
        }
        return timeAgo
    }
}
