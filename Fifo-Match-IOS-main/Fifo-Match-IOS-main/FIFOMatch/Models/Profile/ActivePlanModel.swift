//
//  ActivePlanModel.swift
//  FIFOMatch
//
//  Created by Harendra Singh Rathore on 04/04/22.
//

import Foundation

// MARK: - ActivePlanModel
struct ActivePlanModel: Decodable {
  let status: Int?
  let message: String?
  let data: ActivePlanData?
}

// MARK: - ActivePlanData
struct ActivePlanData: Decodable {
  let plan_id: String?
  let start_datetime: String?
  let end_datetime: String?
}
