//
//  OtpScreen.swift
//  Union
//
//  Created by Ravi on 22/05/20.
//  Copyright © 2020 Union. All rights reserved.
//

import UIKit

import CoreLocation
class OtpScreen: UIViewController {
  
  @IBOutlet weak var resendBtnOutlt: UIButton!
  @IBOutlet weak var lbl_mbl: UILabel!
  @IBOutlet weak var lbl_expireTime: UILabel!
  
  @IBOutlet weak var txt_four: UITextField!
  @IBOutlet weak var txt_three: UITextField!
  @IBOutlet weak var txt_two: UITextField!
  @IBOutlet weak var txt_one: UITextField!
  
  @IBOutlet weak var roundedView: UIView!
  @IBOutlet weak var nextButton: UIButton!
  
  var latitude = 0.0
  var longitude = 0.0
  let locationManager = CLLocationManager()
  
  var email:String?
  var dict : [String:Any] = [:]
  var mobile: String = ""
  var countryCode: String = "+91"
  var socialData : [String:Any] = [:]
  var timer: Timer?
  var totalTime = 120
  var isComingFromLogin = false
  var signUpParameters: [String: Any] = [:]
  
  var otp = ""
  
  override func viewDidLayoutSubviews() {
    self.roundedView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 40)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    txt_one.delegate = self
    txt_two.delegate = self
    txt_three.delegate = self
    txt_four.delegate = self
    
//    if otp.count == 4 {
//
//      let otpArr = otp.utf8.map{Int($0)-48}
//
//      txt_one.text = "\(otpArr[0])"
//      txt_two.text = "\(otpArr[1])"
//      txt_three.text = "\(otpArr[2])"
//      txt_four.text = "\(otpArr[3])"
//    }
//
//    Toast.shared.show(message: "OTP: \(otp)", controller: self)
    
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    self.timer?.invalidate()
    self.timer = nil
  }
  
  override func viewWillAppear(_ animated: Bool) {
    
    super.viewWillAppear(animated)
    self.navigationController?.setNavigationBarHidden(true, animated: false)
    
    self.lbl_mbl.text =  "\(countryCode)  \(self.mobile)"
    self.startOtpTimer()
    Location()
    if CLLocationManager.locationServicesEnabled() {
      locationManager.delegate = self
      locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
      locationManager.startUpdatingLocation()
    }
    
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    timer?.invalidate()
  }
  
  // MARK : Timer
  private func startOtpTimer() {
    nextButton.isEnabled = true
    self.lbl_expireTime.isHidden = false
    self.resendBtnOutlt.isUserInteractionEnabled = false
    self.totalTime = 120
    self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
  }
  
  @objc func updateTimer() {
    // print(self.totalTime)
    
    self.lbl_expireTime.text = self.timeFormatted(self.totalTime) // will show timer
    if totalTime != 0 {
      totalTime -= 1  // decrease counter timer
    } else {
      if let timer = self.timer {
        timer.invalidate()
        self.resendBtnOutlt.isUserInteractionEnabled = true
        self.timer = nil
        self.lbl_expireTime.isHidden = true
        nextButton.isEnabled = false
        
      }
    }
  }
  
  func timeFormatted(_ totalSeconds: Int) -> String {
    let seconds: Int = totalSeconds % 60
    let minutes: Int = (totalSeconds / 60) % 60
    return String(format: "Expires in %02d:%02d", minutes, seconds)
  }
  
  @IBAction func resendOtpBtnAction(_ sender: UIButton) {
    if isComingFromLogin {
      resendLoginOtp()
    }else {
      resendSignUpOtp()
    }
  }
  
  func resendLoginOtp() {
    
    //let mobileNumber = "\(self.countryCode)\(self.mobile)".replacingOccurrences(of: "+", with: "")
    let mobileNumber = self.mobile
    
    debugPrint("mobileNumber = \(mobileNumber)")
    
    AppManager().startActivityIndicator(sender: self.view)
    
    LoginViewModel.shared.getLoginOtp(mobileNumber: mobileNumber, countryCode: self.countryCode) { otp, isSuccess, message in
      
      AppManager().stopActivityIndicator(self.view)
      
      if isSuccess {
          debugPrint("OTP sent successfully")
          Toast.shared.show(message: "OTP resent successfully", controller: self)
          self.startOtpTimer()
      }else {
        Common.showAlert(alertMessage: message ?? "Something went wrong", alertButtons: ["Ok"]) { (bt) in
        }
      }
      
    }
    
  }
  
  func resendSignUpOtp() {
    
//    let mobileNumber = "\(self.countryCode)\(self.mobile)".replacingOccurrences(of: "+", with: "")
    
    let mobileNumber = self.mobile
    
    
    debugPrint("mobileNumber = \(mobileNumber)")
    
    AppManager().startActivityIndicator(sender: self.view)
    
    SignUpViewModel.shared.requestForSignUpOtp(mobileNumber: mobileNumber, countryCode: countryCode) { otp, isSuccess, message in
      
      AppManager().stopActivityIndicator(self.view)
      
      if isSuccess {
          debugPrint("OTP sent successfully")
          Toast.shared.show(message: "OTP resent successfully", controller: self)
          self.startOtpTimer()
      }else {
        Common.showAlert(alertMessage: message ?? "Something went wrong", alertButtons: ["Ok"]) { (bt) in
        }
      }
      
    }
    
  }
  
  
  @IBAction func backButtonAction(_ sender: Any) {
    timer?.invalidate()
    self.navigationController?.popViewController(animated: true)
  }
  
  @IBAction func nextBtnAction(_ sender: UIButton) {
    
    //let mobileNumber = "\(self.countryCode)\(self.mobile)".replacingOccurrences(of: "+", with: "")
    
    let mobileNumber = self.mobile
    
    let fullOtp = "\(txt_one.text ?? "")\(txt_two.text ?? "")\(txt_three.text ?? "")\(txt_four.text ?? "")"
    if fullOtp.count < 4 {
      Common.showAlert(alertMessage: "Please enter valid OTP.", alertButtons: ["Ok"]) { (bt) in
      }
      return
    }
    
    if isComingFromLogin {
      loginUser(mobileNumber: mobileNumber, otp: fullOtp)
    }else {
      signUpUser(mobileNumber: mobileNumber, otp: fullOtp)
    }
  }
  
  func loginUser(mobileNumber: String, otp: String) {
    
    let fcmToken = UserDefault.shared.getDeviceToken()
    
    var params = [String:Any]()
    params["password"] = otp
    params["mobile"] = mobileNumber
    params["device_type"] = OS
    params["device_token"] = fcmToken
    params["app_version"] = versionNumber + "(\(buildNumber))"
    params["os_version"] = ios_version
    params["latitude"] = self.latitude
    params["longitude"] = self.longitude
    params["country_code"] = self.countryCode
    
    AppManager().startActivityIndicator(sender: self.view)
    
    LoginViewModel.shared.getLoginData(parameters: params) { response, isSuccess, message in
      
      AppManager().stopActivityIndicator(self.view)
      
      guard let userInfo = response, isSuccess else {
        Common.showAlert(alertMessage: message ?? "Something went wrong", alertButtons: ["Ok"]) { (bt) in
        }
        return
      }
          
      guard self.checkStatus1(status: userInfo.status, message: userInfo.message) else {
        return
      }
      
      debugPrint("User data = \(userInfo)")
      
      guard let user = userInfo.data else { return }
      
      let userDeafult = UserDefault.shared
      
      if let userID = user.id {
        userDeafult.saveUserId(userId: userID)
      }
    
      userDeafult.saveUserName(fullname: user.name ?? "")
      userDeafult.saveUserNumber(phone: user.mobile ?? "")
      userDeafult.saveUserImg(imageURL: user.profilePic ?? "")
      userDeafult.saveUserCountry(name: user.countryName ?? "")
      userDeafult.saveSessionId(sessionId: user.authToken ?? "")
      userDeafult.saveSurveyStatus(status: user.surveyStatus ?? 0)
      userDeafult.saveUserGender(gender: user.gender ?? "")
      userDeafult.saveNotificationStatus(status: user.notificationStatus)
      userDeafult.saveOnlineStatus(status: user.onlineStatus)
      
      userDeafult.loginUser()
      
      userDeafult.saveProfileUpdate(status: user.profileComplete ?? 0)
      userDeafult.saveUserFirebaseId(id: user.firebaseID)
      
      if user.profileComplete == 0 {
        
        self.openViewController(controller: CompleteProfile1VC.self, storyBoard: .mainStoryBoard) { (vc) in }
        
      }else if user.profileComplete == 1 {
        
        self.openViewController(controller: MultiplePictureUploadVC.self, storyBoard: .mainStoryBoard) { (vc) in }
        
      }else if user.profileComplete == 2 {
        
        if let isSubscribed = user.isSubscribed, isSubscribed == true {
          
          userDeafult.saveSubscriptionStatus(status: true)
          
          if let survayStatus = user.surveyStatus, survayStatus == 7 {
            appDelegate.setHomeView()
          }else {
            
            self.openViewController(controller: CompleteypuProfileVC4.self, storyBoard: .mainStoryBoard) { (vc) in }
          }
          
        }else {
          userDeafult.saveSubscriptionStatus(status: false)
          
          self.openViewController(controller: SubcriptionViewController.self, storyBoard: .mainStoryBoard) { (vc) in }
          
//          if let survayStatus = user.surveyStatus, survayStatus == 7 {
//            appDelegate.setHomeView()
//          }else {
//            self.openViewController(controller: SubcriptionViewController.self, storyBoard: .mainStoryBoard) { (vc) in }
//          }
        }
        
        
      }else {
        appDelegate.setHomeView()
      }
      
      
    }
  }
  
  func signUpUser(mobileNumber: String, otp: String) {
    
    debugPrint("signUpParameters = \(signUpParameters)")
    
    let fcmToken = UserDefault.shared.getDeviceToken()
    
    signUpParameters["otp"] = otp
    signUpParameters["device_type"] = OS
    signUpParameters["device_token"] = fcmToken
    signUpParameters["app_version"] = versionNumber + "(\(buildNumber))"
    signUpParameters["os_version"] = ios_version
    signUpParameters["latitude"] = self.latitude
    signUpParameters["longitude"] = self.longitude
    
    AppManager().startActivityIndicator(sender: self.view)
    
    SignUpViewModel.shared.requestForSignUp(parameters: signUpParameters) { response, isSuccess, message in
    
      
      AppManager().stopActivityIndicator(self.view)
      
      debugPrint("response\(response)")
      
      guard let userInfo = response, isSuccess else {
        Common.showAlert(alertMessage: message ?? "Something went wrong", alertButtons: ["Ok"]) { (bt) in
        }
        return
      }
      
      guard self.checkStatus1(status: userInfo.status, message: userInfo.message) else {
        return
      }
      
      debugPrint("User data = \(userInfo)")
      
      guard let user = userInfo.data else { return }

      let userDeafult = UserDefault.shared

      if let userID = user.id {
        userDeafult.saveUserId(userId: userID)
      }
      
      userDeafult.saveUserName(fullname: user.name ?? "")
      userDeafult.saveUserNumber(phone: user.mobile ?? "")
      userDeafult.saveSessionId(sessionId: user.authToken ?? "")
      userDeafult.saveUserCountry(name: user.countryName ?? "")
      userDeafult.saveUserGender(gender: user.gender ?? "")

      userDeafult.loginUser()
      
      userDeafult.saveProfileUpdate(status: user.profileComplete ?? 0)
      userDeafult.saveUserFirebaseId(id: user.firebaseID)
      
      self.openViewController(controller: CompleteProfile1VC.self, storyBoard: .mainStoryBoard) { (vc) in }
      
    }
  }
  
}

