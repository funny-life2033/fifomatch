//
//  CompleteProfileModel.swift
//  FIFOMatch
//
//  Created by Harendra Singh Rathore on 28/03/22.
//

import Foundation

// MARK: - CompleteProfile1Model
struct CompleteProfile1Model: Decodable {
  let status: Int?
  let message: String?
  let data: CompleteProfile1Data?
  
}

// MARK: - DataClass
struct CompleteProfile1Data: Decodable {
    let profileComplete: Int?

    enum CodingKeys: String, CodingKey {
        case profileComplete = "profile_complete"
    }
}


//MARK: Profile Helper Info Model ---------
struct ProfileHelperListModel: Decodable {
    let msg, message: String?
    let status: Int?
    let data: ProfileHelperData?
}

// MARK: - ProfileHelperData
struct ProfileHelperData: Decodable {
    let relationshipStatusData, occupationsData, educationData: [ProfileList]?

    enum CodingKeys: String, CodingKey {
        case relationshipStatusData = "relationship_status_data"
        case occupationsData = "occupations_data"
        case educationData = "education_data"
    }
}

// MARK: - ProfileList
struct ProfileList: Decodable {
    let id: Int?
    let name: String?
}
