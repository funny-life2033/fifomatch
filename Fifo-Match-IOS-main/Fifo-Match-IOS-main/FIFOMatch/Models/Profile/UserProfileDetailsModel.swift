//
//  UserProfileDetailsModel.swift
//  FIFOMatch
//
//  Created by Harendra Singh Rathore on 05/04/22.
//

import Foundation


// MARK: - UserProfileDetailsModel
struct UserProfileDetailsModel: Decodable {
    let msg, message: String?
    let status: Int?
    let data: UserProfileDetails?
}

// MARK: - UserProfileDetails
struct UserProfileDetails: Decodable {
    let id: Int?
    let name, gender, interestedIn, dob: String?
    let relationshipStatusID, occupationID, educationID: Int?
    let mobile: String?
    let age: Int?
    let verify: Int?
    let photos: [UserPhoto]?
    let relationshipData, occupation, education: Education?
    let email: String?

    enum CodingKeys: String, CodingKey {
        case id, name, gender
        case interestedIn = "interested_in"
        case dob
        case relationshipStatusID = "relationship_status_id"
        case occupationID = "occupation_id"
        case educationID = "education_id"
        case mobile, age, photos, verify
        case relationshipData = "relationship_data"
        case occupation, education, email
    }
}

struct UserSurveyInfo {
  let name: String
  let result: [String]
}
