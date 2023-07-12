//
//  VCBodyTypeSurvey.swift
//  FiFoMatch
//
//  Created by Diwakar Tak on 25/02/22.
//

import UIKit

class VCBodyTypeSurvey: UIViewController {
  
  @IBOutlet weak var tableViewBodyType: UITableView!
  @IBOutlet weak var lblSurveyCompleted: UILabel!
  @IBOutlet weak var lblSurveyStep: UILabel!
  
  @IBOutlet weak var roundedView: UIView!
  
  var dataArr = ["Slim", "Athletic", "A few pounds"]
  
  var selectedIndex = 0
  var surveyData: SurveyDetailData?
  var fromEdit = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.navigationController?.setNavigationBarHidden(true, animated: false)
    
    tableViewBodyType.delegate = self
    tableViewBodyType.dataSource = self
    
    if let surveyData = surveyData {
      let bodyType = surveyData.bodyType ?? "Slim"
      if let row = dataArr.firstIndex(where: {$0 == bodyType}) {
        selectedIndex = row
      }
    }
    
  }
  
  override func viewDidLayoutSubviews() {
    self.roundedView.roundCorners(corners: [.topLeft, .topRight], radius: 40)
  }
  
  @IBAction func btnPreviousAndNext(_ sender: UIButton) {
    if sender.tag == 1 {
      self.navigationController?.popViewController(animated: true)
    }else if sender.tag == 2 {
      
      updateInfo()
    }
    
  }
  
  func updateInfo() {
    
    let bodyType = dataArr[selectedIndex]
    
    let params: [String: Any] = [
      "step" : 2,
      "body_type" : bodyType
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
      
      self.openViewController(controller: VCKidsSurvey.self, storyBoard: .Survey) { (vc) in
        vc.surveyData = self.surveyData
        vc.fromEdit = self.fromEdit
      }
      
    }
  }
  
  
}
extension VCBodyTypeSurvey :UITableViewDelegate,UITableViewDataSource{
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataArr.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cellBodyType") as! cellBodyType
    if selectedIndex == indexPath.row
    {
      cell.imgSelection.image = UIImage(named: "RectangleSelect")
    }else{
      cell.imgSelection.image = UIImage(named: "RectangleUnselect")
    }
    cell.lblTITLE.text = dataArr[indexPath.row]
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    selectedIndex = indexPath.row
    tableView.reloadData()
  }
}


class cellBodyType : UITableViewCell{
  
  @IBOutlet weak var lblTITLE: UILabel!
  @IBOutlet weak var imgSelection: UIImageView!
}
