//
//  SurveyModel.swift
//  FIFOMatch
//
//  Created by Harendra Singh Rathore on 29/03/22.
//

import Foundation

struct SurveyModel: Decodable {
  let status: Int?
  let message: String?
}

// MARK: - SurveyDetailModel
struct SurveyDetailModel: Decodable {
    let msg, message: String?
    let status: Int?
    let data: SurveyDetailData?
}

// MARK: - SurveyDetailData
struct SurveyDetailData: Decodable {
    let id, userID: Int?
    let heightType, height, bodyType, seeking: String?
    let qualitiesAppreciate, personalityTypes, kids, kidsInFuture: String?
    let myHealth, otherHealth, myQualities, interestedFact: String?
    let decision, preferClarity: String?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case heightType = "height_type"
        case height
        case bodyType = "body_type"
        case seeking
        case qualitiesAppreciate = "qualities_appreciate"
        case personalityTypes = "personality_types"
        case kids
        case kidsInFuture = "kids_in_future"
        case myHealth = "my_health"
        case otherHealth = "other_health"
        case myQualities = "my_qualities"
        case interestedFact = "interested_fact"
        case decision
        case preferClarity = "prefer_clarity"
    }
}

struct FillSurveyModel {
  let name: String
  let info: [String]
}
