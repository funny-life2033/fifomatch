//
//  LoginViewModel.swift
//  FIFOMatch
//
//  Created by Harendra Singh Rathore on 25/03/22.
//

import Foundation
import Alamofire

struct LoginViewModel {
  
  static let shared = LoginViewModel()
  
  let network = Network.shared
  
  //MARK: - Get Otp by Mobile Number
  func getLoginOtp(mobileNumber: String, countryCode: String, completionHandler: @escaping(_ otp: String?, _ isSuccess: Bool,_ message: String?) -> Void) {
    
    let urlString = ServiceUrls.baseUrl + ServiceUrls.send_OTP
    guard let url = URL(string: urlString) else {
      return
    }
    
    let params: [String: Any] = ["mobile": mobileNumber,
                                 "country_code": countryCode]
    
    network.postRequest(requestUrl: url, resultType: LoginOtpModel.self, parameters: params) { result, error in
     
      
      guard let otpResult = result else {
        completionHandler("", false, error)
        return
      }
      debugPrint("OTP request response = \(otpResult)")
      let message = otpResult.message
      let otp = otpResult.data?.otp
      
      if otpResult.status == 200 {
        completionHandler(otp, true, message)
      }else {
        completionHandler("", false, message)
      }
      
    }
  }
  
  //MARK: - Login 
  func getLoginData(parameters: [String: Any], completionHandler: @escaping(_ response: LoginSignUpModel?,_ isSuccess: Bool,_ message: String?) -> Void) {

    let urlString = ServiceUrls.baseUrl + ServiceUrls.login
    guard let url = URL(string: urlString) else {
      return
    }

    network.postRequest(requestUrl: url, resultType: LoginSignUpModel.self, parameters: parameters) { result, error in
      
      guard let response = result else {
        completionHandler(nil, false, error)
        return
      }
      
      completionHandler(response, true, nil)
      
//      guard let result = result else {
//        completionHandler(nil, false, error)
//        return
//      }
//
//      let message = result.message
//
//      if result.status == 200 {
//        completionHandler(result, true, nil)
//      }else {
//        completionHandler(nil, false, message)
//      }
    }
  }
  
}
