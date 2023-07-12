//
//  VCViewEditSurvey.swift
//  FIFOMatch
//
//  Created by octal-mac206 on 04/03/22.
//

import UIKit

class VCViewEditSurvey: UIViewController {
  
  
  @IBOutlet weak var notAvailableView: UIView!
  @IBOutlet weak var tableViewSurvey: UITableView!
  
  var surveyData: SurveyDetailData?
  var fillSurveyArr = [FillSurveyModel]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableViewSurvey.delegate = self
    tableViewSurvey.dataSource = self
    tableViewSurvey.contentInset = .init(top: 5, left: 0, bottom: 40, right: 0)
    getSurveyData()
    addObserver()
  }
  
  @IBAction func btnBAck(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
  }
  
  @IBAction func btnSurvey(_ sender: Any) {
    openViewController(controller: VCHeightSurvey.self, storyBoard: .Survey) { (vc) in
      vc.surveyData = self.surveyData
      vc.fromEdit = true
    }
    
  }
  
  deinit {
      debugPrint("deinit call")
      NotificationCenter.default.removeObserver(self)
  }
  
  func getSurveyData() {
    
    AppManager().startActivityIndicator(sender: self.view)
    
    SurveyViewModel.shared.getSurveyData { response, isSuccess, message in
      
      AppManager().stopActivityIndicator(self.view)
      
      guard let response = response, isSuccess else {
        Common.showAlert(alertMessage: message ?? "Something went wrong", alertButtons: ["Ok"]) { (bt) in
        }
        return
      }
      
      self.surveyData = response
      
      self.fillSurveyArr.removeAll()
      
      if let heightValue = response.height, heightValue != "0" {
        let heightType = response.heightType ?? ""
        let height = ["\(heightValue) \(heightType)"]
        self.fillSurveyArr.append(.init(name: "What is your height?", info: height))
      }
       
      if let bodyType = response.bodyType, bodyType != "" {
        self.fillSurveyArr.append(.init(name: "What is your body type?", info: [bodyType]))
      }

      if let seeking = response.seeking, seeking != "" {
        self.fillSurveyArr.append(.init(name: "What are you seeking?", info: [seeking]))
      }
        
      if let kids = response.kids, kids != "" {
        self.fillSurveyArr.append(.init(name: "Do you have kids?", info: [kids]))
      }
      
      if let kidsInFuture = response.kidsInFuture, kidsInFuture != "" {
        self.fillSurveyArr.append(.init(name: "Do you want kids in the future?", info: [kidsInFuture]))
      }

      if let myQualities = response.myQualities, myQualities != "" {
        let qualitiesArray = myQualities.components(separatedBy: ",")
        self.fillSurveyArr.append(.init(name: "Choose your top qualities?", info: qualitiesArray))
      }
      
      if let qualitiesAppreciate = response.qualitiesAppreciate, qualitiesAppreciate != "" {
        let qualitiesAppreciateArray = qualitiesAppreciate.components(separatedBy: ",")
        self.fillSurveyArr.append(.init(name: "Choose qualities that you most appreciate?", info: qualitiesAppreciateArray))
      }


      if let personalityTypes = response.personalityTypes, personalityTypes != "" {
        self.fillSurveyArr.append(.init(name: "Which of personality types are you more like?", info: [personalityTypes]))
      }
      
      if self.fillSurveyArr.isEmpty {
        self.notAvailableView.isHidden = false
      }else {
        self.notAvailableView.isHidden = true
        self.tableViewSurvey.reloadData()
      }
      
    }
    
  }
  
}
extension VCViewEditSurvey : UITableViewDelegate,UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return fillSurveyArr.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
   
    let cell = tableView.dequeueReusableCell(withIdentifier: "CellTable") as! CellTable
    
    guard fillSurveyArr.count > indexPath.row else { return cell }
    
    let survey = fillSurveyArr[indexPath.row]
    
    cell.lblTitle.text = survey.name
    cell.setSurveyInfo(data: survey.info)
   
    //cell.collectionViewHeight.constant = cell.collectionViewSurveyType.collectionViewLayout.collectionViewContentSize.height
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 98
  }
}

//MARK:- Update Survey Notifier
extension VCViewEditSurvey {
  
  func addObserver() {
    NotificationCenter.default.addObserver(self, selector: #selector(onDidReceiveData(_:)), name: .updateSurvey, object: nil)
  }
  
  @objc func onDidReceiveData(_ notification: Notification) {
    getSurveyData()
  }
}

class CellTable : UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
  @IBOutlet weak var collectionViewSurveyType: UICollectionView!
  @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
  
  @IBOutlet weak var lblTitle: UILabel!
  
  var surveyData = [String]()
  
  override  func awakeFromNib() {
    super.awakeFromNib()
    
    collectionViewSurveyType.dataSource = self
    collectionViewSurveyType.delegate = self
    
    let collectionLayout = UICollectionViewFlowLayout()
    collectionLayout.minimumInteritemSpacing = 10
    collectionLayout.scrollDirection = .horizontal
    collectionViewSurveyType.collectionViewLayout = collectionLayout
  }
  
  func setSurveyInfo(data: [String]){
    surveyData = data
    collectionViewSurveyType.reloadData()
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return surveyData.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellCollection", for: indexPath) as! CellCollection
    cell.lblTitle.text = surveyData[indexPath.item]
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

      let item = self.surveyData[indexPath.item]
      let itemSize = sizeAccordingDevice(item: item)
      return CGSize(width: itemSize.width + 35, height: collectionView.frame.size.height)
  }
  
  
  func sizeAccordingDevice(item: String) -> CGSize {
      
      var size: CGSize = .init()
      
      if let font = UIFont(name: "SFProText-Light", size: 16.0) {
          let fontAttributes = [NSAttributedString.Key.font: font]
          
          size = item.size(withAttributes: fontAttributes)
      }
      
      return size
      
  }
  
}

class CellCollection: UICollectionViewCell {
  
  @IBOutlet weak var viewBackground: UIView!
  @IBOutlet weak var lblTitle: UILabel!
  
  override  func awakeFromNib() {
    super.awakeFromNib()
  }
  
  
  
}
