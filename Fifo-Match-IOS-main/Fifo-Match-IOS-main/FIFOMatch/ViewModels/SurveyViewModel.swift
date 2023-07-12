//
//  SurveyViewModel.swift
//  FIFOMatch
//
//  Created by Harendra Singh Rathore on 29/03/22.
//

import Foundation

struct SurveyViewModel {
  
  static let shared = SurveyViewModel()
  private let network = Network.shared
  
  //MARK: - Update Survey Information
  func updateSurveyData(parameters: [String: Any], completionHandler: @escaping(_ response: SurveyModel?,_ isSuccess: Bool,_ message: String?) -> Void) {

    let urlString = ServiceUrls.baseUrl + ServiceUrls.hitSurvey
    guard let url = URL(string: urlString) else {
      return
    }

    network.postRequest(requestUrl: url, resultType: SurveyModel.self, parameters: parameters) { result, error in
      
      guard let response = result, error == nil else {
        completionHandler(nil, false, error)
        return
      }
      
      completionHandler(response, true, nil)

    }
  }
  
  //MARK: - Get User Survey Information
  func getSurveyData(completionHandler: @escaping(_ response: SurveyDetailData?, _ isSuccess: Bool,_ message: String?) -> Void) {

    let urlString = ServiceUrls.baseUrl + ServiceUrls.surveyUserDetails
    guard let url = URL(string: urlString) else {
      return
    }

    network.getRequest(requestUrl: url, resultType: SurveyDetailModel.self) { result, error in
      
      guard let response = result, response.status == 200 else {
        completionHandler(nil, false, error)
        return
      }

      if let data = response.data {
        completionHandler(data, true, nil)
      }else {
        completionHandler(nil, false, response.message)
      }
    }
    
  }

}
