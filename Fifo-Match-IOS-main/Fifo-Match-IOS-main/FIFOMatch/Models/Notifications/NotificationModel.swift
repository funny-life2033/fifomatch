//
//  NotificationModel.swift
//  FIFOMatch
//
//  Created by Harendra Singh Rathore on 01/04/22.
//

import Foundation

// MARK: - NotificationModel
struct NotificationModel: Decodable {
  let msg, message: String?
  let status: Int?
  let data: [NotificationData]?
}

// MARK: - NotificationData
struct NotificationData: Decodable {
  let id, fromID, toID: Int?
  let title, subtitle: String?
  let createdAt, updatedAt: String?
  let isRead: Bool?
  let photo: UserPhoto?
  let type: String?
  let openId: Int?
  
  enum CodingKeys: String, CodingKey {
    case id
    case fromID = "from_id"
    case toID = "to_id"
    case title, subtitle
    case isRead = "is_read"
    case createdAt = "created_at"
    case updatedAt = "updated_at"
    case photo
    case type
    case openId = "open_id"
  }
}

// MARK: - NotificationModel
struct ClearNotificationModel: Decodable {
  let msg, message: String?
  let status: Int?
}
