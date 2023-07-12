//
//  UserDefault.swift
//  FIFOMatch
//
//  Created by Harendra Singh Rathore on 28/03/22.
//

import Foundation

struct UserDefault {
  
  static let shared = UserDefault()
  private let userDefaults = UserDefaults.standard
  
  private let userLoginKey = "userLogin"
  private let userIDKey = "userId"
  private let userEmailKey = "userEmail"
  private let userNameKey = "userName"
  private let userImagekey = "userImage"
  private let userDOB = "userDOB"
  private let userFireBaseIdKey = "userFireBaseId"
  private let userCountryKey = "userCountryKey"
  private let mobileKey = "mobileNumber"
  private let profileStatusKey = "profileUpdateStatus"
  private let surveyStatusKey = "surveyStatus"
  private let sessionKey = "sessionAuthToken"
  private let isPurchasedKey = "subscriptionPurchased"
  private let genderKey = "gender"
  private let firbaseToken = "deviceToken"
  private let onlineStatusKey = "onlineStatus"
  private let notificationStatusKey = "notificationStatus"
  private let latitudeKey = "latitude"
  private let longitudeKey = "longitude"
  private let purchaseDetails = "purchaseDetails"
  
  //MARK:- Save & Get User Id
  func saveUserId(userId: Int) {
    userDefaults.set(userId, forKey: userIDKey)
  }
  func getUserId()-> Int? {
    userDefaults.value(forKey: userIDKey) as? Int
  }
    
  //MARK:- Save & Get User Name
  func saveUserName(fullname: String) {
    userDefaults.set(fullname,forKey: userNameKey)
  }
  func getUserName() -> String  {
    return userDefaults.value(forKey: userNameKey) as? String ?? ""
  }
  
  //MARK:- Save & Get User Profile Image
  func saveUserImg(imageURL: String) {
    userDefaults.set(imageURL, forKey: userImagekey)
  }
  func getUserImg() -> String? {
    return userDefaults.value(forKey: userImagekey) as? String
  }
  
  //MARK:- Save & Get User Firebase Id
  func saveUserFirebaseId(id: String?) {
    userDefaults.set(id ?? "", forKey: userFireBaseIdKey)
  }
  func getUserFirebaseId() -> String {
    return userDefaults.value(forKey: userFireBaseIdKey) as? String ?? ""
  }
  
  //MARK:- Save & Get User Age
  func saveUserCountry(name: String) {
    userDefaults.set(name, forKey: userCountryKey)
  }
  func getUserCountry() -> String? {
    return userDefaults.value(forKey: userCountryKey) as? String
  }
  
  //MARK:- Save & Get User PhoneNumber
  func saveUserNumber(phone: String) {
    userDefaults.set(phone, forKey: mobileKey)
  }
  func getUserNumber() -> String? {
    return userDefaults.value(forKey: mobileKey) as? String
  }
  
  //MARK:- Save & Get Gender
  func saveUserGender(gender: String) {
    userDefaults.set(gender, forKey: genderKey)
  }
  func getUserGender() -> String? {
    return userDefaults.value(forKey: genderKey) as? String
  }
  
  //MARK:- Save & Get User Profile Update status
  func saveProfileUpdate(status: Int) {
    userDefaults.set(status, forKey: profileStatusKey)
  }
  func getProfileUpdateStatus()-> Int {
    userDefaults.value(forKey: profileStatusKey) as? Int ?? 0
  }
  
  //MARK:- Save & Get survey status
  func saveSurveyStatus(status: Int) {
    userDefaults.set(status, forKey: surveyStatusKey)
  }
  func getSurveyStatus()-> Int {
    userDefaults.value(forKey: surveyStatusKey) as? Int ?? 0
  }
  
  //MARK:- Save & Get is plan subscribe
  func saveSubscriptionStatus(status: Bool) {
    userDefaults.set(status, forKey: isPurchasedKey)
  }
  func isSubscriptionPurchased() -> Bool {
    userDefaults.value(forKey: isPurchasedKey) as? Bool ?? false
  }
  
