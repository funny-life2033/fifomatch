//
//  ProfileVC.swift
//  FIFOMatch
//
//  Created by Subhash Sharma on 03/03/22.
//

import UIKit

class ProfileVC: UIViewController {
  
  @IBOutlet weak var userImgView: UIImageView!
  @IBOutlet weak var tblView: UITableView!
  @IBOutlet weak var lblProfileName: UILabel!
  @IBOutlet weak var lblAddress: UILabel!
  @IBOutlet weak var lblDOB: UILabel!
  @IBOutlet weak var verifyImg: UIImageView!
  //@IBOutlet weak var btnEditProfile: UIButton!
  @IBOutlet weak var btnPremium: UIButton!
  
  let informationTitleArray = ["Personal Information", "Profile Verification", "Appearance", "Survey", "Membership", "Visit who all have viewed your profile", "Settings", "Remove Account", "Hidden Profiles"]
  
  let informationTitleArrayImg = [UIImage(named: "Personal Information"),UIImage(named: "view-profile"),UIImage(named: "Appearance"),UIImage(named: "Survey"),UIImage(named: "Membership"),UIImage(named: "view-profile"),UIImage(named: "settings"),UIImage(named: "Remove Account"),UIImage(named: "Hidden Profiles")]
  
  var currentPlan = ""
  var isUserFemale = false
  var profileVerify = 0
  var userImages = [UserPhoto]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationController?.navigationBar.isHidden = true
    btnPremium.setTitle("", for: .normal)
    
    getUserActivePlan()
    getUserProfileDetails()
    addObserver()
  }
  
  @IBAction func btnPremium(_ sender: UIButton) {
  }
  
  @IBAction func imageEditBtnAction(_ sender: UIButton) {
    
    openViewController(controller: ProfileImageVC.self, storyBoard: .mainStoryBoard) { (vc) in
//      vc.uploadedPhotos = self.userImages
    }
  }
  
  @IBAction func btnLogout(_ sender: Any) {
    
    self.alertBoxWithAction(message: Messages.LOGOUT.rawValue, btnTitle: "Logout") {
      self.logOutAccount(type: .logout)
    }
    
  }
  
  deinit {
      debugPrint("deinit call")
      NotificationCenter.default.removeObserver(self)
  }
  
  func logOutAccount(type: LogoutTypes) {
    
    AppManager().startActivityIndicator(sender: self.view)
    
    UserProfileViewModel.shared.logoutUser(type: type) { response, isSuccess, message in
      
      AppManager().stopActivityIndicator(self.view)
      
      guard let response = response, isSuccess else {
        Common.showAlert(alertMessage: message ?? "", alertButtons: ["Ok"]) { (bt) in
        }
        return
      }
      
      guard self.checkStatus(status: response.status, message: response.message) else {
        return
      }
      
      UserDefault.shared.logoutUser()
      appdelegate.setinitalViewController()
      
    }
  }
}

//MARK: - TableView
extension ProfileVC: UITableViewDataSource, UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return informationTitleArray.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileVCCell", for: indexPath) as! ProfileVCCell
    if indexPath.row != 0 {
      cell.iIcon.isHidden = true
    }
    
    cell.lblTitle.text = informationTitleArray[indexPath.row]
    cell.imgTitle.image = informationTitleArrayImg[indexPath.row]
    cell.arrowImgView.image = UIImage(named: "Path 126")
    
    if indexPath.row == 5 {
      if currentPlan != "premium" {
        cell.arrowImgView.image = UIImage(named: "setting-lock")
      }
      
    }
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 80
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let index = indexPath.row
    
    switch index {
    case 0:
      openViewController(controller: ProfileInformationVC.self, storyBoard: .homeStoryboard) { (vc) in
      }
      break;
    case 1:
      openViewController(controller: VerificationVC.self, storyBoard: .homeStoryboard) { (vc) in
        vc.isVerify = self.profileVerify
      }
      break;
    case 2:
      openViewController(controller: VCAppearance.self, storyBoard: .homeStoryboard) { (vc) in
      }
      break;
    case 3:
      openViewController(controller: VCViewEditSurvey.self, storyBoard: .homeStoryboard) { (vc) in
      }
      break;
    case 4:
      openViewController(controller: VCUpgradeMembership.self, storyBoard: .mainStoryBoard) { (vc) in
        vc.isUserFemale = self.isUserFemale
      }
      break;
    case 5:
      
      if currentPlan != "premium" {
        self.alertBoxWithAction(message: Messages.MEMBERSHIP_ERROR.rawValue, btnTitle: "Premium") {
          self.openViewController(controller: VCUpgradeMembership.self, storyBoard: .mainStoryBoard) { (vc) in
            vc.isUserFemale = self.isUserFemale
          }
        }
      }else {
        openViewController(controller: ViewedProfileVC.self, storyBoard: .homeStoryboard) { (vc) in
        }
      }
      
      break;
    case 6:
      openViewController(controller: SettingVC.self, storyBoard: .homeStoryboard) { (vc) in
        vc.currentPlan = self.currentPlan
        vc.isUserFemale = self.isUserFemale
      }
      
      break;
    case 7:
      openViewController(controller: RemoveAccountVC.self, storyBoard: .homeStoryboard) { (vc) in
      }
      
      break;
    case 8:
      openViewController(controller: HiddenProfileVC.self, storyBoard: .homeStoryboard) { (vc) in
      }
      break;
    default:
      openViewController(controller: MatchViewController.self, storyBoard: .homeStoryboard) { (vc) in
      }
      break;
    }
  }
}

