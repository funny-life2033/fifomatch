//
//  VCUserProfile.swift
//  FiFoMatch
//
//  Created by Aryan Tak on 28/02/22.
//

import UIKit
import Kingfisher
import ImageSlideshow

class VCUserProfile: UIViewController {
  
  @IBOutlet weak var backBtn: UIButton!
  @IBOutlet weak var imageSlider: ImageSlideshow!
  @IBOutlet weak var pageIndicator: UIPageControl!
  @IBOutlet weak var imgUser: UIImageView!
  @IBOutlet weak var tableViewUserProfile: UITableView!
  @IBOutlet weak var rounderView: UIView!
  @IBOutlet weak var lblUserName: UILabel!
  @IBOutlet weak var lblUserAddress: UILabel!
  @IBOutlet weak var lblAboutMe: UILabel!
  @IBOutlet weak var subscriptionTypeBtn: UIButton!
  @IBOutlet weak var btnReadMore: UIButton!
  @IBOutlet weak var cancelBtn: UIButton!
  @IBOutlet weak var likeBtn: UIButton!
  @IBOutlet weak var savedBtn: UIButton!
  @IBOutlet weak var verifyImg: UIImageView!
  
  @IBOutlet weak var blockSwitchBtn: UISwitch!
  @IBOutlet weak var btnInfo: UIButton!
  @IBOutlet weak var btnPhoto: UIButton!
  @IBOutlet weak var btnSurvey: UIButton!
  
  @IBOutlet weak var viewInfo: UIView!
  @IBOutlet weak var viewPhot: UIView!
  @IBOutlet weak var viewSurvey: UIView!
  
  var userId = ""
  var about = false
  var type = "Info"
  
  var userDetails: UserDetails?
  var userSurveyInfo = [UserSurveyInfo]()
  var currentPlan = ""
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.rounderView.cornerRadius = 40
    self.navigationController?.setNavigationBarHidden(true, animated: false)
    tableViewUserProfile.delegate = self
    tableViewUserProfile.dataSource = self
    