  //MARK:- Save & Get sessionID
  func saveSessionId(sessionId: String) {
    userDefaults.set(sessionId, forKey: sessionKey)
  }
  func getSessionId() -> String {
    if let token = userDefaults.value(forKey: sessionKey) as? String {
      return "Bearer " + token
    }
    return ""
  }
 
  //MARK:- User Login or Logout
  func loginUser(){
    userDefaults.set(true, forKey: userLoginKey)
  }
  func logoutUser()  {
    userDefaults.set(false, forKey: userLoginKey)
    removeAllUserDefaults()
  }
  func isUserLogin() -> Bool{
    return userDefaults.bool(forKey: userLoginKey)
  }
  
  //MARK: - Save & Get Firbase Token
  func saveDeviceToken(token: String) {
    userDefaults.set(token, forKey: firbaseToken)
  }
  func getDeviceToken() -> String {

    if let token = userDefaults.value(forKey: firbaseToken) as? String {
      return token
    }

    return ""
  }
  
  //MARK:- Save & Get Online Status
  func saveOnlineStatus(status: String?) {
    
    var isOnline = true
    if let status = status, status == "offline" {
      isOnline = false
    }
    userDefaults.set(isOnline, forKey: onlineStatusKey)
  }
  func isUserOnline() -> Bool {
    return userDefaults.value(forKey: onlineStatusKey) as? Bool ?? true
  }
  
  //MARK:- Save & Get Notification Status
  func saveNotificationStatus(status: String?) {
    
    var isOn = true
    if let status = status, status == "off" {
      isOn = false
    }
    userDefaults.set(isOn, forKey: notificationStatusKey)
  }
  func isNotificationOn() -> Bool {
    return userDefaults.value(forKey: notificationStatusKey) as? Bool ?? true
  }
  
//
//  //MARK:- Save & Get UserAddress
//  func saveUserAddress(address:String){
//    userDefaults.set(address, forKey: "userAddress")
//  }
//  func getUserAddress() -> String?{
//    return userDefaults.object(forKey: "userAddress") as? String
//  }
  
  //MARK:- Save & Get Latitude
  func saveLatitude(lat: Double) {
    userDefaults.set(lat, forKey: latitudeKey)
  }
  func getlatitude() -> Double {
    return userDefaults.value(forKey: latitudeKey) as? Double ?? 0.0
  }
  
  //MARK:- Save & Get Longitude
  func saveLongitude(long: Double) {
    userDefaults.set(long, forKey: longitudeKey)
  }
  func getLongitude() -> Double {
  return userDefaults.value(forKey: longitudeKey) as? Double ?? 0.0
  }
  
  //MARK:- Save User Subscription Info
  // when api not call
  func savePurchaseDetails(parameters: [String: Any]) {
    userDefaults.set(parameters, forKey: purchaseDetails)
  }
  
  func getPurchaseDetails() -> ([String: Any]?) {
    
    let params = userDefaults.value(forKey: purchaseDetails) as? [String: Any]
    return params
  }
  
  func removePurchaseDetails() {
    userDefaults.removeObject(forKey: purchaseDetails)
  }
  
  func removeAllUserDefaults() {
    userDefaults.removeObject(forKey: userIDKey)
    userDefaults.removeObject(forKey: userImagekey)
    userDefaults.removeObject(forKey: userDOB)
    userDefaults.removeObject(forKey: userNameKey)
    userDefaults.removeObject(forKey: mobileKey)
    userDefaults.removeObject(forKey: sessionKey)
    userDefaults.removeObject(forKey: profileStatusKey)
    userDefaults.removeObject(forKey: surveyStatusKey)
    userDefaults.removeObject(forKey: userCountryKey)
    userDefaults.removeObject(forKey: userFireBaseIdKey)
    userDefaults.removeObject(forKey: isPurchasedKey)
    userDefaults.removeObject(forKey: notificationStatusKey)
    
  }
  
}
