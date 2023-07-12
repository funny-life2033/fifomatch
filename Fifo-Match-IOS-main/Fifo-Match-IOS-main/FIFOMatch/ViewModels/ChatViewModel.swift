//
//  ChatViewModel.swift
//  FIFOMatch
//
//  Created by Kr . Pushpendra Singh Chouhan on 11/04/22.
//

import Foundation

struct ChatViewModel {
  
  static let shared = ChatViewModel()
  private let network = Network.shared
  
  func sendNotification(params: [String: Any], completionHandler: @escaping(_ response: CreateChatModel?, _ isSuccess: Bool,_ message: String?) -> Void) {
    
    let urlString = ServiceUrls.baseUrl + ServiceUrls.send_notification
    guard let url = URL(string: urlString) else {
      return
    }
    
    network.postRequest(requestUrl: url, resultType: CreateChatModel.self, parameters: params) { result, error in
      
      guard let response = result else {
        completionHandler(nil, false, error)
        return
      }
      
      completionHandler(response, true, nil)
    }
  
  }
  
  func createChat(params: [String: Any], completionHandler: @escaping(_ response: CreateChatModel?, _ isSuccess: Bool,_ message: String?) -> Void) {
    
    let urlString = ServiceUrls.baseUrl + ServiceUrls.create_Chat
    guard let url = URL(string: urlString) else {
      return
    }
    
    network.postRequest(requestUrl: url, resultType: CreateChatModel.self, parameters: params) { result, error in
      
      guard let response = result else {
        completionHandler(nil, false, error)
        return
      }
      
      completionHandler(response, true, nil)
    }
  }
  
  func deletChat(chatNode: String, completionHandler: @escaping(_ response: CommonModel?, _ isSuccess: Bool,_ message: String?) -> Void) {
    
    let urlString = ServiceUrls.baseUrl + ServiceUrls.deleteChat
    guard let url = URL(string: urlString) else {
      return
    }
    
    network.postRequest(requestUrl: url, resultType: CommonModel.self, parameters: ["node": chatNode]) { result, error in
      
      guard let response = result else {
        completionHandler(nil, false, error)
        return
      }
      
      completionHandler(response, true, nil)
    }
  }
  
}

