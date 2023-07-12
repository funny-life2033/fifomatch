//
//  CommonModel.swift
//  FIFOMatch
//
//  Created by Harendra Singh Rathore on 13/04/22.
//

import Foundation

// MARK: - CommonModel
struct CommonModel: Decodable {
  let msg, message: String?
  let status: Int?
}