//MARK: - Api Calles
extension ProfileVC {
  
  func getUserActivePlan() {
    
    HomeViewModel.shared.getUserActivePlan { response, isSuccess, message in
      
      guard let response = response, isSuccess else {
        
        Common.showAlert(alertMessage: message ?? "Something went wrong", alertButtons: ["Ok"]) { (bt) in }
        return
      }
      
      guard self.checkStatus(status: response.status, message: response.message) else {
        return
      }
      
      if let plan = response.data?.plan_id {
        
        if plan == "plan_id_02" {
          
          self.currentPlan = "premium"
          self.btnPremium.setImage(UIImage(named: "premium-status"), for: .normal)
          
          //14-06-2022 checking expiry date for check subscription expired
          if let expireDate = response.data?.end_datetime {
            if let differenceDays = expireDate.getDays() {
              if differenceDays == 0 || differenceDays < 0 {
                self.currentPlan = ""
              }
            }
          }
          
        }else if plan == "plan_id_01" {
          self.currentPlan = "standard"
          self.btnPremium.setImage(UIImage(named: "standard-membership"), for: .normal)
        }
        
      }else {
        self.btnPremium.setImage(UIImage(named: "standard-membership"), for: .normal)
      }
    
      self.tblView.reloadData()
      
    }
  }
  
  func getUserProfileDetails() {
    
    AppManager().startActivityIndicator(sender: self.view)
    
    UserProfileViewModel.shared.getUserProfileDetails { response, isSuccess, message in
      
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
        self.setupInfo(user: data)
      }
    }
  }
  
  func setupInfo(user: UserProfileDetails) {
    
    self.profileVerify = user.verify ?? 0
    
    if let isUserVerify = user.verify, isUserVerify == 2 {
      verifyImg.isHidden = false
    }else {
      verifyImg.isHidden = true
    }
    lblProfileName.text = (user.name ?? "") + ", \(user.age ?? 0)"
    
    lblAddress.text = UserDefault.shared.getUserCountry()
    
    lblDOB.text = "Born on " + (user.dob ?? "-")
    
    if user.gender?.lowercased() == "woman" {
      isUserFemale = true
    }
    
    if let photos = user.photos {
      self.userImages = photos
      
      if let userImg = photos.first?.name {
        if let url = URL(string: userImg) {
          userImgView.kf.setImage(with: url)
        }
      }
    }
  }
  
}

//MARK:- Update Profile Notifier
extension ProfileVC {
  
  func addObserver() {
    NotificationCenter.default.addObserver(self, selector: #selector(onDidReceiveData(_:)), name: .updateProfile, object: nil)
  }
  
  @objc func onDidReceiveData(_ notification: Notification) {
    
    if let updatePlan = notification.userInfo?["updatePlan"] as? Bool, updatePlan {
      debugPrint("Plan Update")
      getUserActivePlan()
    }
    
    debugPrint("Profile Update")
    getUserProfileDetails()
    
  }
}

class ProfileVCCell: UITableViewCell {
  
  @IBOutlet weak var imgTitle: UIImageView!
  @IBOutlet weak var lblTitle: UILabel!
  @IBOutlet weak var iIcon: UIImageView!
  @IBOutlet weak var arrowImgView: UIImageView!
  
}
