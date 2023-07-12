//
//  Defines.swift
//  Panther
//
//  Created by Manish Jangid on 7/27/17.
//  Copyright © 2017 Manish Jangid. All rights reserved.
//

import Foundation
import UIKit

// MARK : GLOBAL Functions
func print_debug <T> (_ object:T)
{
  print(object)
}

let DateFormat_yyyy_mm_dd_hh_mm_ss_sss = "yyyy-MM-dd HH:mm:ss"

let DateFormat_yyyy_mm_dd_hh_mm_ss_0000 = "yyyy-MM-dd HH:mm:ss +0000"
let output_format_HH_mm_ss = "HH:mm:ss  MMM dd yyy"
let DateFormat_dd_mm_yyyy = "dd-MM-yyyy"
let DateFormat_dd_MM_yyyy = "yyyy-MM-dd"
let time_Format = "HH:mm"
let time_Format_S = "hh:mm:ss"
let appDelegate = UIApplication.shared.delegate as! AppDelegate



//MARK:- Service Keys

struct ServiceKeys {
  static let isPermissionEnabled = "isPermissionEnabled"
  static let user_id = "user_id"
  
  static let isFirstTime = "isFirstTime"
  static let full_name = "full_name"
  
  static let device_token = "device_token"
  static let token = "token"
  static let user_name = "user_name"
  static let email = "email"
  static let profile_Screen = "profile_Screen"
  static let profile_image = "profile_image"
  static let phone_no = "phone_no"
  static let is_pause = "is_pause"
  static let is_subscribed = "is_subscribed"
  
  static let accout_type = "accout_type"
  static let dateFormat = "dateFormat"
  static let  timeFormat = "timeFormat"
  static let receiptNo  = "receiptNo"
  static let dob  = "dob"
  static let keyLatLong = "LatLon"
  static let keyAddressClient = "AddressClient"
  
  static let languageType = "languageType"
  
  static let keyContactNumber = "contact_number"
  static let keyProfileImage = "image_url"
  
  static let keyErrorCode = "errorCode"
  static let keyErrorMessage = "msg"
  static let keyUserType = "user_type"
  static let keyErrorDic = "errorDic"
  static let langId = "langId"
  static let saveUser = "user_saved"
  static let keyStatus =  "status"
  static let KeyAccountName = "account_name"
  static let KeyPushNotificationDeviceToken = "KeyPushNotificationDeviceToken"
  
  
}

struct ServiceUrls
{
  
  // static let baseUrl =  "http://192.168.1.116/datting/public/api/"
  
//  static let baseUrl = "https://74.octaldevs.com/fifomatch/public/api/"
  //static let baseUrl = "http://13.234.131.213/admin/public/api/"
  static let baseUrl = "https://fifomatch.com/admin/public/api/"


  static let FAQUrl = "faq"
  static let privacyPolicy = "privacy_policy"
  static let aboutUS  = "about"
  static let termAndCondition = "terms_service"
  static let contactUS = "contact_us"
  static let home = "explore"
  static let regiser_New_User = "/auth/register"
  static let check_Mobile_Registered = "/auth/email-mobile-exists"
  //    static let login = "v1/login"
  static let login = "apiLogin"
  
  
  static let upload_Photos = "upload_photos"
  static let send_attachement = "send_attactment"
  static let send_notification = "send_notification"
  static let user_verification = "user_verification"
  static let delete_photo = "delete_photo"
  static let hitSurvey = "complete_questionnaire"
  static let send_OTP = "send_login_otp"
  static let sign_up_Otp = "send_otp"
  static let sign_up = "verify_otp"
  
  static let profile_List_Data = "profile_list_data"
  
  static let sign_up_Email = "mobileRegistration"
  static let complete_profile = "complete_profile"
  static let complete_profile_prefrence = "complete_profile_preference"
  
  static let signup_Social = "social_login"
  static let prefrence_User = "preference_users"
  static let save_In_App_Purchase = "save_in_app_transaction"
  static let save_In_Flowers_In_APp = "save_in_app_transaction_flowers"
  static let saveUser = "user_saved"
  static let removeUser = "remove_user"
  static let cancel_Match = "remove_from_match"
  static let report_User = "report_user"
  static let create_Chat = "create_chat"
  static let request_User = "request_to_user"
  static let verify_Reciept = "verify_receipt_apple"
  static let likeDisLikeUser = "users_like_dislike"
  static let getSavedUser = "saved_users"
  static let checkSubs = "check_my_subscription"
  static let mystryUser = "mystery_users"
  static let matchedUSer = "matched_users"
  static let get_Profile = "profile_details"
  static let log_Out = "sing_out"
  static let change_teleprotion = "change_teleportation"
  static let current_location = "return_to_current_location"
  static let get_Notificaition = "my_notifications"
  static let update_Notifications = "update_my_notification_settings"
  static let pauseAccount = "play_pause_account"
  
  static let planDetails = "plan_details"
  static let surveyUserDetails = "surrey_data"
  static let matchListing = "match_listing"
  static let userDetails = "user_details?user_id="
  static let activePlan = "active_plan"
  static let updateLiveTime = "update_live_time"
  static let profile = "profile"
  
  static let notificationStatus = "notification_status"
  static let loginStatus = "update_login_status"
  static let likeUser = "user_like"
  static let dislikeUser = "user_like_delete"
  static let likeUsersList = "user_like_list"
  static let likeUsersDetails = "user_like_details"
  static let userAppearance = "user_appearance"
  static let clearNotification = "clear_notification"
  static let deleteChat = "deleteChat"
  
}
struct ErrorCodes
{
  static let    errorCodeInternetProblem = -1 //Unable to update use
  
  static let    errorCodeSuccess = 1 // 'Process successfully.'
  static let    errorCodeFailed = 2 // 'Process failed.
}


struct CustomColor{
  
  
  static let darkBlueColor = UIColor(red: 10.0/255.0, green: 211.0/255.0, blue: 225.0/255.0, alpha: 1.0)
  static let lightBlueColor = UIColor(red: 4/255.0, green: 167/255.0, blue: 191/255.0, alpha: 1.0)
  static let selectedtabColor = UIColor(red: 236/255.0, green: 36.0/255.0, blue: 143.0/255.0, alpha: 0.8)
  static let backgroundColor = UIColor(red: 246/255.0, green: 246/255.0, blue: 246/255.0, alpha: 1.0)
  //236,66,143
  
  // New
  static let themeLightGray = UIColor(red: 184/255.0, green: 187/255.0, blue: 191/255.0, alpha: 1.0)
  static let themeOrangecolor = UIColor(red: 255/255.0, green: 108/255.0, blue: 10/255.0, alpha: 1.0)
  
}


struct CustomFont {
  static let boldfont13 = UIFont(name: "GlacialIndifference-Bold", size: 13)!
  static let boldfont18 =  UIFont(name: "GlacialIndifference-Bold", size: 18)!
  static let boldfont14 =  UIFont(name: "GlacialIndifference-Bold", size: 14)!
  static let regularfont17 =  UIFont(name: "GlacialIndifference-Regular", size: 17)!
  static let regularfont16 =  UIFont(name: "GlacialIndifference-Regular", size: 16)!
  static let regularfont14 =  UIFont(name: "GlacialIndifference-Regular", size: 14)!
  static let regularfont18 =  UIFont(name: "GlacialIndifference-Regular", size: 18)!
  static let regularfont15 =  UIFont(name: "GlacialIndifference-Regular", size: 15)!
  static let boldfont15 =  UIFont(name: "GlacialIndifference-Bold", size: 15)!
}






