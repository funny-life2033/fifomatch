//
//  NotificationViewModel.swift
//  FIFOMatch
//
//  Created by Harendra Singh Rathore on 01/04/22.
//

import Foundation

struct NotificationViewModel {
  
  static let shared = NotificationViewModel()
  private let network = Network.shared


  func getNotifications(completionHandler: @escaping(_ response: NotificationModel?, _ isSuccess: Bool,_ message: String?) -> Void) {
    
    let urlString = ServiceUrls.baseUrl + ServiceUrls.get_Notificaition
    guard let url = URL(string: urlString) else {
      return
    }
    
    network.getRequest(requestUrl: url, resultType: NotificationModel.self) { result, error in
      
      guard let response = result else {
        completionHandler(nil, false, error)
        return
      }
      
      completionHandler(response, true, nil)
      
    }
  }
  
  func clearAllNotifications(completionHandler: @escaping(_ response: ClearNotificationModel?, _ isSuccess: Bool,_ message: String?) -> Void) {
    
    let urlString = ServiceUrls.baseUrl + ServiceUrls.clearNotification
    guard let url = URL(string: urlString) else {
      return
    }
    
    network.getRequest(requestUrl: url, resultType: ClearNotificationModel.self) { result, error in
      
      guard let response = result else {
        completionHandler(nil, false, error)
        return
      }
      
      completionHandler(response, true, nil)
      
    }
  }
  
}