    getUserActivePlan()
    getUserDetails()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    guard let headerView = tableViewUserProfile.tableHeaderView else {
      return
    }
    let size = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    if headerView.frame.height != size.height {
      tableViewUserProfile.tableHeaderView?.frame = CGRect(
        origin: headerView.frame.origin,
        size: size
      )
      tableViewUserProfile.layoutIfNeeded()
    }
  }
  
  func setView(type:String, reload: Bool = true){
    if type == "Survey"{
      viewInfo.backgroundColor = .white
      viewPhot.backgroundColor = .white
      viewSurvey.backgroundColor = CustomColor.themeOrangecolor
    }else if type == "Photo"{
      viewInfo.backgroundColor = .white
      viewPhot.backgroundColor = CustomColor.themeOrangecolor
      viewSurvey.backgroundColor = .white
    }else{
      viewInfo.backgroundColor = CustomColor.themeOrangecolor
      viewPhot.backgroundColor = .white
      viewSurvey.backgroundColor = .white
    }
    self.type = type
    
    if reload {
      
      DispatchQueue.main.async {
        self.tableViewUserProfile.reloadData()
        self.tableViewUserProfile.scrollToLastRow(animated: true)
      }
      
    }
    
    
  }
  
  
  
  @IBAction func btnBAck(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
  }
  @IBAction func btnReadMore(_ sender: Any) {
    //        if about{
    //            lblAboutMe.numberOfLines = 3
    //            about = false
    //        }else{
    //            lblAboutMe.numberOfLines = 0
    //            about = true
    //        }
  }
  
  @IBAction func blockSwitchBtnAction(_ sender: UISwitch) {
    
    if blockSwitchBtn.isOn {
      hideSaveCancelUser(type: "hide")
    }else {
      hideSaveCancelUser(type: "hide", apiType: "remove")
    }
    
    debugPrint("block \(sender.isOn)")
  }

  
  @IBAction func btnRemoveFavBookMark(_ sender: UIButton) {
    
    
    if sender.tag == 1 { // CANCEL
      hideSaveCancelUser(type: "cancel")
      
    }else if sender.tag == 2 { // LIKE
      
      if likeBtn.currentImage == UIImage(named: "like-active") {
        likeUser(type: "dislike")
      }else {
        likeUser(type: "like")
      }
      
    }else if sender.tag == 3 { //SAVE
      
      if savedBtn.currentImage == UIImage(named: "profile_saved") {
        hideSaveCancelUser(type: "saved", apiType: "remove")
      }else {
        hideSaveCancelUser(type: "saved")
      }
    }
  }
  
  
  @IBAction func btnInfoPhotosSurvey(_ sender: UIButton) {
    if sender.tag == 1 {
      // info
      setView(type: "Info")
    }else if sender.tag == 2 {
      // photos
      setView(type: "Photo")
      
    }else if sender.tag == 3 {
      //Survey
      setView(type: "Survey")
    }
  }
  
  
  
  @objc func connectedbtnPremMembership(sender: UIButton){
    openViewController(controller: VCUpgradeMembership.self, storyBoard: .mainStoryBoard) { (vc) in
      if UserDefault.shared.getUserGender()?.lowercased() == "woman" {
        vc.isUserFemale = true
      }
    }
  }
  
  func getUserDetails() {
    
    AppManager().startActivityIndicator(sender: self.view)
    
    HomeViewModel.shared.getUserDetail(by: userId) { response, isSuccess, message in
      
      AppManager().stopActivityIndicator(self.view)
      
      guard let response = response, isSuccess else {
        Common.showAlert(alertMessage: message ?? "", alertButtons: ["Ok"]) { (bt) in
        }
        return
      }
      
      guard self.checkStatus(status: response.status, message: response.message) else {
        return
      }
      
      
      if let userDetails = response.data?.userDetails {
        self.userDetails = userDetails
        self.setupData(userInfo: userDetails)
      }
      
      self.setView(type: "Info", reload: false)
      
      self.tableViewUserProfile.reloadData()
      
      
    }
  }
  
  func setupData(userInfo: UserDetails) {
    
    let userName = userInfo.name ?? ""
    let userAge = String(userInfo.age ?? 0)
    if userAge != "0" {
      lblUserName.text = userName + ", " + userAge
    }else {
      lblUserName.text = userName
    }
    
    
    let useCountry = userInfo.countryName ?? ""
    let distance = userInfo.miles ?? ""
    if distance != "" {
      lblUserAddress.text = useCountry + ", " + distance
    }else {
      lblUserAddress.text = useCountry
    }

    lblAboutMe.text = userInfo.about
    
    if let userBlocked = userInfo.isBlocked, userBlocked {
      blockSwitchBtn.isOn = true
    }else {
      blockSwitchBtn.isOn = false
    }
    
    if let isSaved = userInfo.isSaved, isSaved {
      savedBtn.setImage(UIImage(named: "profile_saved"), for: .normal)
    }else {
      savedBtn.setImage(UIImage(named: "save-active"), for: .normal)
    }
    
    if let isLiked = userInfo.isLike, isLiked {
      likeBtn.setImage(UIImage(named: "like-active"), for: .normal)
    }else {
      likeBtn.setImage(UIImage(named: "like-unactive"), for: .normal)
    }
    
    if let userVerified = userInfo.verify, userVerified == 2 {
      verifyImg.isHidden = false
    }else {
      verifyImg.isHidden = true
    }
    
    pageIndicator.currentPageIndicatorTintColor = UIColor.white
    pageIndicator.pageIndicatorTintColor = UIColor.lightGray
   
    
    if let userPhotos = userInfo.photos {
      
      var imageSources = [KingfisherSource]()
      
      for photo in userPhotos {
        if let userImg = photo.name  {
          if let url = URL(string: userImg) {
            imageSources.append(.init(url: url))
          }
        }
      }
      
      imageSlider.contentScaleMode = .scaleAspectFill
      pageIndicator.currentPage = 0
      
//      if currentPlan != "premium" {
//        if imageSources.count > 3 {
//
//          let filterImages = Array(imageSources[0..<3])
//          pageIndicator.numberOfPages = filterImages.count
//          imageSlider.setImageInputs(filterImages)
//        }else {
//          pageIndicator.numberOfPages = imageSources.count
//          imageSlider.setImageInputs(imageSources)
//        }
//
//      }else {
        pageIndicator.numberOfPages = imageSources.count
        imageSlider.setImageInputs(imageSources)
//      }
    
      imageSlider.currentPageChanged = { page in
        self.pageIndicator.currentPage = page
      }
      
      let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
        imageSlider.addGestureRecognizer(gestureRecognizer)
    }
    
    
    if let subscriptionInfo = userInfo.userInappTransaction {
      if subscriptionInfo.planID == "plan_id_02" {
        subscriptionTypeBtn.setImage(UIImage(named: "premium-status"), for: .normal)
      }else if subscriptionInfo.planID == "plan_id_01" {
        subscriptionTypeBtn.setImage(UIImage(named: "standard-membership"), for: .normal)
      }
    }else {
        subscriptionTypeBtn.setImage(UIImage(named: "standard-membership"), for: .normal)
    }
    
    if let surveyType = userInfo.questionnaire {
      
      if let myQualities = surveyType.myQualities, myQualities != "" {
        let qualitiesArray = myQualities.components(separatedBy: ",")
        userSurveyInfo.append(UserSurveyInfo(name: "Top qualities", result: qualitiesArray))
      }
      
      if let qualitiesAppreciate = surveyType.qualitiesAppreciate, qualitiesAppreciate != "" {
        let qualitiesAppreciateArray = qualitiesAppreciate.components(separatedBy: ",")
        userSurveyInfo.append(UserSurveyInfo(name: "Most appreciate", result: qualitiesAppreciateArray))
      }
      
      if let personalityType = surveyType.personalityTypes, personalityType != "" {
        userSurveyInfo.append(UserSurveyInfo(name: "Personality types", result: [personalityType]))
      }
      
      if let kids = surveyType.kids, kids != "" {
        userSurveyInfo.append(UserSurveyInfo(name: "Kids", result: [kids]))
      }
      
      if let kidsInFuture = surveyType.kidsInFuture, kidsInFuture != "" {
        userSurveyInfo.append(UserSurveyInfo(name: "Kids in Future", result: [kidsInFuture]))
      }
      
    }
  }
  
  @objc func didTap() {
    imageSlider.presentFullScreenController(from: self)
  }
  
  func hideSaveCancelUser(type: String, apiType: String = "add") {
    
    guard let userDetails = userDetails else {
      return
    }
    guard let userId = userDetails.id else { return }
    
    AppManager().startActivityIndicator(sender: self.view)
    
    HomeViewModel.shared.saveHideCancelUser(by: "\(userId)", type: type, apiType: apiType) { response, isSuccess, error in
     
      AppManager().stopActivityIndicator(self.view)
      
      guard let response = response, isSuccess else {
        
        if type == "hide" {
          self.blockSwitchBtn.isOn = apiType == "add" ? false : true
        }
        
        Common.showAlert(alertMessage: error ?? "Something went wrong", alertButtons: ["Ok"]) { (bt) in
        }
        return
      }
      
      guard self.checkStatus(status: response.status, message: response.message) else {
        if type == "hide" {
          self.blockSwitchBtn.isOn = apiType == "add" ? false : true
        }
        return
      }
      
      var middleMsg = ""
      
      if type == "saved" {
        if apiType == "add" {
          self.savedBtn.setImage(UIImage(named: "profile_saved"), for: .normal)
          middleMsg = "saved"
        }else {
          self.savedBtn.setImage(UIImage(named: "save-active"), for: .normal)
          middleMsg = "unsaved"
        }
      } else if type == "hide" {
        middleMsg = apiType == "add" ? "hide" : "unhide"
        
      }else if type == "cancel" {
        self.navigationController?.popViewController(animated: true)
      }
      
      NotificationCenter.default.post(name: .refreshHome, object: nil)
      Toast.shared.show(message: "User \(middleMsg) successfully", controller: self)
    }
  }
  
  func likeUser(type: String) {
    
    guard let userDetails = userDetails else {
      return
    }
    guard let userId = userDetails.id else { return }
    
    AppManager().startActivityIndicator(sender: self.view)
    
    HomeViewModel.shared.likelUser(by: "\(userId)", type: type) { response, isSuccess, error in
      
      AppManager().stopActivityIndicator(self.view)
      
      guard let response = response, isSuccess else {
        Common.showAlert(alertMessage: error ?? "Something went wrong", alertButtons: ["Ok"]) { (bt) in
        }
        return
      }
      
      guard self.checkStatus(status: response.status, message: response.message) else {
        return
      }
      
      
      
      if type == "like" {
        self.likeBtn.setImage(UIImage(named: "like-active"), for: .normal)
        Toast.shared.show(message: "User like successfully", controller: self)
      }else {
        self.likeBtn.setImage(UIImage(named: "like-unactive"), for: .normal)
        Toast.shared.show(message: "User dislike successfully", controller: self)
      }
      
      NotificationCenter.default.post(name: .refreshHome, object: nil)
      
    }
  }
}

