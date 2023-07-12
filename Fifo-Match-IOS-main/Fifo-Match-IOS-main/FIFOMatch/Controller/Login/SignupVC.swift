// //  SignupVC.swift
//  FlowDating
//
//  Created by deepti on 25/01/21.
//

import UIKit
import CoreLocation
import MRCountryPicker
import IQKeyboardManagerSwift

class SignupVC: UIViewController {
  
  let geoCoder = CLGeocoder()
  
  var iAmAPicker: UIPickerView!
  var intrestedPicker: UIPickerView!
  
  var iAmAArray = ["Man","Woman","Transgender"]
  var intrestedArray = ["Man","Woman","Transgender"]
  
  
  @IBOutlet weak var tableView: UITableView!
  
  @IBOutlet weak var coutnryCodeText: UIButton!
  
  @IBOutlet weak var btnAcceptConditions: UIButton!
  @IBOutlet weak var txtfieldIAmA: UITextField!
  @IBOutlet weak var txtfieldIntrestedIn: UITextField!
  @IBOutlet weak var txt_mobile: UITextField!
  @IBOutlet weak var txt_FirstName: UITextField!
  @IBOutlet weak var roundedView: UIView!
  @IBOutlet weak var countryTF: UITextField!
  
  @IBOutlet var viewCountryPickerMain: UIView!
  @IBOutlet weak var countryPicker: MRCountryPicker!
  
  
  let countryPicker1 = MRCountryPicker()
  
  var acceptTermCondition = false
  
  var phoneCode = "+61"
  var selectedCountryName = "Australia"
  var latitude = 0.0
  var longitude = 0.0
  let locationManager = CLLocationManager()
  
  var fromIntro = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.txt_FirstName.delegate = self
    self.txt_FirstName.LeftView(of: nil)
    self.txtfieldIAmA.LeftView(of: nil)
    self.txtfieldIntrestedIn.LeftView(of: nil)
    self.countryTF.LeftView(of: nil)
    
    self.txtfieldIAmA.RightViewImage(UIImage(named: "dropdown-arrow"))
    self.txtfieldIntrestedIn.RightViewImage(UIImage(named: "dropdown-arrow"))
    self.countryTF.RightViewImage(UIImage(named: "dropdown-arrow"))
    
    coutnryCodeText.setTitle(phoneCode, for: .normal)

    
    //////// Setup iAm Picker //////////
    iAmAPicker = UIPickerView()
    iAmAPicker.delegate = self
    iAmAPicker.dataSource = self
    txtfieldIAmA.inputView = iAmAPicker
    
    //////// Setup Intrested Picker //////////
    intrestedPicker = UIPickerView()
    intrestedPicker.delegate = self
    intrestedPicker.dataSource = self
    txtfieldIntrestedIn.inputView = intrestedPicker
    
    //////// Setup country Picker Picker //////////
    countryPicker1.countryPickerDelegate = self
    countryPicker1.showPhoneNumbers = false
    countryTF.inputView = countryPicker1
    
