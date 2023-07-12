//
//  VCTopQualities.swift
//  FiFoMatch
//
//  Created by Diwakar Tak on 25/02/22.
//

import UIKit

class VCTopQualities: UIViewController {
  
  
  @IBOutlet weak var lblSurveyCompleted: UILabel!
  @IBOutlet weak var lblSurveyStep: UILabel!
  @IBOutlet weak var roundedView: UIView!
  
  @IBOutlet weak var collectionViewTopQualities: UICollectionView!
  var qualitiesArr = ["Smart","Cute/Dear","Honest/ Loyal","Careerist","Sense of humor","Energy","Supportive/ Helpful","Spontaneous"]
  
  var selectedqualitiesArr = [String]()
  var surveyData: SurveyDetailData?
  var fromEdit = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationController?.setNavigationBarHidden(true, animated: false)
    
    let collectionLayout = UICollectionViewFlowLayout()
    collectionLayout.itemSize = CGSize(width: self.collectionViewTopQualities.bounds.width/2 - 20, height: 48)
    collectionLayout.minimumInteritemSpacing = 20
    collectionLayout.minimumInteritemSpacing = 0
    collectionLayout.scrollDirection = .vertical
    collectionViewTopQualities.collectionViewLayout = collectionLayout
    
    collectionViewTopQualities.delegate = self
    collectionViewTopQualities.dataSource = self
    
    if let surveyData = surveyData {
      let myQualities = surveyData.myQualities ?? ""
      if myQualities != "" {
        let qualitiesArray = myQualities.components(separatedBy: ", ")
        selectedqualitiesArr.append(contentsOf: qualitiesArray)
      }
      
      collectionViewTopQualities.reloadData()
    }
    
  }
  override func viewDidLayoutSubviews() {
    self.roundedView.roundCorners(corners: [.topLeft, .topRight], radius: 40)
  }
  
  @IBAction func btnPreviousAndNext(_ sender: UIButton) {
    if sender.tag == 1 {
      self.navigationController?.popViewController(animated: true)
    }else if sender.tag == 2 {
    
      if selectedqualitiesArr.count >= 1 {
        updateInfo()
      }else {
        Common.showAlert(alertMessage: "Choose 1 to 4 given qualities that best describe you", alertButtons: ["Ok"]) { (bt) in
        }
      }
    }
    
  }
  
  func updateInfo() {
    
    let qualities = selectedqualitiesArr.joined(separator: ", ")
    
    let params: [String: Any] = [
      "step" : 5,
      "my_qualities" : qualities
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
      
      self.openViewController(controller: VCQualitiesAppreciate.self, storyBoard: .Survey) { (vc) in
        vc.surveyData = self.surveyData
        vc.fromEdit = self.fromEdit
      }
      
    }
  }
  
}
extension VCTopQualities: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return qualitiesArr.count
    
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell_TopQualities", for: indexPath) as! Cell_TopQualities
    
    if selectedqualitiesArr.contains(where: {$0 == qualitiesArr[indexPath.row]}) {
  
      cell.btnTopQualities.setTitleColor(CustomColor.themeOrangecolor, for: .normal)
      cell.btnTopQualities.layer.borderColor = CustomColor.themeOrangecolor.cgColor
    }else {
      cell.btnTopQualities.setTitleColor(CustomColor.themeLightGray, for: .normal)
      cell.btnTopQualities.layer.borderColor = CustomColor.themeLightGray.cgColor
    }
    

    cell.btnTopQualities.tag = indexPath.row
    cell.btnTopQualities.addTarget(self, action: #selector(cellBtnAction), for: .touchUpInside)
    cell.btnTopQualities.setTitle(qualitiesArr[indexPath.row], for: .normal)
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    return .init(width: collectionView.frame.width/2 - 5, height: 48)
  }
  
  
  @objc func cellBtnAction(sender : UIButton){
    
    let index = sender.tag
    
    if let row = selectedqualitiesArr.firstIndex(where: {$0 == qualitiesArr[index]}) {
      selectedqualitiesArr.remove(at: row)
    }else {
      if selectedqualitiesArr.count < 4 {
        selectedqualitiesArr.append(qualitiesArr[index])
      }else {
        Common.showAlert(alertMessage: "You can select maximum 4 qualities", alertButtons: ["Ok"]) { (bt) in
        }
      }
    }
  
    let indexPath = IndexPath(item: index, section: 0)
    collectionViewTopQualities.reloadItems(at: [indexPath])
  }
  
  
  
}
class Cell_TopQualities: UICollectionViewCell {
  @IBOutlet weak var btnTopQualities: UIButton!
}