extension VCUserProfile: UITableViewDelegate, UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    
    return 2
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    if type == "Survey" {
      if section == 0 {
        if userSurveyInfo.isEmpty {
          return 1
        }
        return userSurveyInfo.count
      }
      return 0
    }else if type == "Photo" {
      
      if section == 1 {
        if currentPlan == "premium" {
            return 0
        }
      }
      return 1
    }else {
      if section == 0 {
        return 1
      }
      return 0
    }
    
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    if indexPath.section == 0 {
      
      let cell = tableView.dequeueReusableCell(withIdentifier: "CellTableC") as! CellTableC
      
      cell.type = type
      
      if type == "Survey" {
        
        if !userSurveyInfo.isEmpty {
          
          cell.notAvailableView.isHidden = true
          
          let surveyInfo = userSurveyInfo[indexPath.row]
          cell.titleLbl.isHidden = false
          cell.titleLblHeight.constant = 30
          cell.titleLbl.text = surveyInfo.name
          cell.surveyData = surveyInfo
        }else {
          cell.titleLbl.text = ""
          cell.titleLbl.isHidden = true
          cell.titleLblHeight.constant = 0
          cell.notAvailableView.isHidden = false
          
        }
        
      }else {
        
        cell.notAvailableView.isHidden = true
        cell.titleLbl.text = ""
        cell.titleLbl.isHidden = true
        cell.titleLblHeight.constant = 0
        cell.userDetails = userDetails
        cell.currentPlan = currentPlan
      }
      
      cell.registerNib()
      
      if type == "Photo"  { //|| type == "Survey"
        cell.collectionViewHeight.constant = cell.collectionViewUserProfile.collectionViewLayout.collectionViewContentSize.height
        cell.imageDelegate = self
      }else {
        cell.collectionViewHeight.constant = 50
      }
      
      return cell
      
    }else if indexPath.section == 1 {
      let cell = tableView.dequeueReusableCell(withIdentifier: "CellMemberShipOnProfile") as! CellMemberShipOnProfile
      cell.btnPremMembership.addTarget(self, action: #selector(connectedbtnPremMembership(sender:)), for: .touchUpInside)
      
      return cell
    }
    return UITableViewCell()
    
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.section == 0 {
      
      if type == "Survey"{
        
        if self.userSurveyInfo.isEmpty {
          return 100
        }
        return UITableView.automaticDimension
      }else if type  == "Photo" {

        return UITableView.automaticDimension
      }else {
        return CGFloat(336)
      }
    }else{
      if type  == "Photo"{
        if currentPlan == "premium" {
          return 0
        }
        return 207
      }else{
        return 0
      }
    }
    
    
  }
  
