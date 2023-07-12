//
//  SubscriptionInfoModel.swift
//  FIFOMatch
//
//  Created by Harendra Singh Rathore on 29/03/22.
//

import Foundation

// MARK: - Subscription Info Model
struct SubscriptionInfoModel: Decodable {
    let msg, message: String?
    let status: Int?
    let data: [SubscriptionInfoData]?
}

// MARK: - SubscriptionInfoData
struct SubscriptionInfoData: Decodable {
    let id: Int?
    let name, slug, cmsBody, createdAt: String?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, name, slug
        case cmsBody = "cms_body"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - Subscription Info Model
struct SubscriptionUpdateModel: Decodable {
    let message: String?
    let status: Int?
}
