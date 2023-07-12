//
//  HomeViewModel.swift
//  FIFOMatch
//
//  Created by Harendra Singh Rathore on 30/03/22.
//

import Foundation

struct HomeViewModel {
  
  static let shared = HomeViewModel()
  private let network = Network.shared
  
  //MARK: - Get Home Information
  func getHomeData(parameters: [String: Any], completionHandler: @escaping(_ response: HomeModel?,_ isSuccess: Bool,_ message: String?) -> Void) {

    let urlString = ServiceUrls.baseUrl + ServiceUrls.matchListing
    guard let url = URL(string: urlString) else {
      return
    }

    network.postRequest(requestUrl: url, resultType: HomeModel.self, parameters: parameters) { result, error in

      guard let response = result else {
        completionHandler(nil, false, error)
        return
      }

      completionHandler(response, true, nil)
    }
  }
  
  func getUserDetail(by userId: String, completionHandler: @escaping(_ response: UserDetailsModel?, _ isSuccess: Bool,_ message: String?) -> Void) {
    
    let lat = UserDefault.shared.getlatitude()
    let long = UserDefault.shared.getLongitude()
    
    let urlString = ServiceUrls.baseUrl + ServiceUrls.userDetails + userId + "&lat=\(lat)&lng=\(long)"
    guard let url = URL(string: urlString) else {
      return
    }
    
    network.getRequest(requestUrl: url, resultType: UserDetailsModel.self) { result, error in
      
      guard let response = result else {
        completionHandler(nil, false, error)
        return
      }

      completionHandler(response, true, nil)
      
    }
  }
  
  //MARK: - Like User
  func likelUser(by userId: String, type: String, completionHandler: @escaping(_ response: LikeSaveCancelModel?,_ isSuccess: Bool,_ message: String?) -> Void) {
    
    var slug = ""
    if type == "like" {
      slug = ServiceUrls.likeUser
    }else {
      slug = ServiceUrls.dislikeUser
    }

    let urlString = ServiceUrls.baseUrl + slug
    guard let url = URL(string: urlString) else {
      return
    }
    
    let params = ["user_id": userId]

    if type == "like"{
      network.postRequest(requestUrl: url, resultType: LikeSaveCancelModel.self, parameters: params) { result, error in
        
        guard let response = result else {
          completionHandler(nil, false, error)
          return
        }
        
        completionHandler(response, true, nil)
      }
    }else {
      network.getParamtersRequest(requestUrl: url, resultType: LikeSaveCancelModel.self, parameters: params) { result, error in
       
        guard let response = result else {
          completionHandler(nil, false, error)
          return
        }
        
        completionHandler(response, true, nil)
      }
    }
  }
  
  //MARK: - Get Liked/Matched Users
  func getLikedUsers(completionHandler: @escaping(_ response: LikeUserModel?, _ isSuccess: Bool,_ message: String?) -> Void) {
    
    let urlString = ServiceUrls.baseUrl + ServiceUrls.likeUsersList
    guard let url = URL(string: urlString) else {
      return
    }
    
    network.getRequest(requestUrl: url, resultType: LikeUserModel.self) { result, error in
      
      guard let response = result, error == nil else {
        completionHandler(nil, false, error)
        return
      }
      
      completionHandler(response, true, nil)
      
    }
  
  }
  
  //MARK: - Save Hide Cancel Users
  func saveHideCancelUser(by userId: String, type: String, apiType: String, completionHandler: @escaping(_ response: LikeSaveCancelModel?,_ isSuccess: Bool,_ message: String?) -> Void) {

    var urlString = ""
    
    if apiType == "add" {
      urlString = ServiceUrls.baseUrl + ServiceUrls.saveUser
    }else {
      urlString = ServiceUrls.baseUrl + ServiceUrls.removeUser
    }
    
    guard let url = URL(string: urlString) else {
      return
    }
    
    let params = [ "user_id": userId,
                   "status": type]

    network.postRequest(requestUrl: url, resultType: LikeSaveCancelModel.self, parameters: params) { result, error in
    
      guard let response = result else {
        completionHandler(nil, false, error)
        return
      }
      
      completionHandler(response, true, nil)
    }
  }
  
  func getViewedSavedHideUsers(by type: String, completionHandler: @escaping(_ response: LikeSavedUserModel?, _ isSuccess: Bool,_ message: String?) -> Void) {
    
    let urlString = ServiceUrls.baseUrl + ServiceUrls.getSavedUser
    guard let url = URL(string: urlString) else {
      return
    }
    
    let params = ["status": type]

    network.getParamtersRequest(requestUrl: url, resultType: LikeSavedUserModel.self, parameters: params) { result, error in
  
      guard let response = result, error == nil else {
        completionHandler(nil, false, error)
        return
      }
      
      completionHandler(response, true, nil)
    }
  
  }
  
  //MARK: - User Active Plan Details
  func getUserActivePlan(completionHandler: @escaping(_ response: ActivePlanModel?, _ isSuccess: Bool,_ message: String?) -> Void) {
    
    let urlString = ServiceUrls.baseUrl + ServiceUrls.activePlan
    guard let url = URL(string: urlString) else {
      return
    }
    
    network.getRequest(requestUrl: url, resultType: ActivePlanModel.self) { result, error in
      
      guard let response = result, error == nil else {
        completionHandler(nil, false, error)
        return
      }
      
      completionHandler(response, true, nil)
      
    }
    
  }
  
  //MARK: - Update Online Time
  func updateOnlineTime(completionHandler: @escaping(_ isSuccess: Bool, _ message: String?) -> Void) {

    let urlString = ServiceUrls.baseUrl + ServiceUrls.updateLiveTime
    guard let url = URL(string: urlString) else {
      return
    }

    network.postRequest(requestUrl: url, resultType: SurveyModel.self, parameters: [:]) { result, error in

      guard result != nil, error == nil else {
        completionHandler(false, error)
        return
      }
      completionHandler(true, nil)

    }

  }
  
  //MARK: - Like User Details
  func getMatchUsersDetail(by id: String, completionHandler: @escaping(_ response: MatchProfileModel?,_ isSuccess: Bool,_ message: String?) -> Void) {

    let urlString = ServiceUrls.baseUrl + ServiceUrls.likeUsersDetails
    guard let url = URL(string: urlString) else {
      return
    }
    
    let params = [ "id": id]
    
    network.getParamtersRequest(requestUrl: url, resultType: MatchProfileModel.self, parameters: params) { result, error in
    
      guard let response = result else {
        completionHandler(nil, false, error)
        return
      }
      
      completionHandler(response, true, nil)
    }
  }

}
