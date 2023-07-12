//
//  MobileNumberVC.swift
//  FIFOMatch
//
//  Created by Subhash Sharma on 02/03/22.
//

import UIKit
import MRCountryPicker
class VCLogin: UIViewController {

    
    var countryName:String?
    @IBOutlet weak var coutnryCodeText: UIButton!
    @IBOutlet weak var txt_Mobile: UITextField!
    @IBOutlet weak var roundedView: UIView!
    
    
    @IBOutlet var viewCountryPickerMain: UIView!
    @IBOutlet weak var countryPicker: MRCountryPicker!
  
  var fromSignUp = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        Analytics.logEvent("testlogin", parameters: ["check":"true"])
//        Analytics.setScreenName("Scene Name", screenClass: "Class Name")
     
//        countryPickerView.setCountry("IN")
//        countryPickerView.setLocale("en_IN")
//        countryPickerView.setCountryByName("India")
        // Do any additional setup after loading the view.
      //countryPicker.keyboardToolbar.
    
    }
    override func viewDidLayoutSubviews() {
        self.roundedView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 40)
    }
    
    var phoneCode = "+61"
    
    
  override func viewWillAppear(_ animated: Bool) {
    self.navigationController?.setNavigationBarHidden(true, animated: false)
//    if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
//      print(countryCode)
//      coutnryCodeText.setTitle("+91" + countryCode, for: .normal)
//    }
    
    coutnryCodeText.setTitle(phoneCode, for: .normal)
    
  }
  @IBAction func backButtonAction(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
  }
  
  @IBAction func countryPickerCancel(_ sender: Any) {
    self.viewCountryPickerMain.removeFromSuperview()
  }
  @IBAction func countryPickerDone(_ sender: Any) {
    
    self.viewCountryPickerMain.removeFromSuperview()
    
  }
  @IBAction func countryCodeAction(_ sender: UIButton) {
    self.txt_Mobile.resignFirstResponder()
    self.view.addSubview(viewCountryPickerMain)
    self.viewCountryPickerMain.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
    countryPicker.countryPickerDelegate = self
    countryPicker.showPhoneNumbers = true
//    countryPicker.setCountry("SI")
//    countryPicker.setLocale("sl_SI")
//    countryPicker.setCountryByName("Canada")
  }
  
  
  private func setupLoginWithAppleButton() {
    if #available(iOS 13.0, *) {
      // self.appleLoginImageView.isHidden = false
      //Show sign-in with apple button. Create button here via code if you need.
    } else {
      // Fallback on earlier versions
      //Hide your sign in with apple button here.
      // self.appleLoginImageView.isHidden = true
    }
  }
  
  
  
  @IBAction func opensignupVC(_ sender: Any) {
    
    if fromSignUp {
      self.navigationController?.popViewController(animated: true)
    }else {
      openViewController(controller: SignupVC.self, storyBoard: .mainStoryBoard) { (vc) in
      }
    }
    
  }
  
  @IBAction func loginAction(_ sender: Any) {
    if txt_Mobile.text != ""{
      if ( txt_Mobile.text?.count)! >= 7  {
        self.sendLoginOtp()
      }
      else {
        
        Common.showAlert(alertMessage: "Invalid mobile number", alertButtons: ["Ok"]) { (bt) in
        }
        
      }
    }
    else {
      Common.showAlert(alertMessage: "Please enter mobile number", alertButtons: ["Ok"]) { (bt) in
      }
    }
    
  }
  
  func sendLoginOtp() {
    
//    let mobileNumber = "\(self.phoneCode)\(self.txt_Mobile.text ?? "")".replacingOccurrences(of: "+", with: "")
    
    let mobileNumber = self.txt_Mobile.text ?? ""
    
    debugPrint("mobileNumber = \(mobileNumber)")
    
    AppManager().startActivityIndicator(sender: self.view)
    
    LoginViewModel.shared.getLoginOtp(mobileNumber: mobileNumber, countryCode: self.phoneCode) { otp, isSuccess, message in
      
      AppManager().stopActivityIndicator(self.view)
      
      if isSuccess {
        debugPrint("OTP sent successfully")
        //Go to Otp Page
        self.openViewController(controller: OtpScreen.self, storyBoard: .mainStoryBoard) { (vc) in
          
          vc.isComingFromLogin = true
          vc.mobile = self.txt_Mobile.text ?? ""
          vc.countryCode = self.phoneCode
          //vc.otp = otp ?? ""
        }
        
      }else {
        Common.showAlert(alertMessage: message ?? "Please signup first", alertButtons: ["Ok"]) { (bt) in
        }
      }
      
    }
    
  }
}


   
extension VCLogin : MRCountryPickerDelegate {
    func countryPhoneCodePicker(_ picker: MRCountryPicker, didSelectCountryWithName name: String, countryCode: String, phoneCode: String, flag: UIImage) {
      print(phoneCode)
        self.coutnryCodeText.setTitle("\(phoneCode)", for: .normal)
      self.phoneCode = phoneCode
      
    }
}
