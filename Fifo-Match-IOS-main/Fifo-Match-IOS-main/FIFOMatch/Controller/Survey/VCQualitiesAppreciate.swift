//
//  VCQualitiesAppreciate.swift
//  FiFoMatch
//
//  Created by Aryan Tak on 25/02/22.
//

import UIKit

class VCQualitiesAppreciate: UIViewController {
  
  
  @IBOutlet weak var lblSurveyCompleted: UILabel!
  @IBOutlet weak var lblSurveyStep: UILabel!
  @IBOutlet weak var roundedView: UIView!
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var collectionViewTopQualities: UICollectionView!
  
  var qualitiesArr = ["You are his/her priority","Laugh Together","Supports/Takes care of you","Meaningful conversation","Full of surprises/ Fascinates you","Honest/ Loyal","Cute/ Dear","Quality Sex"]
  
  var selectedqualitiesArr = [String]()
  var surveyData: SurveyDetailData?
  var fromEdit = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationController?.setNavigationBarHidden(true, animated: false)
    
    tableView.sectionHeaderHeight = UITableView.automaticDimension
    tableView.estimatedSectionHeaderHeight = 64
    
    let collectionLayout = UICollectionViewFlowLayout()
    collectionLayout.itemSize = CGSize(width: self.collectionViewTopQualities.bounds.width - 20, height: 48)
    collectionLayout.minimumInteritemSpacing = 20
    collectionLayout.minimumInteritemSpacing = 0
    collectionLayout.scrollDirection = .vertical
    collectionViewTopQualities.collectionViewLayout = collectionLayout
    collectionViewTopQualities.delegate = self
    collectionViewTopQualities.dataSource = self
    
    //collectionViewTopQualities.contentInset = .init(top: 0, left: 0, bottom: 40, right: 0)
    
    if let surveyData = surveyData {
      let qualitiesAppreciate = surveyData.qualitiesAppreciate ?? ""
      
      if qualitiesAppreciate != "" {
        let qualitiesArray = qualitiesAppreciate.components(separatedBy: ", ")
        
        selectedqualitiesArr.append(contentsOf: qualitiesArray)
      }
      
      collectionViewTopQualities.reloadData()
    }
    
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    self.roundedView.roundCorners(corners: [.topLeft, .topRight], radius: 40)
    
//    guard let headerView = tableView.tableHeaderView else {
//      return
//    }
//    let size = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
//    if headerView.frame.height != size.height {
//      tableView.tableHeaderView?.frame = CGRect(
//        origin: headerView.frame.origin,
//        size: size
//      )
//      tableView.layoutIfNeeded()
//    }
  }
  
  @IBAction func btnPreviousAndNext(_ sender: UIButton) {
    if sender.tag == 1 {
      self.navigationController?.popViewController(animated: true)
    }else if sender.tag == 2 {
      
      if selectedqualitiesArr.count == 4 {
        updateInfo()
      }else {
        Common.showAlert(alertMessage: "Choose 4 out of 8 given qualities that you most appreciate in other person.", alertButtons: ["Ok"]) { (bt) in
        }
      }
      
    }
  }
  
  func updateInfo() {
    
    let qualities = selectedqualitiesArr.joined(separator: ", ")
    
    let params: [String: Any] = [
      "step" : 6,
      "qualities_appreciate" : qualities
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
      
      self.openViewController(controller: VCPersonalityType.self, storyBoard: .Survey) { (vc) in
        vc.surveyData = self.surveyData
      }
      
    }
  }
  
}

extension VCQualitiesAppreciate: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return qualitiesArr.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellQualitiesAppreciate", for: indexPath) as! CellQualitiesAppreciate
    
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
    
    return .init(width: collectionView.frame.width, height: 48)
  }
  
  
  @objc func cellBtnAction(sender : UIButton){
    let index = sender.tag
    
    if let row = selectedqualitiesArr.firstIndex(where: {$0 == qualitiesArr[index]}) {
      selectedqualitiesArr.remove(at: row)
    }else {
      
      if selectedqualitiesArr.count < 4 {
        selectedqualitiesArr.append(qualitiesArr[index])
      }else {
        Common.showAlert(alertMessage: "You can choose maximum four qualities", alertButtons: ["Ok"]) { (bt) in
        }
      }
      
    }
  
    let indexPath = IndexPath(item: index, section: 0)
    collectionViewTopQualities.reloadItems(at: [indexPath])
  }
  
  
  
}

class CellQualitiesAppreciate: UICollectionViewCell {
  @IBOutlet weak var btnTopQualities: UIButton!
}
