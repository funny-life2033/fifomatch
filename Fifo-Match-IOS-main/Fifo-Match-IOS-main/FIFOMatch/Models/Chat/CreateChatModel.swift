//
//  CreateChatModel.swift
//  FIFOMatch
//
//  Created by Harendra Singh Rathore on 11/04/22.
//

import Foundation

// MARK: - Create Chat Model
struct CreateChatModel: Decodable {
    let status: Int?
    let message: String?
    let data: CreateChatData?
}

// MARK: - Create Chat Data
struct CreateChatData: Decodable {
    let node: String?
}


