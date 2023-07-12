//
//  SignUpViewModel.swift
//  FIFOMatch
//
//  Created by Harendra Singh Rathore on 28/03/22.
//

import Foundation

struct SignUpViewModel {
  
  static let shared = SignUpViewModel()
  
  let network = Network.shared
  
  //MARK: - request for Otp by Mobile Number
  func requestForSignUpOtp(mobileNumber: String, countryCode: String, completionHandler: @escaping(_ otp: Int?, _ isSuccess: Bool,_ message: String?) -> Void) {
    
    let urlString = ServiceUrls.baseUrl + ServiceUrls.sign_up_Otp
    guard let url = URL(string: urlString) else {
      return
    }
    
    let params: [String: Any] = ["mobile_number": mobileNumber,
                                 "country_code": countryCode]
    
    network.postRequest(requestUrl: url, resultType: SignUpOtpModel.self, parameters: params) { result, error in
     
      guard let otpResult = result else {
        completionHandler(nil, false, error)
        return
      }
      debugPrint("OTP request response = \(otpResult)")
      let message = otpResult.message
      let otp = otpResult.data?.otp
      
      if otpResult.status == 200 {
        completionHandler(otp, true, message)
      }else {
        completionHandler(nil, false, message)
      }
      
    }
  }
  
  //MARK: - SignUp
  func requestForSignUp(parameters: [String: Any], completionHandler: @escaping(_ response: LoginSignUpModel?,_ isSuccess: Bool,_ message: String?) -> Void) {

    let urlString = ServiceUrls.baseUrl + ServiceUrls.sign_up
    guard let url = URL(string: urlString) else {
      return
    }

    network.postRequest(requestUrl: url, resultType: LoginSignUpModel.self, parameters: parameters) { result, error in

      guard let loginInfo = result else {
        completionHandler(nil, false, error)
        return
      }

      completionHandler(loginInfo, true, nil)
    }
  }
  
}
