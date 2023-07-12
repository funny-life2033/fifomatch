//
//  MatchProfileModel.swift
//  FIFOMatch
//
//  Created by Harendra Singh Rathore on 07/04/22.
//

import Foundation

// MARK: - MatchProfileModel
struct MatchProfileModel: Decodable {
    let msg, message: String?
    let status: Int?
    let data: MatchProfileData?
}

// MARK: - MatchProfileData
struct MatchProfileData: Decodable {
    let id: Int?
    let type: String?
    let senderID, receiverID: Int?
    let status: String?
    let senderPhoto, receiverPhoto: UserPhoto?

    enum CodingKeys: String, CodingKey {
        case id, type
        case senderID = "sender_id"
        case receiverID = "receiver_id"
        case status
        case senderPhoto = "sender_photo"
        case receiverPhoto = "receiver_photo"
    }
}

