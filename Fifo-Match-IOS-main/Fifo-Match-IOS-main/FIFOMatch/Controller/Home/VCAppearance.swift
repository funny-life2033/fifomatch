//
//  VCAppearance.swift
//  FIFOMatch
//
//  Created by octal-mac206 on 04/03/22.
//

import UIKit

class VCAppearance: UIViewController {
  
  @IBOutlet weak var lblOccupation: UILabel!
  @IBOutlet weak var lblEducation: UILabel!
  @IBOutlet weak var lblBodyType: UILabel!
  @IBOutlet weak var lblSwing: UILabel!
  @IBOutlet weak var lblRelationshipStatus: UILabel!
  @IBOutlet weak var lblFiFo: UILabel!
  @IBOutlet weak var lblHeight: UILabel!
  @IBOutlet weak var lblEthnicity: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationController?.navigationBar.isHidden = true
    
    getApperanceData()
  }
  
  @IBAction func btnBack(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
  }
  
  
  @IBAction func btnEdit(_ sender: Any) {
    
  }
  
  func getApperanceData() {
    
    AppManager().startActivityIndicator(sender: self.view)
    
    ApperanceViewModel.shared.getApperanceData { response, isSuccess, message in
      
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
        self.setupData(data: data)
      }
      
    }
  }
  
  func setupData(data: ApperanceData) {
    
    if let survey = data.questionnaire {
      
      lblBodyType.text = survey.bodyType ?? "-"
      
      let heightValue = survey.height ?? "-"
      let heightType = survey.heightType ?? "cm"
      
      lblHeight.text = "\(heightValue) \(heightType)"
    }
    
    lblFiFo.text = data.workingFIFO ?? "-"
    lblSwing.text = data.swing ?? "-"
    lblOccupation.text = data.occupation?.name ?? "-"
    lblEducation.text = data.education?.name ?? "-"
    lblRelationshipStatus.text = data.relationshipData?.name ?? "-"
    lblEthnicity.text = data.countryName ?? "-"
  }
  
}
