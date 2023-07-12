//
//  LoginSignUpModel.swift
//  FIFOMatch
//
//  Created by Harendra Singh Rathore on 25/03/22.
//

import Foundation

// MARK: - LoginSignUpModel
struct LoginSignUpModel: Decodable {
  let status: Int?
  let message: String?
  let data: LoginData?
}

// MARK: - LoginData
struct LoginData: Decodable {
  let id: Int?
  let firebaseID, name: String?
  let email: String?
  let isEmailVerified: Bool?
  let mobile, interestedIn, gender: String?
  let profilePic: String?
  let dob, about: String?
  let status: Int?
  let subscriptionPlan: Bool?
  let authToken: String?
  let latitude, longitude, currentLatitude, currentLongitude: String?
  let isVerified: Bool?
  //let relationshipStatusID, occupationID, educationID: String?
  //let isPause: Bool?
  let flowers, profileComplete: Int?
  //let workingFIFO, swing, minAge, maxAge: String?
  let countryCode, countryName: String?
  //let apiToken: String?
  let isSubscribed: Bool?
  let age: Int?
  let userInappTransaction: UserInappTransaction?
  let surveyStatus: Int?
  let onlineStatus: String?
  let notificationStatus: String?
  
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
    case lastActivity = "last_activity"
    case isVerified = "is_verified"
    //        case relationshipStatusID = "relationship_status_id"
    //        case occupationID = "occupation_id"
    //        case educationID = "education_id"
    //        case isPause = "is_pause"
    case flowers
    case profileComplete = "profile_complete"
    case createdAt = "created_at"
    case updatedAt = "updated_at"
    case deletedAt = "deleted_at"
    case workingFIFO = "working_fifo"
    case swing
    case minAge = "min_age"
    case maxAge = "max_age"
    case loginTime = "login_time"
    case countryCode = "country_code"
    case countryName = "country_name"
   // case apiToken = "api_token"
    case isSubscribed = "is_subscribed"
    case age
    case userInappTransaction = "user_inapp_transaction"
    case surveyStatus = "surey_status"
    case onlineStatus = "login_status"
    case notificationStatus = "notification_status"
  }
  
  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    id = try values.decodeIfPresent(Int.self, forKey: .id)
    firebaseID = try values.decodeIfPresent(String.self, forKey: .firebaseID)
    name = try values.decodeIfPresent(String.self, forKey: .name)
    email = try values.decodeIfPresent(String.self, forKey: .email)
    isEmailVerified = try values.decodeIfPresent(Bool.self, forKey: .isEmailVerified)
    mobile = try values.decodeIfPresent(String.self, forKey: .mobile)
    interestedIn = try values.decodeIfPresent(String.self, forKey: .interestedIn)
    gender = try values.decodeIfPresent(String.self, forKey: .gender)
    profilePic = try values.decodeIfPresent(String.self, forKey: .profilePic)
    dob = try values.decodeIfPresent(String.self, forKey: .dob)
    about = try values.decodeIfPresent(String.self, forKey: .about)
    status = try values.decodeIfPresent(Int.self, forKey: .status)
    subscriptionPlan = try values.decodeIfPresent(Bool.self, forKey: .subscriptionPlan)
    authToken = try values.decodeIfPresent(String.self, forKey: .authToken)
    latitude = try values.decodeIfPresent(String.self, forKey: .latitude)
    longitude = try values.decodeIfPresent(String.self, forKey: .longitude)
    currentLatitude = try values.decodeIfPresent(String.self, forKey: .currentLatitude)
    currentLongitude = try values.decodeIfPresent(String.self, forKey: .currentLongitude)
    isVerified = try values.decodeIfPresent(Bool.self, forKey: .isVerified)
    flowers = try values.decodeIfPresent(Int.self, forKey: .flowers)
    profileComplete = try values.decodeIfPresent(Int.self, forKey: .profileComplete)
//    workingFIFO = try values.decodeIfPresent(String.self, forKey: .workingFIFO)
//    swing = try values.decodeIfPresent(String.self, forKey: .swing)
//    minAge = try values.decodeIfPresent(String.self, forKey: .minAge)
//    maxAge = try values.decodeIfPresent(String.self, forKey: .maxAge)
    countryCode = try values.decodeIfPresent(String.self, forKey: .countryCode)
    countryName = try values.decodeIfPresent(String.self, forKey: .countryName)
    //apiToken = try values.decodeIfPresent(String.self, forKey: .apiToken)
    isSubscribed = try values.decodeIfPresent(Bool.self, forKey: .isSubscribed)
    age = try values.decodeIfPresent(Int.self, forKey: .age)
    userInappTransaction = try values.decodeIfPresent(UserInappTransaction.self, forKey: .userInappTransaction)
    surveyStatus = try values.decodeIfPresent(Int.self, forKey: .surveyStatus)
    onlineStatus = try values.decodeIfPresent(String.self, forKey: .onlineStatus)
    notificationStatus = try values.decodeIfPresent(String.self, forKey: .notificationStatus)
  }
}


