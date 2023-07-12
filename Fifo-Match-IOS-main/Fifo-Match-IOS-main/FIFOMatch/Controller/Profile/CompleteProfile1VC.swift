//
//  CompleteProfile1VC.swift
//  FlowDating
//
//  Created by deepti on 27/01/21.
//

import UIKit

class CompleteProfile1VC: UIViewController {
  
  @IBOutlet weak var backButtonOutlt: UIButton!
  @IBOutlet weak var emailTxtField: UITextField!
  @IBOutlet weak var setScrollView: UIScrollView!
  @IBOutlet weak var descriptionTxtView: UITextView!
  @IBOutlet weak var displayNameTxt: UITextField!
  @IBOutlet weak var txtDob: UITextField!
  @IBOutlet weak var maleBtn: UIButton!
  @IBOutlet weak var femaleBtn: UIButton!
  @IBOutlet weak var baseview2: UIView!
  
  @IBOutlet weak var roundedView: UIView!
  
  @IBOutlet weak var txtName: UITextField!
  
  @IBOutlet weak var txtEmail: UITextField!
  @IBOutlet weak var txtDate: UITextField!
  @IBOutlet weak var txtMonth: UITextField!
  @IBOutlet weak var txtYear: UITextField!
  @IBOutlet weak var txtRalationShipStatus: UITextField!
  @IBOutlet weak var txtOccupation: UITextField!
  @IBOutlet weak var txtEducation: UITextField!
  
  @IBOutlet weak var workingFifoYesBtn: UIButton!
  
  @IBOutlet weak var workingFifoNoBtn: UIButton!
  @IBOutlet weak var txtYourSwing: UITextField!
  @IBOutlet weak var txtViewDiscription: UITextView!
  
  @IBOutlet var sliderAge: RangeSlider!
  
  
  var getDate = "01 Jan 1970"
  let toolbar = UIToolbar()
  let datePicker = UIDatePicker()
  var isComingFromRegistration  = false
  let placeholderLabel = UILabel()
  var isMaleSelected  = true
  
  var workingFifo = ""
  var selectedRelationshipId = 0
  var selectedOccupationId = 0
  var selectedEducationId = 0
  
  var occupationPicker: UIPickerView!
  var relationshipStatusPicker: UIPickerView!
  var educationPicker: UIPickerView!
  
  var occupationArray = [ProfileList]()
  var relationshipStatusArray = [ProfileList]()
  var educationArray = [ProfileList]()
  
  var DateMonthYear = "Date"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUpUi()
    
    //    if isComingFromRegistration {
    //      if let value =   UserDefaults.standard.value(forKey: "completeProfile_1") as? Bool {
    //        if value{
    //          UserDefaults.standard.set(false, forKey: "completeProfile_1")
    //          //  Analytics.logEvent("complete_profile_1", parameters: ["complete_profile_1":"complete_profile_1"])
    //        }
    //      }
    //    }
    
    txtViewDiscription.delegate = self
    
