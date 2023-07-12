//
//  UserProfileViewModel.swift
//  FIFOMatch
//
//  Created by Harendra Singh Rathore on 05/04/22.
//

import Foundation
import UIKit

struct UserProfileViewModel {
  
  static let shared = UserProfileViewModel()
  private let network = Network.shared
  
  //MARK: - Get User Profile Details
  func getUserProfileDetails(completionHandler: @escaping(_ response: UserProfileDetailsModel?, _ isSuccess: Bool,_ message: String?) -> Void) {
    
    let urlString = ServiceUrls.baseUrl + ServiceUrls.profile
    guard let url = URL(string: urlString) else {
      return
    }
    
    network.getRequest(requestUrl: url, resultType: UserProfileDetailsModel.self) { result, error in
      
      guard let response = result else {
        completionHandler(nil, false, error)
        return
      }

      completionHandler(response, true, nil)
      
    }
  }
  
  //MARK: - Update User Profile Details
  func updateUserDetails(images: [String: UIImage?], params: [String: Any], completionHandler: @escaping(_ response: SurveyModel?, _ isSuccess: Bool,_ message: String?) -> Void) {
    
    let urlString = ServiceUrls.baseUrl + ServiceUrls.profile
    guard let url = URL(string: urlString) else {
      return
    }
    
    network.postRequest(images: images, requestUrl: url, resultType: SurveyModel.self, parameters: params) { result, error in
      
      guard let response = result else {
        completionHandler(nil, false, error)
        return
      }

      completionHandler(response, true, nil)
    }
    
  }
  
  //MARK: - Logout or Delete Account
  func logoutUser(type: LogoutTypes, completionHandler: @escaping(_ response: CommonModel?, _ isSuccess: Bool,_ message: String?) -> Void) {
    
    let urlString = ServiceUrls.baseUrl + ServiceUrls.log_Out
    guard let url = URL(string: urlString) else {
      return
    }
    
    let params: [String: Any] = ["is_delete": type.rawValue]
    
    network.postRequest(requestUrl: url, resultType: CommonModel.self, parameters: params) { result, error in
      
      guard let response = result else {
        completionHandler(nil, false, error)
        return
      }

      completionHandler(response, true, nil)
    }
  }
  
  //MARK: - Deactivate Account
  func deactivateAccount(completionHandler: @escaping(_ response: CommonModel?, _ isSuccess: Bool,_ message: String?) -> Void) {
    
    let urlString = ServiceUrls.baseUrl + ServiceUrls.pauseAccount
    guard let url = URL(string: urlString) else {
      return
    }
    
    network.postRequest(requestUrl: url, resultType: CommonModel.self, parameters: [:]) { result, error in
      
      guard let response = result else {
        completionHandler(nil, false, error)
        return
      }

      completionHandler(response, true, nil)
    }
  }
  
}

enum LogoutTypes: Int {
  case logout = 0
  case deleteAccount = 1
}
