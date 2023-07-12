//
//  VCSeeking.swift
//  FiFoMatch
//
//  Created by diwakar Tak on 25/02/22.
//

import UIKit

class VCSeeking: UIViewController {
  
  @IBOutlet weak var lblSurveyCompleted: UILabel!
  @IBOutlet weak var lblSurveyStep: UILabel!
  @IBOutlet weak var roundedView: UIView!
  
  @IBOutlet weak var btnDating: UIButton!
  @IBOutlet weak var btnRelationship: UIButton!
  
  @IBOutlet weak var btnFriends: UIButton!
  @IBOutlet weak var btnFriendsWithBenefits: UIButton!
  
  var answer = ""
  var surveyData: SurveyDetailData?
  var fromEdit = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationController?.setNavigationBarHidden(true, animated: false)
    
    if let surveyData = surveyData {
      
      switch surveyData.seeking ?? "" {case SeekingTypes.dating.rawValue:
        btnDatingSelect()
      case SeekingTypes.dating.rawValue:
        btnDatingSelect()
      case SeekingTypes.relationship.rawValue:
        btnRelationshipSelect()
      case SeekingTypes.friends.rawValue:
        btnFriendsSelect()
      case SeekingTypes.friendsBenefits.rawValue:
        btnFriendsBenefitsSelect()
      default:
        btnDatingSelect()
      }
    
    }else {
      btnDatingSelect()
    }
    
    
  }
  override func viewDidLayoutSubviews() {
    self.roundedView.roundCorners(corners: [.topLeft, .topRight], radius: 40)
  }
  
  func btnDatingSelect() {
    answer = SeekingTypes.dating.rawValue
    btnDating.layer.borderColor = CustomColor.themeOrangecolor.cgColor
    btnRelationship.layer.borderColor = CustomColor.themeLightGray.cgColor
    btnFriends.layer.borderColor = CustomColor.themeLightGray.cgColor
    btnFriendsWithBenefits.layer.borderColor = CustomColor.themeLightGray.cgColor
    
    btnDating.setTitleColor(CustomColor.themeOrangecolor, for: .normal)
    btnRelationship.setTitleColor(CustomColor.themeLightGray, for: .normal)
    btnFriends.setTitleColor(CustomColor.themeLightGray, for: .normal)
    btnFriendsWithBenefits.setTitleColor(CustomColor.themeLightGray, for: .normal)
  }
  
  func btnRelationshipSelect() {
    answer = SeekingTypes.relationship.rawValue
    btnDating.layer.borderColor = CustomColor.themeLightGray.cgColor
    btnRelationship.layer.borderColor = CustomColor.themeOrangecolor.cgColor
    btnFriends.layer.borderColor = CustomColor.themeLightGray.cgColor
    btnFriendsWithBenefits.layer.borderColor = CustomColor.themeLightGray.cgColor
    
    btnDating.setTitleColor(CustomColor.themeLightGray, for: .normal)
    btnRelationship.setTitleColor(CustomColor.themeOrangecolor, for: .normal)
    btnFriends.setTitleColor(CustomColor.themeLightGray, for: .normal)
    btnFriendsWithBenefits.setTitleColor(CustomColor.themeLightGray, for: .normal)
  }
  
  func btnFriendsSelect() {
    answer = SeekingTypes.friends.rawValue
    btnDating.layer.borderColor = CustomColor.themeLightGray.cgColor
    btnRelationship.layer.borderColor = CustomColor.themeLightGray.cgColor
    btnFriends.layer.borderColor = CustomColor.themeOrangecolor.cgColor
    btnFriendsWithBenefits.layer.borderColor = CustomColor.themeLightGray.cgColor
    
    btnDating.setTitleColor(CustomColor.themeLightGray, for: .normal)
    btnRelationship.setTitleColor(CustomColor.themeLightGray, for: .normal)
    btnFriends.setTitleColor(CustomColor.themeOrangecolor, for: .normal)
    btnFriendsWithBenefits.setTitleColor(CustomColor.themeLightGray, for: .normal)
  }
  
  func btnFriendsBenefitsSelect() {
    answer = SeekingTypes.friendsBenefits.rawValue
    btnDating.layer.borderColor = CustomColor.themeLightGray.cgColor
    btnRelationship.layer.borderColor = CustomColor.themeLightGray.cgColor
    btnFriends.layer.borderColor = CustomColor.themeLightGray.cgColor
    btnFriendsWithBenefits.layer.borderColor = CustomColor.themeOrangecolor.cgColor
    
    btnDating.setTitleColor(CustomColor.themeLightGray, for: .normal)
    btnRelationship.setTitleColor(CustomColor.themeLightGray, for: .normal)
    btnFriends.setTitleColor(CustomColor.themeLightGray, for: .normal)
    btnFriendsWithBenefits.setTitleColor(CustomColor.themeOrangecolor, for: .normal)
  }
  
  @IBAction func btnSeekingFor(_ sender: UIButton) {
    
    if sender.tag == 1 {
      btnDatingSelect()
    }
    else if sender.tag == 2 {
      btnRelationshipSelect()
    }
    else if sender.tag == 3 {
      btnFriendsSelect()
    }
    else if sender.tag == 4 {
      btnFriendsBenefitsSelect()
    }
    
  }
  

  @IBAction func btnPreviousAndNext(_ sender: UIButton) {
    if sender.tag == 1 {
      self.navigationController?.popViewController(animated: true)
    }else if sender.tag == 2 {
      updateInfo()
    }
    
  }
  
  func updateInfo() {
    
    let params: [String: Any] = [
      "step" : 4,
      "seeking" : answer
    ]
    
    AppManager().startActivityIndicator(sender: self.view)
    
    SurveyViewModel.shared.updateSurveyData(parameters: params) { response, isSuccess, message in
      
      AppManager().stopActivityIndicator(self.view)
      
      guard let response = response, isSuccess else {
        Common.showAlert(alertMessage: message ?? "Something went wrong", alertButtons: ["Ok"]) { (bt) in
        }
        return
      }
      
      guard self.checkStatus(status: response.status, message: response.message) else {
        return
      }
      
      if self.fromEdit {
        NotificationCenter.default.post(name: .updateSurvey, object: nil)
      }
      
      self.openViewController(controller: VCTopQualities.self, storyBoard: .Survey) { (vc) in
        vc.surveyData = self.surveyData
        vc.fromEdit = self.fromEdit
      }
      
    }
  }
  
  enum SeekingTypes: String {
    case dating = "Dating"
    case relationship = "Relationship"
    case friends = "Friends"
    case friendsBenefits = "Friends with benefits"
  }
  
}
