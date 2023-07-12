//
//  LikeUserModel.swift
//  FIFOMatch
//
//  Created by Harendra Singh Rathore on 07/04/22.
//

import Foundation

// MARK: - LikeUserModel
struct LikeUserModel: Decodable {
    let msg, message: String?
    let status: Int?
    let data: [LikeUserData]?
}

// MARK: - LikeUserData
struct LikeUserData: Decodable {
    let id: Int?
    let type: String?
    let senderID, receiverID: Int?
    let status: String?
    let receiver: Receiver?
    let sender: Receiver?
    let userVerifiedSender: UserVerified?
    let userVerifiedReceiver: UserVerified?

    enum CodingKeys: String, CodingKey {
        case id, type
        case senderID = "sender_id"
        case receiverID = "receiver_id"
        case status, receiver, sender
        case userVerifiedSender = "user_verified_sender"
        case userVerifiedReceiver = "user_verified_recevier"
      
    }
}

// MARK: - Receiver
struct Receiver: Decodable {
  let id: Int?
  let name: String?
  let age: Int?
  let photo: UserPhoto?
  let occupation: Education?
  let firebase_id : String?
}

