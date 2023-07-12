//
//  VCPersonalityType.swift
//  FiFoMatch
//
//  Created by Aryan Tak on 26/02/22.
//

import UIKit

class VCPersonalityType: UIViewController {
  
  @IBOutlet weak var lblSurveyCompleted: UILabel!
  @IBOutlet weak var lblSurveyStep: UILabel!
  @IBOutlet weak var roundedView: UIView!
  
  @IBOutlet weak var btnExtrovert: UIButton!
  @IBOutlet weak var btnIntrovert: UIButton!
  
  var personalityType = ""
  var surveyData: SurveyDetailData?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationController?.setNavigationBarHidden(true, animated: false)
    
    if let surveyData = surveyData {
      let personalityType = surveyData.personalityTypes ?? "Extrovert"
        
      if personalityType == "Introvert" {
        selectIntrovert()
      }else {
        selectExtrovert()
      }
      
    }else {
      selectExtrovert()
    }
    
  }
  
  override func viewDidLayoutSubviews() {
    self.roundedView.roundCorners(corners: [.topLeft, .topRight], radius: 40)
  }
  
  func selectExtrovert() {
    personalityType = "Extrovert"
    btnExtrovert.layer.borderColor = CustomColor.themeOrangecolor.cgColor
    btnIntrovert.layer.borderColor = CustomColor.themeLightGray.cgColor
    
    btnExtrovert.setTitleColor(CustomColor.themeOrangecolor, for: .normal)
    btnIntrovert.setTitleColor(CustomColor.themeLightGray, for: .normal)
  }
  
  func selectIntrovert() {
    personalityType = "Introvert"
    btnExtrovert.layer.borderColor = CustomColor.themeLightGray.cgColor
    btnIntrovert.layer.borderColor = CustomColor.themeOrangecolor.cgColor
    
    btnExtrovert.setTitleColor(CustomColor.themeLightGray, for: .normal)
    btnIntrovert.setTitleColor(CustomColor.themeOrangecolor, for: .normal)
  }
  
  @IBAction func btnExtrovertIntrovert(_ sender: UIButton) {
    
    if sender.tag == 1 {
      selectExtrovert()
    }else if sender.tag == 2 {
      selectIntrovert()
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
      "step" : 7,
      "personality_types" : personalityType
      
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
      UserDefault.shared.saveSurveyStatus(status: 7)
      
      if self.surveyData != nil {
        appDelegate.setHomeView(selectTab: 4)
      }else {
        appDelegate.setHomeView()
      }
      
      
    }
  }
  
}
