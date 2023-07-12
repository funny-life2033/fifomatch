//
//  ProfileInformationVC.swift
//  FIFOMatch
//
//  Created by Harendra Singh Rathore on 05/04/22.
//

import UIKit

class ProfileInformationVC: UIViewController {
  
  @IBOutlet weak var profileImg: UIImageView!
  @IBOutlet weak var editProfileBtn: UIButton!
  
  @IBOutlet weak var nameTF: UITextField!
  @IBOutlet weak var emailTF: UITextField!
  @IBOutlet weak var mobileNumberTF: UITextField!
  @IBOutlet weak var dobTF: UITextField!
  @IBOutlet weak var genderTF: UITextField!
  @IBOutlet weak var interestedTF: UITextField!
  @IBOutlet weak var relationshipTF: UITextField!
  @IBOutlet weak var occupationTF: UITextField!
  @IBOutlet weak var educationTF: UITextField!
  
  var dob = "01 Jan 1970"
  let toolbar = UIToolbar()
  let datePicker = UIDatePicker()
  
  var isMaleSelected  = true
  
  var selectedRelationshipId = 0
  var selectedOccupationId = 0
  var selectedEducationId = 0
  
  var occupationPicker: UIPickerView!
  var relationshipStatusPicker: UIPickerView!
  var educationPicker: UIPickerView!
  
  var occupationArray = [ProfileList]()
  var relationshipStatusArray = [ProfileList]()
  var educationArray = [ProfileList]()
  
  
  var iAmAPicker: UIPickerView!
  var intrestedPicker: UIPickerView!
  
  var iAmAArray = ["Man","Woman","Transgender"]
  var intrestedArray = ["Man","Woman","Transgender"]
  
  var profile: UserProfileDetails?
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupUi()
    getUserProfileDetails()
    getProfileRelatedInfo()
    
  }
  
  @IBAction func backBtnAction(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
  }
  
  @IBAction func updateBtnAction(_ sender: UIButton) {
    updateProfile()
  }
  
  @IBAction func editProfileBtnAction(_ sender: UIButton) {
    openPickerForImage()
  }
  
  func setupUi() {
    
    profileImg.layer.cornerRadius = profileImg.frame.height/2
    profileImg.layer.borderColor = CustomColor.themeOrangecolor.cgColor
    profileImg.layer.borderWidth = 2
    
    editProfileBtn.setTitle("", for: .normal)
    
    nameTF.delegate = self
    self.nameTF.LeftView(of: nil)
    self.emailTF.LeftView(of: nil)
    self.mobileNumberTF.LeftView(of: nil)
    self.dobTF.LeftView(of: nil)
    self.genderTF.LeftView(of: nil)
    self.interestedTF.LeftView(of: nil)
    self.relationshipTF.LeftView(of: nil)
    self.occupationTF.LeftView(of: nil)
    self.educationTF.LeftView(of: nil)
    
    self.dobTF.RightViewImage(UIImage(named: "dropdown-arrow"))
    self.genderTF.RightViewImage(UIImage(named: "dropdown-arrow"))
    self.interestedTF.RightViewImage(UIImage(named: "dropdown-arrow"))
    self.relationshipTF.RightViewImage(UIImage(named: "dropdown-arrow"))
    self.occupationTF.RightViewImage(UIImage(named: "dropdown-arrow"))
    self.educationTF.RightViewImage(UIImage(named: "dropdown-arrow"))
    
    relationshipStatusPicker = UIPickerView()
    relationshipStatusPicker.delegate = self
    relationshipStatusPicker.dataSource = self
    relationshipTF.inputView = relationshipStatusPicker
    
    occupationPicker = UIPickerView()
    occupationPicker.delegate = self
    occupationPicker.dataSource = self
    occupationTF.inputView = occupationPicker
    
    educationPicker = UIPickerView()
    educationPicker.delegate = self
    educationPicker.dataSource = self
    educationTF.inputView = educationPicker
    
    dobTF.inputAccessoryView = toolbar
    dobTF.inputView = datePicker
    //dobTF.delegate = self
    
    iAmAPicker = UIPickerView()
    iAmAPicker.delegate = self
    iAmAPicker.dataSource = self
    genderTF.inputView = iAmAPicker
    
    intrestedPicker = UIPickerView()
    intrestedPicker.delegate = self
    intrestedPicker.dataSource = self
    interestedTF.inputView = intrestedPicker
    
    genderTF.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(iAmPickerDoneBtnAcrion(_:)))
    interestedTF.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(intrestedInDoneBtnAcrion(_:)))
    occupationTF.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(occupationDoneBtnAcrion(_:)))
    educationTF.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(educationDoneBtnAcrion(_:)))
    relationshipTF.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(relationshipDoneBtnAcrion(_:)))
    
  
    setupDatePicker()
    
  }
  
  @objc func iAmPickerDoneBtnAcrion(_ sender: Any) {
    if genderTF.text!.isEmptyOrWhitespace {
      genderTF.text = iAmAArray.first
    }
  }
  
  @objc func intrestedInDoneBtnAcrion(_ sender: Any) {
    if interestedTF.text!.isEmptyOrWhitespace {
      interestedTF.text = intrestedArray.first
    }
  }
  
  @objc func occupationDoneBtnAcrion(_ sender: Any) {
    if occupationTF.text!.isEmptyOrWhitespace {
      occupationTF.text = occupationArray.first?.name
      selectedOccupationId = occupationArray.first?.id ?? 1
    }
  }
  
  @objc func educationDoneBtnAcrion(_ sender: Any) {
    if educationTF.text!.isEmptyOrWhitespace {
      educationTF.text = educationArray.first?.name
      selectedEducationId = educationArray.first?.id ?? 1
    }
  }
  
  @objc func relationshipDoneBtnAcrion(_ sender: Any) {
    if relationshipTF.text!.isEmptyOrWhitespace {
      relationshipTF.text = relationshipStatusArray.first?.name
      selectedRelationshipId = relationshipStatusArray.first?.id ?? 1
    }
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
    components.month = -1
    
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
    
    formatter.dateFormat = "yyyy-MM-dd "
    dob = formatter.string(from: datePicker.date)
    dobTF.text = dob
    dobTF.resignFirstResponder()
    
  }
  @objc func cancelDatePicker(){
    self.view.endEditing(true)
  }
  
}