    txtOccupation.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(occupationDoneBtnAcrion(_:)))
    txtEducation.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(educationDoneBtnAcrion(_:)))
    txtRalationShipStatus.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(relationshipDoneBtnAcrion(_:)))
    
    txtName.text = UserDefault.shared.getUserName()
    
    
    
    getProfileRelatedInfo()
    
    //   getUserProfileApi()
  }
  
  
  @objc func occupationDoneBtnAcrion(_ sender: Any) {
    if txtOccupation.text!.isEmptyOrWhitespace {
      txtOccupation.text = occupationArray.first?.name
      selectedOccupationId = occupationArray.first?.id ?? 1
    }
  }
  
  @objc func educationDoneBtnAcrion(_ sender: Any) {
    if txtEducation.text!.isEmptyOrWhitespace {
      txtEducation.text = educationArray.first?.name
      selectedEducationId = educationArray.first?.id ?? 1
    }
  }
  
  @objc func relationshipDoneBtnAcrion(_ sender: Any) {
    if txtRalationShipStatus.text!.isEmptyOrWhitespace {
      txtRalationShipStatus.text = relationshipStatusArray.first?.name
      selectedRelationshipId = relationshipStatusArray.first?.id ?? 1
    }
  }
  
  override func viewDidLayoutSubviews() {
    self.roundedView.roundCorners(corners: [.topLeft, .topRight], radius: 40)
    self.sliderAge.maximumValue = 70
    self.sliderAge.minimumValue = 18
  }
  override func viewWillAppear(_ animated: Bool) {
    
    self.navigationController?.setNavigationBarHidden(true, animated: false)
  }
  
  
  func setupDatePicker() {
    if #available(iOS 13.4, *) {
      datePicker.preferredDatePickerStyle = .wheels
    }
    
    datePicker.datePickerMode = .date
    toolbar.sizeToFit()
    
    
    let calendar = Calendar.current
    var components = calendar.dateComponents([.month], from: self.datePicker.date)
    components.calendar = calendar
    components.year = -18
    
    // for year only
    let maxDate = calendar.date(byAdding: components, to: Date())
    
    datePicker.maximumDate = maxDate
    let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
    let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
    let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
    
    toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
  }
  
  @objc func donedatePicker(){
    
    let formatter = DateFormatter()
    
    formatter.dateFormat = "dd"
    txtDate.text = formatter.string(from: datePicker.date)
    
    formatter.dateFormat = "MMM"
    txtMonth.text = formatter.string(from: datePicker.date)
    
    formatter.dateFormat = "yyyy"
    txtYear.text = formatter.string(from: datePicker.date)
    
    //    if DateMonthYear == "Date" {
    //      formatter.dateFormat = "dd"
    //      txtDate.text = formatter.string(from: datePicker.date)
    //
    //    }else if DateMonthYear == "Month" {
    //      formatter.dateFormat = "MMM"
    //      txtMonth.text = formatter.string(from: datePicker.date)
    //
    //    }else if DateMonthYear == "Year" {
    //      formatter.dateFormat = "yyyy"
    //      txtYear.text = formatter.string(from: datePicker.date)
    //
    //    }
    formatter.dateFormat = "yyyy-MM-dd "
    getDate = formatter.string(from: datePicker.date)
    
    txtDate.resignFirstResponder()
    txtYear.resignFirstResponder()
    txtMonth.resignFirstResponder()
    
  }
  @objc func cancelDatePicker(){
    self.view.endEditing(true)
  }
  
  func setUpUi(){
    
    self.txtEmail.LeftView(of: nil)
    self.txtName.LeftView(of: nil)
    
    self.txtDate.LeftView(of: nil)
    self.txtMonth.LeftView(of: nil)
    self.txtYear.LeftView(of: nil)
    self.txtRalationShipStatus.LeftView(of: nil)
    self.txtOccupation.LeftView(of: nil)
    self.txtEducation.LeftView(of: nil)
    self.txtYourSwing.LeftView(of: nil)
    
    self.txtDate.RightViewImage(UIImage(named: "dropdown-arrow"))
    self.txtMonth.RightViewImage(UIImage(named: "dropdown-arrow"))
    self.txtYear.RightViewImage(UIImage(named: "dropdown-arrow"))
    self.txtRalationShipStatus.RightViewImage(UIImage(named: "dropdown-arrow"))
    self.txtOccupation.RightViewImage(UIImage(named: "dropdown-arrow"))
    self.txtEducation.RightViewImage(UIImage(named: "dropdown-arrow"))
    txtViewDiscription.toolbarPlaceholder = "Enter description"
    
    
    txtViewDiscription.delegate = self
    txtViewDiscription.text = "Enter description"
    txtViewDiscription.textColor = UIColor.lightGray
    
    //////// Setup txtRalationShipStatus Picker //////////
    relationshipStatusPicker = UIPickerView()
    relationshipStatusPicker.delegate = self
    relationshipStatusPicker.dataSource = self
    txtRalationShipStatus.inputView = relationshipStatusPicker
    
    //////// Setup txtOccupation Picker //////////
    occupationPicker = UIPickerView()
    occupationPicker.delegate = self
    occupationPicker.dataSource = self
    txtOccupation.inputView = occupationPicker
    
    //////// Setup txtEducation Picker //////////
    educationPicker = UIPickerView()
    educationPicker.delegate = self
    educationPicker.dataSource = self
    txtEducation.inputView = educationPicker
    
    txtDate.inputAccessoryView = toolbar
    txtMonth.inputAccessoryView = toolbar
    txtYear.inputAccessoryView = toolbar
    
    txtDate.inputView = datePicker
    txtMonth.inputView = datePicker
    txtYear.inputView = datePicker
    
    txtDate.delegate = self
    txtMonth.delegate = self
    txtYear.delegate = self
    
  }
  
  @IBAction func birthDateAction(_ sender: Any) {
    //        showDatePicker()
  }
  
  @IBAction func backButtonAction(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
  }
  
  
  @IBAction func maleAction(_ sender: UIButton) {
    //        sender.selectedbtn()
    
    isMaleSelected = true
    sender.setImage(#imageLiteral(resourceName: "man"), for: .normal)
    femaleBtn.setImage(#imageLiteral(resourceName: "woman"), for: .normal)
    sender.setTitleColor(UIColor(red: 148/255, green: 51/255, blue: 203/255, alpha: 1), for: .normal)
    sender.layer.borderColor = UIColor(red: 148/255, green: 51/255, blue: 203/255, alpha: 1).cgColor
    femaleBtn.layer.borderColor = UIColor.lightGray.cgColor
    femaleBtn.setTitleColor(.lightGray, for: .normal)
    //        femaleBtn.normalbtn()
    
  }
  
  @IBAction func fifoButtonsAction(_ sender: UIButton) {
    
    if sender.tag == 0 { // Yes
      workingFifo = "yes"
      sender.tintColor = CustomColor.themeOrangecolor
      sender.layer.borderColor = CustomColor.themeOrangecolor.cgColor
      workingFifoNoBtn.tintColor = CustomColor.themeLightGray
      workingFifoNoBtn.layer.borderColor = CustomColor.themeLightGray.cgColor
      
    }else { // No
      workingFifo = "no"
      sender.tintColor = CustomColor.themeOrangecolor
      sender.layer.borderColor = CustomColor.themeOrangecolor.cgColor
      workingFifoYesBtn.tintColor = CustomColor.themeLightGray
      workingFifoYesBtn.layer.borderColor = CustomColor.themeLightGray.cgColor
    }
  }
  
  @IBAction func saveAndContinueAction(_ sender: Any) {
    //        if Validate.shared.validateCompletePrfoile(vc:self){
    //            self.completeUserProfile1()
    //        }
    
    //openViewController(controller: MultiplePictureUploadVC.self, storyBoard: .mainStoryBoard) { (vc) in
    
    //}
    
    updateProfile()
    
  }
  @IBAction func femaleAction(_ sender: UIButton) {
    //        sender.selectedbtn()
    
    isMaleSelected = false
    maleBtn.setImage(#imageLiteral(resourceName: "man-1"), for: .normal)
    sender.setImage(#imageLiteral(resourceName: "woman-2"), for: .normal)
    sender.setTitleColor(UIColor(red: 168/255, green: 0/255, blue: 255/255, alpha: 1), for: .normal)
    sender.layer.borderColor = UIColor(red: 168/255, green: 0/255, blue: 255/255, alpha: 1).cgColor
    maleBtn.layer.borderColor = UIColor.lightGray.cgColor
    maleBtn.setTitleColor(.lightGray, for: .normal)
    //        maleBtn.normalbtn()
  }
  func textViewDidBeginEditing(_ textView: UITextView) {
    
    //        if descriptionTxtView.textColor == UIColor.lightGray {
    //            descriptionTxtView.text = ""
    //            descriptionTxtView.textColor = UIColor.black
    //        }
  }
  
}

//MARK: - Api Calls
extension CompleteProfile1VC {
  
  func getProfileRelatedInfo() {
    
    AppManager().startActivityIndicator(sender: self.view)
    
    CompleteProfileViewModel.shared.getProfileRelatedInfo { relationShipList, occupationList, educationList, isSuccess, message in
      
      AppManager().stopActivityIndicator(self.view)
      
      guard isSuccess else {
        Common.showAlert(alertMessage: message ?? "", alertButtons: ["Ok"]) { (bt) in
        }
        return
      }
      
      self.relationshipStatusArray = relationShipList
      self.occupationArray = occupationList
      self.educationArray = educationList
      
    }
  }
  
  func updateProfile() {
    
    guard validateInfo() else { return }
    
    let sliderMinValue = Int(sliderAge.lowerValue.rounded())
    let sliderMaxValue = Int(sliderAge.upperValue.rounded())
    
    let parameters: [String: Any] = [
      "email": txtEmail.text ?? "",
      "dob": getDate,
      "about": txtViewDiscription.text ?? "",
      "min_age" : sliderMinValue,
      "max_age" : sliderMaxValue,
      "relationship_status" : selectedRelationshipId,
      "occupation" : selectedOccupationId,
      "education" : selectedEducationId,
      "working_fifo" : workingFifo,
      "swing" : txtYourSwing.text ?? ""
    ]
    
    AppManager().startActivityIndicator(sender: self.view)
    
    CompleteProfileViewModel.shared.updateProfile(parameters: parameters) { response, isSuccess, message in
      
      AppManager().stopActivityIndicator(self.view)
      
      guard let response = response, isSuccess else {
        Common.showAlert(alertMessage: message ?? "", alertButtons: ["Ok"]) { (bt) in
        }
        return
      }

      if let profileStatus = response.data?.profileComplete {
        UserDefault.shared.saveProfileUpdate(status: profileStatus)
      }
      
      self.openViewController(controller: MultiplePictureUploadVC.self, storyBoard: .mainStoryBoard) { (vc) in }
      
    }
    
  }
  
  func validateInfo() -> Bool {
    
    if let name = txtName.text, name.isEmptyOrWhitespace {
      Common.showAlert(alertMessage: Messages.NAME_EMPTY.rawValue, alertButtons: ["Ok"]) { (bt) in
      }
      return false
    }
    
    if let email = txtEmail.text, email.isEmptyOrWhitespace {
      Common.showAlert(alertMessage: Messages.EMAIL_EMPTY.rawValue, alertButtons: ["Ok"]) { (bt) in
      }
      return false
    }

    if !AppManager().validateEmail(with: txtEmail.text) {
      Common.showAlert(alertMessage: Messages.EMAIL_INVALID.rawValue, alertButtons: ["Ok"]) { (bt) in
      }
      return false
    }
    
    if let date = txtDate.text, date.isEmptyOrWhitespace, let month = txtMonth.text, month.isEmptyOrWhitespace, let year = txtYear.text, year.isEmptyOrWhitespace {
      
      Common.showAlert(alertMessage: Messages.DOB_ERROR.rawValue, alertButtons: ["Ok"]) { (bt) in
      }
      return false
    }
    
    
    
    if let relationship = txtRalationShipStatus.text, relationship.isEmptyOrWhitespace {
      Common.showAlert(alertMessage: Messages.Relationship_Error.rawValue, alertButtons: ["Ok"]) { (bt) in
      }
      return false
    }
    
    if let occupation = txtOccupation.text, occupation.isEmptyOrWhitespace {
      Common.showAlert(alertMessage: Messages.OCCUPATION_ERROR.rawValue, alertButtons: ["Ok"]) { (bt) in
      }
      return false
    }
    
    if let education = txtEducation.text, education.isEmptyOrWhitespace {
      Common.showAlert(alertMessage: Messages.EDUCATION_ERROR.rawValue, alertButtons: ["Ok"]) { (bt) in
      }
      return false
    }
    
    if workingFifo.isEmptyOrWhitespace {
      Common.showAlert(alertMessage: "Please fill all the information", alertButtons: ["Ok"]) { (bt) in
      }
      return false
    }
    
    if let description = txtViewDiscription.text, description == "Enter description" {
      Common.showAlert(alertMessage: "Please fill description about you", alertButtons: ["Ok"]) { (bt) in
      }
      return false
    }
      
      if let description = txtViewDiscription.text, description.count < 22 {
          
        Common.showAlert(alertMessage: Messages.DESCRIPTION_LENGTH.rawValue, alertButtons: ["Ok"]) { (bt) in
        }
        return false
      }
      
      
    
    return true
  }
  
}

extension CompleteProfile1VC: UITextFieldDelegate {
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == displayNameTxt {
      textField.resignFirstResponder()
      return true
    }
    return  true
  }
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    if textField == txtDate{
      DateMonthYear = "Date"
    }else if textField == txtMonth{
      DateMonthYear = "Month"
    }else if textField == txtYear{
      DateMonthYear = "Year"
    }
    setupDatePicker()
    
  }
  
  func textViewDidChange(_ textView: UITextView) {
    // placeholderLabel.isHidden = !descriptionTxtView.text.isEmpty
  }
  func jsonToData(json: Any) -> Data? {
    do {
      return try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted)
    } catch let myJSONError {
      print(myJSONError)
    }
    return nil;
  }
  func calcAge(birthday: String) -> Int {
    let dateFormater = DateFormatter()
    dateFormater.dateFormat = "dd MMM yyyy"
    let birthdayDate = dateFormater.date(from: birthday) ?? Date()
    let calendar: NSCalendar! = NSCalendar(calendarIdentifier: .gregorian)
    let now = Date()
    let calcAge = calendar.components(.year, from: birthdayDate, to: now, options: [])
    let age = calcAge.year
    return age!
  }
}