//  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//
//    guard type == "Survey" || section == 0 else {
//      return  .init()
//    }
//    guard !userSurveyInfo.isEmpty else {return .init()}
//
//    let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
//
//    let label = UILabel()
//    label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
//    label.text = userSurveyInfo[section].name
//    label.font = UIFont(name: "SF-Pro-Text-Regular", size: 18.0)
//    label.textColor = .black
//
//    headerView.addSubview(label)
//
//    return headerView
//  }
  
//  func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
//
//    return type == "Survey" ? 50 : 0
//  }
  
}

extension VCUserProfile: OpenImageDelegate {
  func openProfile(imgView: ImageSlideshow) {
    imgView.presentFullScreenController(from: self)
  }
}

class CellTableC: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
  @IBOutlet weak var collectionViewUserProfile: UICollectionView!
  @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
  
  @IBOutlet weak var titleLbl: UILabel!
  @IBOutlet weak var titleLblHeight: NSLayoutConstraint!
  @IBOutlet weak var notAvailableView: UIView!
  
  var type = "Info"
  var currentPlan = ""
  
  var userDetails: UserDetails?
  var photosArr = [UserPhoto]()
  var surveyData: UserSurveyInfo?
  
  weak var imageDelegate: OpenImageDelegate?

  
  override  func awakeFromNib() {
    super.awakeFromNib()
    
    
    collectionViewUserProfile?.register(UINib(nibName: "CellInfoUserProfile", bundle: nil), forCellWithReuseIdentifier: "CellInfoUserProfile")
    collectionViewUserProfile?.register(UINib(nibName: "CellPhotosUserProfile", bundle: nil), forCellWithReuseIdentifier: "CellPhotosUserProfile")
    collectionViewUserProfile?.register(UINib(nibName: "CellSurveyAnswerUserProfile", bundle: nil), forCellWithReuseIdentifier: "CellSurveyAnswerUserProfile")
    collectionViewUserProfile?.register(UINib(nibName: "SurveyInfoCell", bundle: nil), forCellWithReuseIdentifier: "SurveyInfoCell")
    
    collectionViewUserProfile.delegate = self
    collectionViewUserProfile.dataSource = self
    
  }
  
  func registerNib() {
    
    if type == "Survey" {
      if surveyData == nil {
        return
      }
    }
    
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    layout.scrollDirection = .horizontal
    
    if type == "Survey" {
      collectionViewUserProfile.isScrollEnabled = true
    }else {
      collectionViewUserProfile.isScrollEnabled = false
    }
    
    if type == "Photo"{
      if let photos = userDetails?.photos {
        photosArr = photos
      }
      layout.scrollDirection = .vertical
    }
    
    collectionViewUserProfile.collectionViewLayout = layout
    
    DispatchQueue.main.async {
      self.collectionViewUserProfile.reloadData()
    }
    
  }
  
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
    if type == "Photo"{
      return photosArr.count
    }else if type == "Survey" {
      if let surveyData = surveyData {
        return surveyData.result.count
      }
      return 0
    }else{
      return 1
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if type == "Photo"{
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellPhotosUserProfile", for: indexPath) as! CellPhotosUserProfile
      
      if let photoUrl = photosArr[indexPath.item].name {
        if let url = URL(string: photoUrl) {
          
          cell.userImgView.setImageInputs([KingfisherSource(url: url)])
          cell.img.kf.indicatorType = .activity
          cell.img.kf.setImage(with: url)
        }
      }
      
//      if photosArr.count > 3 {
//        if currentPlan != "premium" {
//          if indexPath.item > 2 {
//            cell.viewLockImg.isHidden = false
//          }else {
//            cell.viewLockImg.isHidden = true
//          }
//        }else {
//          cell.viewLockImg.isHidden = true
//        }
//      }else {
        cell.viewLockImg.isHidden = true
//      }
      
      return cell
    }else if type == "Survey" {
      
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SurveyInfoCell", for: indexPath) as? SurveyInfoCell else { return .init() }
      
      guard let surveyData = surveyData else {
        return cell
      }
      
      let info = surveyData.result

      guard info.count > indexPath.item else { return cell }
      cell.titleLbl.text = info[indexPath.item]
      
      return cell
    }else{
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellInfoUserProfile", for: indexPath) as! CellInfoUserProfile
      
      guard let user = userDetails else { return cell}
      
      if let occupation = user.occupation?.name {
        cell.lblOccupation.text = occupation
      }
      
      if let relationShip = user.relationshipData?.name {
        cell.lblRelationshipStatus.text = relationShip
      }
      
      if let education = user.education?.name {
        cell.lblEducation.text = education
      }
    
      cell.lblFiFo.text = user.workingFIFO ?? "-"
      cell.lblSwing.text = user.swing ?? "-"
      cell.lblEthnicity.text = user.countryName ?? "-"

      
      if let surveyInfo = user.questionnaire {
        
        if let height = surveyInfo.height, let heightType = surveyInfo.heightType {
          cell.lblHeight.text = height + " " + heightType
        }
        
        cell.lblBodyType.text = surveyInfo.bodyType
        cell.lblSeeking.text = surveyInfo.seeking
        
      }
      
      return cell
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let collectionWidth = collectionViewUserProfile.bounds.width
    
    if type == "Photo"{
      return CGSize(width: collectionWidth/3 - 20 , height: 113)
    }else if type == "Survey" {
      
      guard let surveyData = surveyData else {
        return .zero
      }

      let item = surveyData.result[indexPath.item]
      let itemSize = sizeAccordingDevice(item: item)
      return CGSize(width: itemSize.width + 30, height: 40)
      
    }else{
      return CGSize(width: collectionWidth , height: 336 )
    }
  }
  
  func sizeAccordingDevice(item: String) -> CGSize {
      
      var size: CGSize = .init()
      
      if let font = UIFont(name: "SFProText-Light", size: 16.0) {
          let fontAttributes = [NSAttributedString.Key.font: font]
          
          size = item.size(withAttributes: fontAttributes)
      }
      
      return size
      
  }
  
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    
    if section == 0 {
      if type == "Photo" {
        return.init(top: 10, left: 10, bottom: 10, right: 10)
      }else if type == "Survey" {
        return.init(top: 0, left: 15, bottom: 10, right: 15)
      }
    }
    return .init(top: 5, left: 0, bottom: 0, right: 0)
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    if type == "Photo" {
      if let cell = collectionView.cellForItem(at: indexPath) as? CellPhotosUserProfile {
        
        if cell.viewLockImg.isHidden {
          self.imageDelegate?.openProfile(imgView: cell.userImgView)
        }
      }
    }
  }
}


class CellMemberShipOnProfile:UITableViewCell{
  
  @IBOutlet weak var btnPremMembership: UIButton!
  
}

extension VCUserProfile {
  
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
        
        if plan == "plan_id_02" {
          self.currentPlan = "premium"
          
        }else if plan == "plan_id_01" {
          self.currentPlan = "standard"
          
        }
      }
    
    }
  }
}
