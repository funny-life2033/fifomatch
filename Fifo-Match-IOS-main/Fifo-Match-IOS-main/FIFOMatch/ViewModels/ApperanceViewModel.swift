//
//  ApperanceViewModel.swift
//  FIFOMatch
//
//  Created by Harendra Singh Rathore on 13/04/22.
//

import Foundation

struct ApperanceViewModel {
  
  static let shared = ApperanceViewModel()
  private let network = Network.shared

  func getApperanceData(completionHandler: @escaping(_ response: ApperanceModel?, _ isSuccess: Bool,_ message: String?) -> Void) {
    
    let urlString = ServiceUrls.baseUrl + ServiceUrls.userAppearance
    guard let url = URL(string: urlString) else {
      return
    }
    
    network.getRequest(requestUrl: url, resultType: ApperanceModel.self) { result, error in
      
      guard let response = result else {
        completionHandler(nil, false, error)
        return
      }
      
      completionHandler(response, true, nil)
      
    }
  }
  
}
