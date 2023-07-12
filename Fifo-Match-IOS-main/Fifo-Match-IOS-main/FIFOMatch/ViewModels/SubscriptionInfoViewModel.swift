//
//  SubscriptionInfoViewModel.swift
//  FIFOMatch
//
//  Created by Harendra Singh Rathore on 29/03/22.
//

import Foundation

struct SubscriptionInfoViewModel {
  
  static let shared = SubscriptionInfoViewModel()
  private let network = Network.shared
  
  //MARK: - Get Subscription Plan Details
  func getSubscriptionDetails(completionHandler: @escaping(_ response: [SubscriptionInfoData]? , _ isSuccess: Bool,_ message: String?) -> Void) {
    
    let urlString = ServiceUrls.baseUrl + ServiceUrls.planDetails
    guard let url = URL(string: urlString) else {
      return
    }
    
    network.getRequest(requestUrl: url, resultType: SubscriptionInfoModel.self) { result, error in
      
      guard let planDetails = result else {
        completionHandler(nil, false, error)
        return
      }
      
      if planDetails.status == 200 {
        if let data = planDetails.data {
          completionHandler(data, true, "")
        }
        
      }else {
        completionHandler(nil, false, planDetails.message)
      }
      
    }
  
  }
  
  func sendSubscriptionDetailsToServer(parameters: [String: Any], completionHandler: @escaping(_ response: SubscriptionUpdateModel? , _ isSuccess: Bool,_ message: String?) -> Void) {
    
    let urlString = ServiceUrls.baseUrl + ServiceUrls.save_In_App_Purchase
    guard let url = URL(string: urlString) else {
      return
    }

  
    network.postRequest(requestUrl: url, resultType: SubscriptionUpdateModel.self, parameters: parameters) { result, error in
      
      guard let planDetails = result else {
        completionHandler(nil, false, error)
        return
      }
      
      if planDetails.status == 200 {
        completionHandler(planDetails, true, nil)
      }else {
        completionHandler(nil, false, planDetails.message)
      }
      
    }
  }
  
}