extension CompleteProfile1VC: UITextViewDelegate {
  
  func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
    if textView.text == "Enter description" {
      textView.text = ""
      textView.textColor = UIColor.label
    }
    return true
  }
  
  func textViewDidEndEditing(_ textView: UITextView) {
    
    if textView.text.isEmpty {
      txtViewDiscription.text = "Enter description"
      txtViewDiscription.textColor = UIColor.lightGray
    }
  }
  
//  func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//
//    if textView == txtViewDiscription {
//
//      let currentText = textView.text ?? ""
//      guard let stringRange = Range(range, in: currentText) else { return false }
//      let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
//
//      return updatedText.count <= 22
//    }
//
//    return false
//
//  }
  
}

extension CompleteProfile1VC: UIPickerViewDelegate,UIPickerViewDataSource {
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    
    if pickerView == relationshipStatusPicker {
      return relationshipStatusArray.count
    }else if pickerView == occupationPicker{
      return occupationArray.count
    }else if pickerView == educationPicker{
      return educationArray.count
    }else{
      return 0
    }
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    
    if pickerView == relationshipStatusPicker {
      let data = relationshipStatusArray[row].name
      return data
    }else if pickerView == occupationPicker {
      let data = occupationArray[row].name
      return data
    }else if pickerView == educationPicker {
      let data = educationArray[row].name
      return data
    }else {
      return nil
    }
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    if pickerView == relationshipStatusPicker {
      self.txtRalationShipStatus.text = relationshipStatusArray[row].name
      self.selectedRelationshipId = relationshipStatusArray[row].id ?? 0
      
    }else if pickerView == occupationPicker {
      self.txtOccupation.text = occupationArray[row].name
      self.selectedOccupationId = occupationArray[row].id ?? 0
      
    }else if pickerView == educationPicker {
      self.txtEducation.text = educationArray[row].name
      self.selectedEducationId = educationArray[row].id ?? 0
    }
  }
}