extension OtpScreen: UITextFieldDelegate {
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    if(((textField.text!.count) < 1 ) && (string.count > 0)){
      if(textField  == txt_one){
        txt_two.becomeFirstResponder()
      }
      else if (textField == txt_two){
        txt_three.becomeFirstResponder()
      }
      else if (textField == txt_three){
        txt_four.becomeFirstResponder()
      }
      else if (textField == txt_four){
        // txt_five.becomeFirstResponder()
      }
      
      textField.text = string
      return false
    }
    
    else if(((textField.text!.count) > 0 ) && (string.count > 0)){
      if(textField  == txt_one){
        txt_two.becomeFirstResponder()
      }
      else if (textField == txt_two){
        txt_three.becomeFirstResponder()
      }
      else if (textField == txt_three){
        txt_four.becomeFirstResponder()
      }
      else if (textField == txt_four){
        txt_four.becomeFirstResponder()
      }
      
      textField.text = string
      return false
    }
    
    
    else if (((textField.text!.count) >= 1) && (string.count == 0)){
      if(textField == txt_two){
        txt_one.becomeFirstResponder()
      }
      else if(textField == txt_three){
        txt_two.becomeFirstResponder()
      }
      else if(textField == txt_four){
        txt_three.becomeFirstResponder()
      }
      
      else if(textField == txt_one){
        txt_one.becomeFirstResponder()
      }
      textField.text = ""
      return false
    }
    return true
  }
  
}

extension OtpScreen: CLLocationManagerDelegate {
  
  func Location(){
    let locStatus = CLLocationManager.authorizationStatus()
    switch locStatus {
    case .notDetermined:
      locationManager.requestWhenInUseAuthorization()
      //            location()
      return
    case .denied, .restricted:
      let alert = UIAlertController(title: "Location Services are disabled", message: "Please enable Location Services in your Settings", preferredStyle: .alert)
      let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
      alert.addAction(okAction)
      present(alert, animated: true, completion: nil)
      guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
        return
      }
      
      if UIApplication.shared.canOpenURL(settingsUrl) {
        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
          print("Settings opened: \(success)") // Prints true
        })
      }
      //                location()
      return
    case .authorizedAlways, .authorizedWhenInUse:
      //                location()
      break
    @unknown default:
      locationManager.requestWhenInUseAuthorization()
      
      break
      
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
    print("locations = \(locValue.latitude) \(locValue.longitude)")
    self.latitude = locValue.latitude
    self.longitude = locValue.longitude
    
    UserDefault.shared.saveLatitude(lat: latitude)
    UserDefault.shared.saveLongitude(long: longitude)
  }
}
