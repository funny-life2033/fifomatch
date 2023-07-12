//
//  VCKidsSurvey.swift
//  FiFoMatch
//
//  Created by Diwakar Tak on 25/02/22.
//

import UIKit

class VCKidsSurvey: UIViewController {
  
  @IBOutlet weak var lblSurveyCompleted: UILabel!
  @IBOutlet weak var lblSurveyStep: UILabel!
  @IBOutlet weak var roundedView: UIView!
  
  @IBOutlet weak var btnKidsYes: UIButton!
  @IBOutlet weak var btnKidsNo: UIButton!
  
  @IBOutlet weak var btnKidsFutureYes: UIButton!
  @IBOutlet weak var btnKidsFutureNo: UIButton!
  @IBOutlet weak var btnKidsYesNearFuture: UIButton!
  
  var kids = "No"
  var futureKids = "Yes"
  var surveyData: SurveyDetailData?
  var fromEdit = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationController?.setNavigationBarHidden(true, animated: false)
    
    if let surveyData = surveyData {
      let kids = surveyData.kids ?? "No"
      let kidsInFuture = surveyData.kidsInFuture ?? "Yes"
      
      if kids == "Yes" {
        kidsYes()
      }else {
        kidsNo()
      }
      
      if kidsInFuture == "Yes" {
        futureKidsYes()
      }else if kidsInFuture == "No" {
        futureKidsYes()
      }else {
        futureKidsYesBut()
      }
      
    }else {
      kidsNo()
      futureKidsYes()
    }
    
  }
  
  override func viewDidLayoutSubviews() {
    self.roundedView.roundCorners(corners: [.topLeft, .topRight], radius: 40)
  }
  
  @IBAction func btnKidsYesNO(_ sender: UIButton) {
    
    if sender.tag == 1 {
      kidsYes()
    }
    else if sender.tag == 2 {
      kidsNo()
    }
  }
  
  func kidsYes() {
    kids = "Yes"
    btnKidsYes.layer.borderColor = CustomColor.themeOrangecolor.cgColor
    btnKidsNo.layer.borderColor = CustomColor.themeLightGray.cgColor
    
    btnKidsYes.setTitleColor(CustomColor.themeOrangecolor, for: .normal)
    btnKidsNo.setTitleColor(CustomColor.themeLightGray, for: .normal)
  }
  
  func kidsNo() {
    kids = "No"
    btnKidsYes.layer.borderColor = CustomColor.themeLightGray.cgColor
    btnKidsNo.layer.borderColor = CustomColor.themeOrangecolor.cgColor
    
    btnKidsYes.setTitleColor(CustomColor.themeLightGray, for: .normal)
    btnKidsNo.setTitleColor(CustomColor.themeOrangecolor, for: .normal)
  }
  
  func futureKidsYes() {
    futureKids = "Yes"
    btnKidsFutureYes.layer.borderColor = CustomColor.themeOrangecolor.cgColor
    btnKidsFutureNo.layer.borderColor = CustomColor.themeLightGray.cgColor
    btnKidsYesNearFuture.layer.borderColor = CustomColor.themeLightGray.cgColor
    
    btnKidsFutureYes.setTitleColor(CustomColor.themeOrangecolor, for: .normal)
    btnKidsFutureNo.setTitleColor(CustomColor.themeLightGray, for: .normal)
    btnKidsYesNearFuture.setTitleColor(CustomColor.themeLightGray, for: .normal)
  }
  
  func futureKidsNo() {
    futureKids = "No"
    btnKidsFutureYes.layer.borderColor = CustomColor.themeLightGray.cgColor
    btnKidsFutureNo.layer.borderColor = CustomColor.themeOrangecolor.cgColor
    btnKidsYesNearFuture.layer.borderColor = CustomColor.themeLightGray.cgColor
    
    btnKidsFutureYes.setTitleColor(CustomColor.themeLightGray, for: .normal)
    btnKidsFutureNo.setTitleColor(CustomColor.themeOrangecolor, for: .normal)
    btnKidsYesNearFuture.setTitleColor(CustomColor.themeLightGray, for: .normal)
  }
  
  func futureKidsYesBut() {
    futureKids = "Yes, but not in the near future"
    btnKidsFutureYes.layer.borderColor = CustomColor.themeLightGray.cgColor
    btnKidsFutureNo.layer.borderColor = CustomColor.themeLightGray.cgColor
    btnKidsYesNearFuture.layer.borderColor = CustomColor.themeOrangecolor.cgColor
    
    btnKidsFutureYes.setTitleColor(CustomColor.themeLightGray, for: .normal)
    btnKidsFutureNo.setTitleColor(CustomColor.themeLightGray, for: .normal)
    btnKidsYesNearFuture.setTitleColor(CustomColor.themeOrangecolor, for: .normal)
  }
  
  @IBAction func btnKidsFutureYesNO(_ sender: UIButton) {
    
    if sender.tag == 1 {
      futureKidsYes()
      
    }else if sender.tag == 2 {
      futureKidsNo()
      
    }else if sender.tag == 3 {
      futureKidsYesBut()
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
      "step" : 3,
      "kids" : kids,
      "kids_in_future" : futureKids,
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
      
      self.openViewController(controller: VCSeeking.self, storyBoard: .Survey) { (vc) in
        vc.surveyData = self.surveyData
        vc.fromEdit = self.fromEdit
      }
      
    }
  }
  
}