extension ProfileInformationVC: UIPickerViewDelegate, UIPickerViewDataSource {
  
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
    }else if pickerView == relationshipStatusPicker {
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
    
    if pickerView == iAmAPicker {
      let data = iAmAArray[row]
      return data
    }else if pickerView == intrestedPicker{
      let data = intrestedArray[row]
      return data
    }else if pickerView == relationshipStatusPicker {
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
    
    if pickerView == iAmAPicker {
      self.genderTF.text = iAmAArray[row]
      
    }else if pickerView == intrestedPicker{
      self.interestedTF.text = intrestedArray[row]
      
    }else if pickerView == relationshipStatusPicker {
      self.relationshipTF.text = relationshipStatusArray[row].name
      self.selectedRelationshipId = relationshipStatusArray[row].id ?? 0
      
    }else if pickerView == occupationPicker {
      self.occupationTF.text = occupationArray[row].name
      self.selectedOccupationId = occupationArray[row].id ?? 0
      
    }else if pickerView == educationPicker {
      self.educationTF.text = educationArray[row].name
      self.selectedEducationId = educationArray[row].id ?? 0
    }
  }
}

//MARK: - Api Calls
extension ProfileInformationVC {
  
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
  
  func getUserProfileDetails() {
    
    AppManager().startActivityIndicator(sender: self.view)
    
    UserProfileViewModel.shared.getUserProfileDetails { response, isSuccess, message in
      
      AppManager().stopActivityIndicator(self.view)
      
      guard let response = response, isSuccess else {
        Common.showAlert(alertMessage: message ?? "", alertButtons: ["Ok"]) { (bt) in
        }
        return
      }
      
      guard self.checkStatus(status: response.status, message: response.message) else {
        return
      }
      
      if let data = response.data {
        self.profile = data
        self.setupData(profile: data)
      }
    }
  }
  
  func setupData(profile: UserProfileDetails) {
    
    nameTF.text = profile.name
    emailTF.text = profile.email
    mobileNumberTF.text = profile.mobile
    dobTF.text = profile.dob
    dob = profile.dob ?? ""
    genderTF.text = profile.gender?.capitalized
    interestedTF.text = profile.interestedIn?.capitalized
    relationshipTF.text = profile.relationshipData?.name
    occupationTF.text = profile.occupation?.name
    educationTF.text = profile.education?.name
    
    selectedEducationId = profile.educationID ?? 0
    selectedOccupationId = profile.occupationID ?? 0
    selectedRelationshipId = profile.relationshipStatusID ?? 0
    
    if let profileImage = profile.photos?.first?.name {
      if let url = URL(string: profileImage) {
        profileImg.kf.setImage(with: url)
      }
    }
    
  }
  
