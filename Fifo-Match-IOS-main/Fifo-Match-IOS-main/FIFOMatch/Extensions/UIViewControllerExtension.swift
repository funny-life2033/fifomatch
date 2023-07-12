//
//  UIViewControllerExtension.swift
//  FIFOMatch
//
//  Created by Harendra Singh Rathore on 04/04/22.
//

import Foundation
import UIKit

extension UIViewController {
  
  func checkStatus(status: Int?, message: String?) -> Bool {
    
    guard let status = status, let message = message else {
      return false
    }
    
    
    if status == 200 {
      if message ==  "Your plan is expired." {
        
        UserDefault.shared.saveSubscriptionStatus(status: false)
        Common.showAlert(alertMessage: message, alertButtons: ["Ok"]) { (bt) in
          appdelegate.openSubscriptionPage()

        }
        
        return false
      }
      return true
    }
    
    if status == 401 || status == 402 || status == 403 {
      Common.showAlert(alertMessage: Messages.TOKEN_EXPIRE.rawValue, alertButtons: ["Ok"]) { (bt) in
        
          UserDefault.shared.logoutUser()
          appdelegate.setinitalViewController()
      }
    }else {
      Common.showAlert(alertMessage: message, alertButtons: ["Ok"]) { (bt) in
      }
    }
    
    return false
  }
  
  func checkStatus1(status: Int?, message: String?) -> Bool {
    
    guard let status = status, let message = message else {
      return false
    }
    
    
    if status == 200 || status == 201  {
      return true
    }
  
    Common.showAlert(alertMessage: message, alertButtons: ["Ok"]) { (bt) in
    }
    return false
  }
  
  func alertBoxWithAction(message: String, btnTitle: String ,okaction:@escaping (()->Void))
  {
    
    let alert = UIAlertController(title: kAppName, message: message, preferredStyle: .alert)
    let action=UIAlertAction(title: btnTitle, style: .default) { (action) in
      okaction()
    }
    
    let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    
    alert.addAction(action)
    alert.addAction(cancel)
    present(alert, animated: true, completion: nil)
  }
  
  
  var className: String {
      return NSStringFromClass(self.classForCoder).components(separatedBy: ".").last!;
  }
  
}

