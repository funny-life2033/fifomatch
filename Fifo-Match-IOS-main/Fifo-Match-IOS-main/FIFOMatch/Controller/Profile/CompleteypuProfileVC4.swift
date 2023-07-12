//
//  CompleteypuProfileVC4.swift
//  FlowDating
//
//  Created by deepti on 28/01/21.
//

import UIKit
class CompleteypuProfileVC4: UIViewController {
  
  @IBOutlet weak var skipBtn: UIButton!
 
  override func viewDidLoad() {
    super.viewDidLoad()
    
    skipBtn.isHidden = true
    getUserActivePlan()
  }

  override func viewWillAppear(_ animated: Bool) {
    //  Analytics.logEvent("complete_profile_4", parameters: ["complete_profile_4":"complete_profile_4"])
    
    self.navigationController?.setNavigationBarHidden(true, animated: false)
  }
  
  @IBAction func backButttonAction(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
  }
  
  @IBAction func skipBtnAction(_ sender: UIButton) {
    
//    Analytics.logEvent("congratulations_registration", parameters: ["congratulations_registration":"congratulations_registration"])
    updateInfo()
  }
  

  @IBAction func openSurveyVcAction(_ sender: Any) {
    //      //r  Analytics.logEvent("congratulations_registration", parameters: ["congratulations_registration":"congratulations_registration"])
    openViewController(controller: VCHeightSurvey.self, storyBoard: .Survey) { (vc) in
      //            vc.isComingFromRegistration = true
    }
  }
  
  func updateInfo() {
    
    let params: [String: Any] = [
      "step" : 7,
      "personality_types" : "7"
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
      appDelegate.setHomeView()
      
    }
  }
  
  func getUserActivePlan() {
    
    HomeViewModel.shared.getUserActivePlan { response, isSuccess, message in
      
      guard let response = response, isSuccess else {
        
        Common.showAlert(alertMessage: message ?? "Somthing went wrong", alertButtons: ["Ok"]) { (bt) in }
        return
      }
      
      guard self.checkStatus(status: response.status, message: response.message) else {
        return
      }
      
      if let plan = response.data?.plan_id {
        var currentPlan = ""
       
        if plan == "plan_id_02" {
          currentPlan = "premium"
        }else if plan == "plan_id_01" {
          currentPlan = "standard"
        }
        
        if currentPlan == "premium" {
          self.skipBtn.isHidden = false
        }else {
          self.skipBtn.isHidden = true
        }
        
      }else {
        self.skipBtn.isHidden = true
      }
  
      
    }
  }
  
}
