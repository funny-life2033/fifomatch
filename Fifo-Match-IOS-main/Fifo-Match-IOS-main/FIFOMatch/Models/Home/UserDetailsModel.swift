//
//  UserDetailsModel.swift
//  FIFOMatch
//
//  Created by Harendra Singh Rathore on 30/03/22.
//

import Foundation

// MARK: - Welcome
struct UserDetailsModel: Decodable {
  let msg, message: String?
  let status: Int?
  let data: UserData?
}

// MARK: - DataClass
struct UserData: Decodable {
  let userDetails: UserDetails?
  
  enum CodingKeys: String, CodingKey {
    case userDetails = "user_details"
  }
}

// MARK: - UserDetails
struct UserDetails: Decodable {
  let id: Int?
  let firebaseID, socialType, socialID, name: String?
  let email: String?
  let isEmailVerified: Bool?
  let mobile, interestedIn, gender, profilePic: String?
  let dob, about: String?
  let status: Int?
  let subscriptionPlan: Bool?
  let deviceType, appVersion, osVersion, authToken: String?
  let latitude, longitude, currentLatitude, currentLongitude: String?
  let isVerified: Bool?
  let relationshipStatusID, occupationID, educationID: Int?
  let isPause: Bool?
  let flowers, profileComplete: Int?
  let workingFIFO, swing: String?
  let minAge, maxAge: Int?
  let loginTime, countryCode, countryName: String?
  let sureyStatus: Int?
  let miles: String?
  let age: Int?
  let photos: [UserPhoto]?
  let questionnaire: SurveyDetailData?
  let occupation, relationshipData, education: Education?
  let userInappTransaction: UserInappTransaction?
  let isBlocked: Bool?
  let isLike: Bool?
  let isSaved: Bool?
  let verify: Int?
  let isChatEnable: Bool?
  
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
    case swing = "swing"
    case minAge = "min_age"
    case maxAge = "max_age"
    case loginTime = "login_time"
    case countryCode = "country_code"
    case countryName = "country_name"
    case sureyStatus = "surey_status"
    case miles, age, photos, questionnaire, occupation
    case relationshipData = "relationship_data"
    case education
    case userInappTransaction = "user_inapp_transaction"
    case isBlocked = "is_blocked"
    case isLike = "is_like"
    case isSaved = "is_saved"
    case verify
    case isChatEnable = "is_chat"
  }
}

// MARK: - Education
struct Education: Decodable {
  let id: Int?
  let name, status: String?
}

// MARK: - UserInappTransaction
struct UserInappTransaction: Decodable {
    let transactionID: String?
    let userID: Int?
    let type, planID, membershipType: String?
    let membershipTypeValue: Int?
    let amount, startDatetime, endDatetime: String?
    let status: Bool?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case transactionID = "transaction_id"
        case userID = "user_id"
        case type
        case planID = "plan_id"
        case membershipType = "membership_type"
        case membershipTypeValue = "membership_type_value"
        case amount
        case startDatetime = "start_datetime"
        case endDatetime = "end_datetime"
        case status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
