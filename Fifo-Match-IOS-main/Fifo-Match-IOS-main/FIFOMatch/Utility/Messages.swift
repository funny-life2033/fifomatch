
import Foundation
import UIKit
import FirebaseDatabase

let kAppName            = "FIFOMatch"
var userID = 0
var authToken = ""
let key_Firebase_user_ID    = "FIREBASE_ID"
let authPassword = "Octal@321"
var profileStepCompleted = 1
var profileImage = ""
var fullName = ""
let AppFontRegular:String   = "sf_ui_text_regular"
let AppFontBold:String      = "Linotte-Bold"
let AppFontSemiBold:String  = "Linotte-Semi-Bold"
let AppFontLight:String    = "Linotte-Light"
let kHMYMDFormate         = "yyyy-MM-dd HH:mm:ss"
let kDateFormate          =  "dd-MMM-yyyy"
let kDateFormate2          =  "dd MMM yyyy"
let kDateFormateAPI       =  "yyyy-MM-dd"
let kUTC_time_zone_format = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
//2020-05-23T13:18:50.000Z
let ios_version : String = UIDevice.current.systemVersion
let OS = "iOS"
let SCREEN_WIDTH  = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
//var kWindow = UIWindow(frame: UIScreen.main.bounds)
 let appdelegate = UIApplication.shared.delegate as! AppDelegate
//var kScreenSize         = UIScreen.main.bounds.size

var versionNumber =  Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
var buildNumber =  Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""

enum MessageType : String {
    case TextMessage = "N"
    case MediaMessage = "M"
    case SystemMessage = "S"
    case Gift = "gift"
}

enum Messages : String {
    case NAME_EMPTY             = "Please enter full name."
    case SURNAME                = "Please enter first name."
    case LASTNAME               = "Please enter last name."
    case EMAIL_EMPTY            = "Please enter Email."
    case City                   = "Please Enter your City."
    case EMAIL_INVALID          = "Please enter correct email address."
    case FULL_NAME_LENGTH       = "Full name should be minimum 3 characters. "
    case DESCRIPTION_LENGTH     = "Description should be minimum 22 characters."
    case PASSWORD_EMPTY         = "Please enter password."
    case NEW_PASSWORD_EMPTY     = "Please enter new password."
    case EMAIL_NUMBER           = "Please enter mobile number. "
    case Valid_NUMBER           = "Please enter valid mobile number. "
    case Valid_NUMBER1          = "Please enter atleast 7 digits Number"
    case QUERY_TITLE            = "Please enter title. "
    case TICK_ALLOW             = "Please agree to terms and conditions & policy "
    //Password
    case OLD_PASSWORD_EMPTY     = "Old password field can not be blank."
    case CONFIRM_PASSWORD_EMPTY = "Please enter confirm password."
    case PASSWORD_DIFFERENT     = "New password did not match with confirm password."
    case VERIFICATION_CODE      = "Please enter correct verificaton code."
    case LOGOUT                 = "Are you sure you want to logout?"
    case LANG_EMPTY             = "PLease select language"
      case COUNTRY_EMPTY             = "Please select country"
    case report                 = "Are you sure you want to report?"
    case CARD_TYPE              = "Please select card type."
    case CARD_LENGTH            = "Please enter valid card number."
    case CARD_CVV               = "Please enter CVV number."
    case EXPIRY_DATE            = "PLease select expiration date."
    case CARD_EMPTY             = "Please enter card number."
    case PHONE_EMPTY            = "Please enter phone number."
    case PHONE_Code             = "Please select mobile code."
    case PHONE_INVALID          = "Please enter correct phone number."
    case AMOUNT                 = "Please enter amount."
    case DOB_ERROR              = "Please enter your date of birth"
    case SUBJECT                = "Please enter subject."
    case REQUESTDATA            = "Please enter request data."
    case PASSWORD_LENGTH        = "Password should be minimum 4 digits"
    case NEW_PASSWORD_LENGTH    = "New password should be minimum 4 digits"
    case PHONE_NUMBER           = "Enter valid phone number."
    case PASSWORD_OLD_EMPTY     = "Please enter old password."
    case PASSWORD_MATCH         = "Password should be same."
    case INTERNET_ERROR         = "Please check your internet connection"
    case GENDER_ERROR           = "Please select your gender"
    case LOCATION               = "Please enter your location"
    case ABOUT                  = "Please enter about you"
    case INTERESTAREA           = "Please select at least one interest area"
    case COMPANYNAME           = "Please enter your Staff id."
    case TermAndCondition      = "Please Accept Terms & Conditions"
  
    case INTERESTIN_ERROR       = "Please select your interest"
    case Relationship_Error     = "Please select your relationship status"
    case OCCUPATION_ERROR       = "Please select your occupation"
    case EDUCATION_ERROR        = "Please select your education"
    case PROFILE_IMAGE_ERROR    = "Please upload at least three photos in order to proceed."
    case MEMBERSHIP_ERROR       = "Please upgrade to premium for access."
    case DELETEACCOUNT          = "Are you sure you want to delete account?"
    case DEACTIVATEACCOUNT      = "Are you sure you want to deactivate account?"
    case PROFILE_IMAGE_ERROR1   = "Please upload your profile image"
    case PROFILE_IMAGE_ERROR2   = "Please upload a profile picture and three additional images"
    case TOKEN_EXPIRE           = "Your session has been expired, Please login again to continue."
}
let moreTitlesArray = ["About Us",
                       "Contact us",
                       "FAQ's",
                       "T & C",
                       "Privacy policy",]
let moreImagesArray = [ "abouticon",
                     "mail",
                       "faq",
                       "ordersmenu",
                       "privacypolicy",
                     ]


public enum AlertButton: String {
    case OK     = "OK"
    case CANCEL = "Cancel"
    case YES    = "Yes"
    case NO     = "No"
    case CAMERA = "Camera"
    case PHOTOS = "Photo Library"
}

//MARK: - Fire Base Database Reference 
struct Constants
{
    struct refs
    {
        static let databaseRoot = Database.database().reference()
        static let databaseChats = databaseRoot.child("chats")
        static let databaseUsers = databaseRoot.child("users")
        static let databasemessages = databaseRoot.child("messages")
    }
}
