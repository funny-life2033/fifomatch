//
//  LikeSavedUserModel.swift
//  FIFOMatch
//
//  Created by Harendra Singh Rathore on 01/04/22.
//

import Foundation

// MARK: - LikeSavedUserModel
struct LikeSavedUserModel: Decodable {
  let msg, message: String?
  let status: Int?
  let data: LikeSavedUserData?
}

// MARK: - LikeSavedUserData
struct LikeSavedUserData: Decodable {
  let count: Int?
  let allUsers: [LikeSavedUserData1]?
  
  enum CodingKeys: String, CodingKey {
    case count
    case allUsers = "data"
  }
}

// MARK: - LikeSavedUserData
struct LikeSavedUserData1: Decodable {
  let id, userID, savedUserID: Int?
  let status: String?
  let user: UserAllInfo?
  let userVerified: UserVerified?
  
  enum CodingKeys: String, CodingKey {
    case id
    case userID = "user_id"
    case savedUserID = "saved_user_id"
    case status
    case user
    case userVerified = "user_verified"
  }
}

// MARK: - User
struct UserAllInfo: Decodable {
    let id: Int?
    let firebaseID, socialType, socialID, name: String?
    let email: String?
    let isEmailVerified: Bool?
    let mobile, interestedIn, gender: String?
    let profilePic: String?
    let dob, about: String?
    let status: Int?
    let subscriptionPlan: Bool?
    let deviceType, appVersion, osVersion, authToken: String?
    let latitude, longitude, currentLatitude, currentLongitude: String?

    let isVerified: Bool?
    let relationshipStatusID, occupationID, educationID: Int?
    let isPause: Bool?
    let flowers, profileComplete: Int?
    let workingFIFO: String?
    let swing: String?
    let minAge, maxAge: Int?
    let loginTime: String?
    let countryCode, countryName: String?
    let sureyStatus: Int?
    //let userPlan: JSONNull?
    let age: Int?
    let photo: UserPhoto?
    let occupation: Education?

    enum CodingKeys: String, CodingKey {
        case id
        case firebaseID = "firebase_id"
        case socialType = "social_type"
        case socialID = "social_id"
        case name, email
        case isEmailVerified = "is_email_verified"
        case mobile
        case interestedIn = "interested_in"
        case gender
        case profilePic = "profile_pic"
        case dob, about, status
        case subscriptionPlan = "subscription_plan"
        case deviceType = "device_type"
        case appVersion = "app_version"
        case osVersion = "os_version"
        case authToken = "auth_token"
        case latitude, longitude
        case currentLatitude = "current_latitude"
        case currentLongitude = "current_longitude"
      
        case isVerified = "is_verified"
        case relationshipStatusID = "relationship_status_id"
        case occupationID = "occupation_id"
        case educationID = "education_id"
        case isPause = "is_pause"
        case flowers
        case profileComplete = "profile_complete"

        case workingFIFO = "working_fifo"
        case swing
        case minAge = "min_age"
        case maxAge = "max_age"
        case loginTime = "login_time"
        case countryCode = "country_code"
        case countryName = "country_name"
        case sureyStatus = "surey_status"
//        case userPlan = "user_plan"
        case age, photo
        case occupation
    }
}


// MARK: - LikeSaveCancelModel
struct LikeSaveCancelModel: Decodable {
  let status: Int?
  let message: String?
}