    txtfieldIAmA.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(iAmPickerDoneBtnAcrion(_:)))
    txtfieldIntrestedIn.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(intrestedInDoneBtnAcrion(_:)))
    
  }
  override func viewDidLayoutSubviews() {
    self.roundedView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 40)
  }
  
  @objc func iAmPickerDoneBtnAcrion(_ sender: Any) {
    if txtfieldIAmA.text!.isEmptyOrWhitespace {
      txtfieldIAmA.text = iAmAArray.first
    }
  }
  
  @objc func intrestedInDoneBtnAcrion(_ sender: Any) {
    if txtfieldIntrestedIn.text!.isEmptyOrWhitespace {
      txtfieldIntrestedIn.text = intrestedArray.first
    }
  }
  
  
  @IBAction func btnTermCondition(_ sender: Any) {
    openViewController(controller: VCWebView.self, storyBoard: .homeStoryboard) { (vc) in
        vc.screenTitle = "Terms & Conditions"
    }
  }
  
  @IBAction func btnAcceptConditions(_ sender: UIButton) {
    
    if acceptTermCondition{
      btnAcceptConditions.setImage(UIImage(named: "RectangleUnselect"), for: .normal)
      acceptTermCondition = false
    }else{
      btnAcceptConditions.setImage(UIImage(named: "RectangleSelect"), for: .normal)
      acceptTermCondition = true
      
    }
    
  }
  @IBAction func countryPickerCancel(_ sender: Any) {
    self.viewCountryPickerMain.removeFromSuperview()
  }
  
  @IBAction func countryPickerDone(_ sender: Any) {
    self.viewCountryPickerMain.removeFromSuperview()
  }
  
  @IBAction func openloginVC(_ sender: Any) {
    if fromIntro {
      openViewController(controller: VCLogin.self, storyBoard: .mainStoryBoard) { (vc) in
        vc.fromSignUp = true
      }
    }else {
      self.navigationController?.popViewController(animated: true)
    }
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    //        if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
    //            print(countryCode)
    //            countryPickerView.setCountry(countryCode)
    //        }
    //  self.countryPickerView.isHidden = true//
    
  }
  
  @IBAction func backButtonAction(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
  }
  
  
  
  @IBAction func signupAction(_ sender: Any) {
    
    guard validateInformation() else { return }
    
    if txt_mobile.text != ""{
      if ( txt_mobile.text?.count)! >= 7  {
        //Analytics.logEvent("phone_signup", parameters: ["phone_signup":"phone_signup"])
        self.requestForSginUpOtp()
      } else {
        
        Common.showAlert(alertMessage: "Invalid mobile number", alertButtons: ["Ok"]) { (bt) in
        }
        
      }
    }
    else {
      Common.showAlert(alertMessage: "Please enter mobile number", alertButtons: ["Ok"]) { (bt) in
      }
    }
    
    
//    openViewController(controller: CompleteProfile1VC.self, storyBoard: .mainStoryBoard) { (vc) in
//
//    }
    
  }
  
  func validateInformation() -> Bool {
    if let name = txt_FirstName.text, name.isEmptyOrWhitespace {
      Common.showAlert(alertMessage: Messages.NAME_EMPTY.rawValue, alertButtons: ["Ok"]) { (bt) in
      }
      return false
    }
    
    if let name = txt_FirstName.text, name.count < 3 {
      Common.showAlert(alertMessage: Messages.FULL_NAME_LENGTH.rawValue, alertButtons: ["Ok"]) { (bt) in
      }
      return false
    }
    
    if let gender = txtfieldIAmA.text, gender.isEmptyOrWhitespace {
      Common.showAlert(alertMessage: Messages.GENDER_ERROR.rawValue, alertButtons: ["Ok"]) { (bt) in
      }
      return false
    }
    
    if let intrestIn = txtfieldIntrestedIn.text, intrestIn.isEmptyOrWhitespace {
      Common.showAlert(alertMessage: Messages.INTERESTIN_ERROR.rawValue, alertButtons: ["Ok"]) { (bt) in
      }
      return false
    }
    
    if let country = countryTF.text, country.isEmptyOrWhitespace {
      Common.showAlert(alertMessage: Messages.COUNTRY_EMPTY.rawValue, alertButtons: ["Ok"]) { (bt) in
      }
      return false
    }
    
    
    if !acceptTermCondition {
      Common.showAlert(alertMessage: Messages.TermAndCondition.rawValue, alertButtons: ["Ok"]) { (bt) in
      }
      return false
    }
    
    return true
  }
  
  
  @IBAction func countryCodeAction(_ sender: UIButton) {
    self.view.addSubview(viewCountryPickerMain)
    self.viewCountryPickerMain.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
    countryPicker.countryPickerDelegate = self
    countryPicker.showPhoneNumbers = true
//    countryPicker.setCountry("SI")
//    countryPicker.setLocale("sl_SI")
//    countryPicker.setCountryByName("Canada")
  }
  
  func requestForSginUpOtp() {
    
//    let mobileNumber = "\(self.phoneCode)\(self.txt_mobile.text ?? "")".replacingOccurrences(of: "+", with: "")
    
    let mobileNumber = self.txt_mobile.text ?? ""
    
    debugPrint("mobileNumber = \(mobileNumber)")
    
    AppManager().startActivityIndicator(sender: self.view)
    
    SignUpViewModel.shared.requestForSignUpOtp(mobileNumber: mobileNumber, countryCode: phoneCode) { otp, isSuccess, message in
      
      AppManager().stopActivityIndicator(self.view)
      
      if isSuccess {
        debugPrint("OTP sent successfully")
        
        //let mobileNumber = "\(self.phoneCode)\(self.txt_mobile.text ?? "")".replacingOccurrences(of: "+", with: "")
        
        //Go to Otp Page
        self.openViewController(controller: OtpScreen.self, storyBoard: .mainStoryBoard) { (vc) in
          
          let parameters: [String: Any] = [
            "name": self.txt_FirstName.text ?? "",
            "mobile_number": mobileNumber,
            "gender": self.txtfieldIAmA.text ?? "",
            "interested_in": self.txtfieldIntrestedIn.text ?? "",
            "country_code": self.phoneCode,
            "country_name": self.selectedCountryName
          ]
          
          vc.signUpParameters = parameters
          vc.isComingFromLogin = false
          vc.mobile = self.txt_mobile.text ?? ""
          vc.countryCode = self.phoneCode
          vc.otp = "\(otp ?? 0)"
        }
        
      }else {
        Common.showAlert(alertMessage: message ?? "", alertButtons: ["Ok"]) { (bt) in
        }
      }
    }
  }
}

extension SignupVC : MRCountryPickerDelegate {
  
  func countryPhoneCodePicker(_ picker: MRCountryPicker, didSelectCountryWithName name: String, countryCode: String, phoneCode: String, flag: UIImage) {
    
    if picker == countryPicker1 {
      self.countryTF.text = name
      self.selectedCountryName = name
      return
    }
    
    print(phoneCode)
    self.coutnryCodeText.setTitle("\(phoneCode)", for: .normal)
    self.phoneCode = phoneCode
    self.selectedCountryName = name
    self.countryTF.text = name
  }
}

extension SignupVC: UIPickerViewDelegate,UIPickerViewDataSource {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  
  func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    
    if pickerView == iAmAPicker {
      return iAmAArray.count
    }else if pickerView == intrestedPicker{
      return intrestedArray.count
    }else{
      return 0
    }
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    
    
    if pickerView == iAmAPicker {
      let data = iAmAArray[row]
      return data
    }else if pickerView == intrestedPicker{
      let data = intrestedArray[row]
      return data
    }else{
      return nil
    }
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    if pickerView == iAmAPicker {
      self.txtfieldIAmA.text = iAmAArray[row]
    }else if pickerView == intrestedPicker{
      self.txtfieldIntrestedIn.text = intrestedArray[row]
    }else{
      
    }
  }
}

extension SignupVC: UITextFieldDelegate {
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
    if textField == txt_FirstName {
      let allowedCharacter = CharacterSet.letters
      let allowedCharacter1 = CharacterSet.whitespaces
      let characterSet = CharacterSet(charactersIn: string)
      
      let currentText = textField.text ?? ""
      guard let stringRange = Range(range, in: currentText) else { return false }
      let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

      if allowedCharacter.isSuperset(of: characterSet) || allowedCharacter1.isSuperset(of: characterSet) {
        return updatedText.count <= 22
      }
    }
    
    return false
  }
}
