//
//  AppManager.swift
//  YogaApp
//
//  Created by Mac120 on 10/30/18.
//  Copyright © 2018 Octal. All rights reserved.
//

import UIKit
//import Toast_Swift
//import Alertift
import MBProgressHUD
//import SVProgressHUD

class AppManager {

    var appDelegate: AppDelegate?
    
    class func sharedAppDelegate() -> AppDelegate? {
        return UIApplication.shared.delegate as? AppDelegate
    }
    
    func saveLatLong(latitute :Double, longitute: Double, address:String) {
        
        UserDefaults.standard.set(latitute, forKey: "latitude")
        UserDefaults.standard.set(longitute, forKey: "longitute")
        UserDefaults.standard.set(address, forKey: "userAddress")
    }
    

   
    
  
    
//    // MARK: - Alert Methods
//    func showAlertSingle(_ title: String?, message msg: String?, buttonTitle btnTitle: String?, completion completionBlock: @escaping () -> Void) {
//        Alertift.alert(title: title, message: msg)
//            .action(.default(btnTitle)){ (_, _, _) in
//                // delete post
//                completionBlock()
//            }
//            .show()
//    }
//    
//    func showAlertMulti(withHandler title: String?, message msg: String?, buttonTitle1 btnTitle1: String?, buttonTitle2 btnTitle2: String?, completion completionBlock: @escaping () -> Void) {
//        
//        Alertift.alert(title: title, message: msg)
//            .action(.cancel(btnTitle1))
//            
//            .action(.default(btnTitle2)){ (_, _, _) in
//                // delete post
//                completionBlock()
//            }
//            .show()
//    }
//    
    // MARK: - ActivityIndicator
    func startActivityIndicator(_ msg: String?="", sender: UIView) {
        
        let hud = MBProgressHUD.showAdded(to: sender, animated: true)
        hud.mode = MBProgressHUDMode.indeterminate
        hud.tintColor = UIColor.black
        if((msg?.count)! > 0) {
            hud.label.text = msg
        }
        
    }
    
    func stopActivityIndicator(_ sender: UIView) {
        
        MBProgressHUD.hide(for: sender, animated: true)
        
    }
    
    /*************************************************************/
    //MARK:- Clear All UserDefaults Values
    /*************************************************************/
//    open class func clearAllAppUserDefaults() {
//
//        for key in UserDefaults.standard.dictionaryRepresentation().keys {
//            if !(key == "device_token" || key == "remember_email" || key == "remember_password" || key == "intro") {
//                Constants.kUserDefaults.removeObject(forKey: key)
//            }
//        }
//        UserDefaults.standard.synchronize()
//        //printDebug(APP_USER_DEFAULTS.dictionaryRepresentation().keys.array.count)
//        //printDebug("ClearAllUserDefaults")
//    }
    
    
    // MARK: - Validation
    func validateEmail(with email: String?) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }
    
    // MARK: - convertStringToDate
    func convertString(toDate dateStr: String?, dateFormate formate: String?) -> Date? {
        // convert to date
        let dateFormat = DateFormatter()
        // ignore +11 and use timezone name instead of seconds from gmt
        dateFormat.dateFormat = formate ?? ""
        let date: Date? = dateFormat.date(from: dateStr ?? "")
        return date
    }
    
    // MARK: - convertStringToDate
    func convertDate(toString date: Date?, dateFormate formate: String?) -> String? {
        let dateFormat2 = DateFormatter()
        dateFormat2.dateFormat = formate ?? ""
        var dateString: String? = nil
        if let aDate = date {
            dateString = dateFormat2.string(from: aDate)
        }
        print("DateString: \(dateString ?? "")")
        return dateString
    }
    
    
    // MARK: - JsonEncoding
    public class func stringifyJson(_ value: Any, prettyPrinted: Bool = true) -> String! {
        let options = prettyPrinted ? JSONSerialization.WritingOptions.prettyPrinted : nil
        if JSONSerialization.isValidJSONObject(value) {
            do {
                let data = try JSONSerialization.data(withJSONObject: value, options: options!)
                if let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                    return string as String
                }
            }  catch {
                return ""
            }
        }
        return ""
    }
    
    // MARK: - ResponceStatus
    public class func getInt(for value : Any?) -> Int? {
        
        if let stateCode = value as? String {
            return Int(stateCode)
            
        }else if let stateCodeInt = value as? Int {
            return stateCodeInt
            
        }
        return nil
        
    }
    
    
    
}

public extension Dictionary {
    
    static func +<Key, Value> (lhs: [Key: Value], rhs: [Key: Value]) -> [Key: Value] {
        var result = lhs
        rhs.forEach{ result[$0] = $1 }
        return result
    }
    
    mutating func merge(with dictionary: [Key: Value]) {
        dictionary.forEach { updateValue($1, forKey: $0) }
    }
    
    func merged(with dictionary: [Key: Value]) -> [Key: Value] {
        var dict = self
        dict.merge(with: dictionary)
        return dict
    }
}
    

