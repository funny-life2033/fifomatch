//
//  CompleteProfileViewModel.swift
//  FIFOMatch
//
//  Created by Harendra Singh Rathore on 28/03/22.
//

import Foundation
import UIKit

struct CompleteProfileViewModel {
  
  static let shared = CompleteProfileViewModel()
  private let network = Network.shared
  
  //MARK: - Get Profile Related Information
  func getProfileRelatedInfo(completionHandler: @escaping(_ relationShipList: [ProfileList], _ occupationList: [ProfileList], _ educationList: [ProfileList] , _ isSuccess: Bool,_ message: String?) -> Void) {
    
    let urlString = ServiceUrls.baseUrl + ServiceUrls.profile_List_Data
    guard let url = URL(string: urlString) else {
      return
    }
    
    network.getRequest(requestUrl: url, resultType: ProfileHelperListModel.self) { result, error in
      
      guard let profileRelatedInfo = result else {
        completionHandler([], [], [],false, error)
        return
      }
      
      if profileRelatedInfo.status == 200 {
          
        if let data = profileRelatedInfo.data {
          
          var relationShipList = [ProfileList]()
          var occupationList = [ProfileList]()
          var educationList = [ProfileList]()

          if let relationshipData = data.relationshipStatusData {
            relationShipList = relationshipData
          }
          if let occupationData = data.occupationsData {
            occupationList = occupationData
          }
          if let educationData = data.educationData {
            educationList = educationData
          }
          
          completionHandler(relationShipList, occupationList, educationList, true, profileRelatedInfo.message)
          return
        }
      }
      
      completionHandler([], [], [], false, profileRelatedInfo.message)

    }
  }
  
  //MARK: - Update or Complete Profile
  func updateProfile(parameters: [String: Any], completionHandler: @escaping(_ response: CompleteProfile1Model?,_ isSuccess: Bool,_ message: String?) -> Void) {

    let urlString = ServiceUrls.baseUrl + ServiceUrls.complete_profile
    guard let url = URL(string: urlString) else {
      return
    }

    network.postRequest(requestUrl: url, resultType: CompleteProfile1Model.self, parameters: parameters) { result, error in

      guard let loginInfo = result, error == nil else {
        completionHandler(nil, false, error)
        return
      }
      
      guard loginInfo.status == 200 else {
        completionHandler(nil, false, loginInfo.message)
        return
      }

      completionHandler(loginInfo, true, nil)
    }
  }
  
  //MARK: - Update Profile Images
  func uploadProfileImages(images: [ProfileImage], completionHandler: @escaping(_ response: CompleteProfile1Model?,_ isSuccess: Bool,_ message: String?) -> Void) {
    
    let urlString = ServiceUrls.baseUrl + ServiceUrls.upload_Photos
    
    guard let url = URL(string: urlString) else {
      return
    }

    network.postRequestMulitpleImages(images: images, requestUrl: url, resultType: CompleteProfile1Model.self) { result, error in
      
      guard let response = result, response.status == 200 else {
        completionHandler(nil, false, error)
        return
      }

      completionHandler(response, true, nil)
    }
  }
  
  //MARK: - Verifiy Profile Images
  func verificationProfileImages(images: [String: UIImage?], completionHandler: @escaping(_ response: CompleteProfile1Model?,_ isSuccess: Bool,_ message: String?) -> Void) {
    
    let urlString = ServiceUrls.baseUrl + ServiceUrls.user_verification
    
    guard let url = URL(string: urlString) else {
      return
    }
    
    network.postRequest(images: images, requestUrl: url, resultType: CompleteProfile1Model.self, parameters: [:]) { result, error in
      
      guard let response = result, error == nil else {
        completionHandler(nil, false, error)
        return
      }
      
      completionHandler(response, true, nil)
    }
  }
  
  //MARK: - Delete Profile Images
  func deleteProfile(by id: String, completionHandler: @escaping(_ response: CommonModel?,_ isSuccess: Bool,_ message: String?) -> Void) {
    
    let urlString = ServiceUrls.baseUrl + ServiceUrls.delete_photo
    
    guard let url = URL(string: urlString) else {
      return
    }
    
    network.postRequest(requestUrl: url, resultType: CommonModel.self, parameters: ["id":id]) { result, error in
      
      guard let response = result, error == nil else {
        completionHandler(nil, false, error)
        return
      }
      
      completionHandler(response, true, nil)
    }
  }
  
}
