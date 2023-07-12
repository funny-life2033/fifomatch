//
//  SubscriptionViewModel.swift
//  FIFOMatch
//
//  Created by Harendra Singh Rathore on 29/04/22.
//

import Foundation
import SwiftyStoreKit

struct SubscriptionViewModel {
  
  static let shared = SubscriptionViewModel()
  private let network = Network.shared
  
  func getSubscriptionInfo(completionHandler: @escaping(_ response: [String: Any]?, _ isSuccess: Bool,_ message: String?) -> Void) {
    
    guard let receiptURL = Bundle.main.appStoreReceiptURL, let receiptString = try? NSData(contentsOf: receiptURL).base64EncodedString(options: [])  else {
      return
    }
    
    let requestContents: [String: Any] = [
        "receipt-data": receiptString,
        "password": "2b63f5bd6c2c492a9793043f81c6f412",
        "exclude-old-transactions" : true
    ]
    
#if DEBUG
    let urlString = "https://sandbox.itunes.apple.com/verifyReceipt"
#else
    let urlString = "https://buy.itunes.apple.com/verifyReceipt"
#endif
    
    network.getPurchasedSubscriptions(url: urlString, method: .post, param: requestContents) { success, message, response in
      
      guard success else {
        debugPrint("error = \(message)")
        completionHandler(nil, false, message)
        return
      }
      completionHandler(response, true, "")
    
    }
  }
  
  
}
