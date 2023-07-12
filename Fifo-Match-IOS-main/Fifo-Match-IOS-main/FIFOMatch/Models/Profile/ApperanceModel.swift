//
//  ApperanceModel.swift
//  FIFOMatch
//
//  Created by Harendra Singh Rathore on 11/04/22.
//

import Foundation

// MARK: - ApperanceModel
struct ApperanceModel: Decodable {
    let msg, message: String?
    let status: Int?
    let data: ApperanceData?
}

// MARK: - ApperanceData
struct ApperanceData: Decodable {
    let id: Int?
    let name, email, mobile, interestedIn: String?
    let gender, dob, about: String?
    let status: Int?
    let subscriptionPlan: Bool?
    let workingFIFO, swing: String?
    let minAge, maxAge: Int?
    let countryCode, countryName: String?
    let age: Int?
    let questionnaire: SurveyDetailData?
    let relationshipData, occupation, education: Education?

    enum CodingKeys: String, CodingKey {
        case id, name, email, mobile
        case interestedIn = "interested_in"
        case gender, dob, about, status
        case subscriptionPlan = "subscription_plan"
        case workingFIFO = "working_fifo"
        case swing
        case minAge = "min_age"
        case maxAge = "max_age"
        case countryCode = "country_code"
        case countryName = "country_name"
        case age, questionnaire
        case relationshipData = "relationship_data"
        case occupation, education
    }
}

//// MARK: - Questionnaire
//struct Questionnaire: Codable {
//    let id, userID: Int?
//    let heightType, height, bodyType: String?
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case userID = "user_id"
//        case heightType = "height_type"
//        case height
//        case bodyType = "body_type"
//    }
//}
