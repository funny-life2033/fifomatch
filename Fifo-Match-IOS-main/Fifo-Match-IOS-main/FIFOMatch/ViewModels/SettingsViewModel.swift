//
//  SettingsViewModel.swift
//  FIFOMatch
//
//  Created by Harendra Singh Rathore on 30/03/22.
//

import Foundation

struct SettingsViewModel {
  
  static let shared = SettingsViewModel()
  private let network = Network.shared
  
  func getHtmlData(from: String, completionHandler: @escaping(_ response: String, _ isSuccess: Bool,_ message: String?) -> Void) {
    
    var slug = ""
    
    switch from {
    case "About us":
      slug = ServiceUrls.aboutUS
    case "Privacy policy":
      slug = ServiceUrls.privacyPolicy
    case "Terms & Conditions":
      slug = ServiceUrls.termAndCondition
    case "Help":
      slug = ServiceUrls.FAQUrl
    case "Contact us":
      slug = ServiceUrls.contactUS
    default:
      slug = ServiceUrls.aboutUS
    }
    
    let urlString = ServiceUrls.baseUrl + "pages?slug=" + slug
    guard let url = URL(string: urlString) else {
      return
    }
      
      debugPrint("Requested URL = ", url)
    
    network.getHtmlData(requestUrl: url) { result, message in
      
      guard let data = result, message == nil else {
        completionHandler("", false, message)
        return
      }
      
      completionHandler(data, true, nil)
    }
  }
  
  //MARK: - Update Login Or Notification Status
  func updateLoginNotificationStatus(status: String, type: String, completionHandler: @escaping(_ response: SurveyModel?, _ isSuccess: Bool,_ message: String?) -> Void) {
    
    var slug = ""
  
    if type == "notification" {
      slug = ServiceUrls.notificationStatus
    }else {
      slug = ServiceUrls.loginStatus
    }
    
    let urlString = ServiceUrls.baseUrl + slug
    guard let url = URL(string: urlString) else {
      return
    }
    
    let params = ["status": status]
    
    network.postRequest(requestUrl: url, resultType: SurveyModel.self, parameters: params) { result, error in
    
      guard let response = result else {
        completionHandler(nil, false, error)
        return
      }
      
      completionHandler(response, true, nil)
    }
    
  }
  
}