    func updateProfile() {
  
      guard validateInfo() else { return }
  
      let parameters: [String: Any] = [
      
        "email": emailTF.text ?? "",
        "name": nameTF.text ?? "",
        "gender": genderTF.text ?? "",
        "interested_in": interestedTF.text ?? "",
        "dob": dob,
        "relationship_status_id" : selectedRelationshipId,
        "occupation_id" : selectedOccupationId,
        "education_id" : selectedEducationId
      ]
      
      let photoParams: [String: UIImage?] = ["image": profileImg.image]
      
    
      AppManager().startActivityIndicator(sender: self.view)
      
      UserProfileViewModel.shared.updateUserDetails(images: photoParams, params: parameters) { response, isSuccess, message in
        
        AppManager().stopActivityIndicator(self.view)
        
        guard let response = response, isSuccess else {
          Common.showAlert(alertMessage: message ?? "", alertButtons: ["Ok"]) { (bt) in
          }
          return
        }
        
        guard self.checkStatus(status: response.status, message: response.message) else {
          return
        }
        
        NotificationCenter.default.post(name: .updateProfile, object: nil)
      
        Toast.shared.show(message: response.message ?? "Updated Successfully", controller: self)
        
      }
  
    }
  
    func validateInfo() -> Bool {
  
      if let name = nameTF.text, name.isEmptyOrWhitespace {
        Common.showAlert(alertMessage: Messages.NAME_EMPTY.rawValue, alertButtons: ["Ok"]) { (bt) in
        }
        return false
      }
      
      if let name = nameTF.text, name.count < 3 {
        Common.showAlert(alertMessage: Messages.FULL_NAME_LENGTH.rawValue, alertButtons: ["Ok"]) { (bt) in
        }
        return false
      }
      
      if emailTF.text != "" {
        if !AppManager().validateEmail(with: emailTF.text) {
          Common.showAlert(alertMessage: Messages.EMAIL_INVALID.rawValue, alertButtons: ["Ok"]) { (bt) in
          }
          return false
        }
      }
      
      
      if let gender = genderTF.text, gender.isEmptyOrWhitespace {
        Common.showAlert(alertMessage: Messages.GENDER_ERROR.rawValue, alertButtons: ["Ok"]) { (bt) in
        }
        return false
      }
      
      if let interestIn = interestedTF.text, interestIn.isEmptyOrWhitespace {
        Common.showAlert(alertMessage: Messages.INTERESTIN_ERROR.rawValue, alertButtons: ["Ok"]) { (bt) in
        }
        return false
      }
  
      if let date = dobTF.text, date.isEmptyOrWhitespace {
  
        Common.showAlert(alertMessage: Messages.DOB_ERROR.rawValue, alertButtons: ["Ok"]) { (bt) in
        }
        return false
      }
  
      if selectedRelationshipId == 0 {
        Common.showAlert(alertMessage: Messages.Relationship_Error.rawValue, alertButtons: ["Ok"]) { (bt) in
        }
        return false
      }
  
      if selectedOccupationId == 0 {
        Common.showAlert(alertMessage: Messages.OCCUPATION_ERROR.rawValue, alertButtons: ["Ok"]) { (bt) in
        }
        return false
      }
  
      if selectedEducationId == 0 {
        Common.showAlert(alertMessage: Messages.EDUCATION_ERROR.rawValue, alertButtons: ["Ok"]) { (bt) in
        }
        return false
      }
  
  
      return true
    }
  
}
extension ProfileInformationVC {

  fileprivate func openGallery() {
    if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
      let imagePicker = UIImagePickerController()
      imagePicker.delegate = self
      imagePicker.allowsEditing = true
      imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
      self.present(imagePicker, animated: true, completion: nil)
    } else {
      let alert  = UIAlertController(title: "Warning", message: "You don't have permission to access gallery.", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
      self.present(alert, animated: true, completion: nil)
    }
  }
  
  fileprivate func openCamera() {
    if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
      let imagePicker = UIImagePickerController()
      imagePicker.delegate = self
      imagePicker.sourceType = UIImagePickerController.SourceType.camera
      imagePicker.allowsEditing = true
      self.present(imagePicker, animated: true, completion: nil)
    } else {
      let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
      self.present(alert, animated: true, completion: nil)
    }
  }
  
  func openPickerForImage() {
    
    let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
    alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
      self.openCamera()
    }))
    alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
      self.openGallery()
    }))

    alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
    self.present(alert, animated: true, completion: nil)
  }
  
}

extension ProfileInformationVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
    picker.dismiss(animated: true,completion: nil)
    
    if let img = info[.editedImage] as? UIImage {
      self.profileImg.image = img
      
    }else if let img = info[.originalImage] as? UIImage {
      self.profileImg.image = img
    }
    
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    print("picker cancel.")
    picker.dismiss(animated: true, completion: nil)
  }

}

extension ProfileInformationVC: UITextFieldDelegate {
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
    if textField == nameTF {
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
