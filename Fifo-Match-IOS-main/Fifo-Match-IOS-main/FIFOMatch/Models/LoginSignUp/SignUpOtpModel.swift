//
//  SignUpOtpModel.swift
//  FIFOMatch
//
//  Created by Harendra Singh Rathore on 28/03/22.
//

import Foundation

// MARK: - SignUpOtpModel
struct SignUpOtpModel: Decodable {
    let status: Int?
    let message: String?
    let data: SignUpOtpData?
}

// MARK: - LoginOtpData
struct SignUpOtpData: Decodable {
    let otp: Int?
}
