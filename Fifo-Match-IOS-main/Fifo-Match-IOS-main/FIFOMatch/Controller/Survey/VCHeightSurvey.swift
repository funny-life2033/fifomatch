//
//  VCHeightSurvey.swift
//  FiFoMatch
//
//  Created by Aryan Tak on 25/02/22.
//

import UIKit
import Alamofire

class VCHeightSurvey: UIViewController {
  
  @IBOutlet weak var heightSlider: UISlider!
  @IBOutlet weak var inchCmSwitchBtn: UISwitch!
  @IBOutlet weak var roundedView: UIView!
  @IBOutlet weak var heightValueLbl: UILabel!
  
  var surveyData: SurveyDetailData?
  var fromEdit = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationController?.setNavigationBarHidden(true, animated: false)
    
    if let surveyData = surveyData {
      
      heightValueLbl.text = surveyData.height
      
      if surveyData.heightType == "cm" {
        let cmValue = Float(surveyData.height ?? "") ?? 152
        heightSlider.value = cmValue.rounded()
        inchCmSwitchBtn.isOn = false
      }else {
        let cmValue = (Float(surveyData.height ?? "") ?? 60) * 2.54
        heightSlider.value = cmValue.rounded()
        inchCmSwitchBtn.isOn = true
      }
    }else {
      heightSlider.value = 152
      heightValueLbl.text = "60"
    }
    
    
  }
  
  override func viewDidLayoutSubviews() {
    self.roundedView.roundCorners(corners: [.topLeft, .topRight], radius: 40)
  }
  
  @IBAction func btnBack(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
  }
  
  @IBAction func btnNext(_ sender: Any) {
    updateInfo()
  }
  
  @IBAction func hightSliderAction(_ sender: UISlider) {
    
    if inchCmSwitchBtn.isOn {
      let inchs = sender.value * 0.39370
      heightValueLbl.text = "\(inchs.rounded())"
    }else {
      heightValueLbl.text = "\(sender.value.rounded())"
    }
    
  }
  
  @IBAction func inchCmSwitchBtnAction(_ sender: UISwitch) {
    
    if sender.isOn {
      let inches = heightSlider.value * 0.39370
      heightValueLbl.text = "\(inches.rounded())"
    }else {
      heightValueLbl.text = "\(heightSlider.value.rounded())"
    }
  }
  
//  func showFootAndInchesFromCm(_ cms: Double) -> String {
//
//    let feet = cms * 0.0328084
//    let feetShow = Int(floor(feet))
//    let feetRest: Double = ((feet * 100).truncatingRemainder(dividingBy: 100) / 100)
//    let inches = Int(floor(feetRest * 12))
//
//    return "\(feetShow)' \(inches)\""
//  }
  
  
  func updateInfo() {
    
    let params: [String: Any] = [
      "step" : 1,
      "height_type" : inchCmSwitchBtn.isOn ? "inches" : "cm",
      "height" : heightValueLbl.text ?? ""
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
      
      self.openViewController(controller: VCBodyTypeSurvey.self, storyBoard: .Survey) { (vc) in
        vc.surveyData = self.surveyData
        vc.fromEdit = self.fromEdit
      }
      
    }
  }
  
}
