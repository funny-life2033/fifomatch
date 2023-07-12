//
//  LoginOtpModel.swift
//  FIFOMatch
//
//  Created by Harendra Singh Rathore on 25/03/22.
//

import Foundation

// MARK: - LoginOtpModel
struct LoginOtpModel: Decodable {
    let status: Int?
    let message: String?
    let data: LoginOtpData?
}

// MARK: - LoginOtpData
struct LoginOtpData: Decodable {
    let otp: String?
}
