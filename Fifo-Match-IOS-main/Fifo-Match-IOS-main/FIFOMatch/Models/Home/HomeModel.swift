//
//  HomeModel.swift
//  FIFOMatch
//
//  Created by Harendra Singh Rathore on 30/03/22.
//

import Foundation

// MARK: - HomeModel
struct HomeModel: Decodable {
    let msg, message: String?
    let status: Int?
    let data: HomeData?
}

// MARK: - HomeData
struct HomeData: Decodable {
    let premiumUser, onlineUsers, newUsers: [UserInfo]?

    enum CodingKeys: String, CodingKey {
        case premiumUser = "premium_user"
        case onlineUsers = "online_users"
        case newUsers = "new_users"
    }
}

// MARK: - UserInfo
struct UserInfo: Decodable {
    let id: Int?
    let name, dob, countryName: String?
    let age: Int?
    let photo: UserPhoto?
    let userVerified: UserVerified?

    enum CodingKeys: String, CodingKey {
        case id, name, dob
        case countryName = "country_name"
        case age, photo
        case userVerified = "user_verified"
    }
}

// MARK: - UserPhoto
struct UserPhoto: Decodable {
    let id, userID: Int?
    let name: String?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case name
    }
}

// MARK: - User Verified
struct UserVerified: Decodable {
    let id, userID: Int?
    let isAccepted: Bool?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case isAccepted = "is_accepted"
    }
}


