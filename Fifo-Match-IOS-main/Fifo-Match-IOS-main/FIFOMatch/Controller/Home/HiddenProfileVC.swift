//
//  HiddenProfileVC.swift
//  FIFOMatch
//
//  Created by Subhash Sharma on 04/03/22.
//

import UIKit

class HiddenProfileVC: UIViewController {
  
  @IBOutlet weak var topHeaderLbl: UILabel!
  @IBOutlet weak var collectionViews: UICollectionView!
  
  var hideUsers = [LikeSavedUserData1]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationController?.navigationBar.isHidden = true
    collectionViews.collectionViewLayout = UICollectionViewFlowLayout()
    // Do any additional setup after loading the view.
  }
  
  override func viewWillAppear(_ animated: Bool) {
    getHiddenProfiles()
  }
  
  @IBAction func btnBAck(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
  }
  
  func getHiddenProfiles() {
    
    HomeViewModel.shared.getViewedSavedHideUsers(by: "hide") { response, isSuccess, message in
      
      guard let response = response, isSuccess else {
        
        Common.showAlert(alertMessage: message ?? "", alertButtons: ["Ok"]) { (bt) in
        }
        return
      }
      
      guard self.checkStatus(status: response.status, message: response.message) else {
        return
      }
      
      guard let data = response.data else { return }
      if let allUsers = data.allUsers {
        
        self.topHeaderLbl.text = "You have \(data.count ?? 0) hidden profiles"
        self.hideUsers = allUsers
      }
      
      self.collectionViews.reloadData()
    }
  }
  
  func unHideUser(index: Int) {
    
    guard let userId = hideUsers[index].savedUserID else {
      return
    }
    
    AppManager().startActivityIndicator(sender: self.view)
    
    HomeViewModel.shared.saveHideCancelUser(by: "\(userId)", type: "hide", apiType: "remove") { response, isSuccess, error in
     
      AppManager().stopActivityIndicator(self.view)
      
      guard let response = response, isSuccess else {
        Common.showAlert(alertMessage: error ?? "Something went wrong", alertButtons: ["Ok"]) { (bt) in
        }
        return
      }
      
      guard self.checkStatus(status: response.status, message: response.message) else {
        return
      }
      
      Toast.shared.show(message: "User successfully removed", controller: self)
      
      self.getHiddenProfiles()
      
    }
  }
  
}

extension HiddenProfileVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return hideUsers.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellHiddenProfile", for: indexPath) as! CellHiddenProfile
   
    let userInfo = hideUsers[indexPath.item]
    
    guard let user = userInfo.user else { return cell }
    
    if let image = user.photo?.name {
      if let url = URL(string: image){
        
        cell.img.kf.indicatorType = .activity
        cell.img.kf.setImage(with: url)
      }
    }
    
    if let userName = user.name {
      if let userAge = user.age {
        cell.lblUserName.text = userName + ", " + String(userAge)
      }else {
        cell.lblUserName.text = userName
      }
    }
    
    cell.lblDesignation.text = user.occupation?.name
    
    if let isUserVerified = userInfo.userVerified?.isAccepted, isUserVerified  {
      cell.verifyImg.isHidden = false
    }else {
      cell.verifyImg.isHidden = true
    }
    
    cell.unhideSwitchBtn.tag = indexPath.item
    cell.unhideSwitchBtn.addTarget(self, action: #selector(unhide(_:)), for: .touchUpInside)
    
    return cell
    
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    let userInfo = hideUsers[indexPath.item]
    
    openViewController(controller: VCUserProfile.self, storyBoard: .homeStoryboard) { (vc) in
      vc.userId = "\(userInfo.savedUserID ?? 0)"
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let collectionWidth = collectionViews.bounds.width
    return CGSize(width: collectionWidth/2 - 10, height: 290 - 15)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 15
  }
  
  @objc func unhide(_ sender: UIButton) {
    let index = sender.tag
    unHideUser(index: index)
  }
}

class CellHiddenProfile :UICollectionViewCell{
  
  @IBOutlet weak var lblDesignation: UILabel!
  @IBOutlet weak var lblUserName: UILabel!
  @IBOutlet weak var lblProfileToggle: UILabel!
  @IBOutlet weak var img: UIImageView!
  @IBOutlet weak var unhideSwitchBtn: UISwitch!
  @IBOutlet weak var verifyImg: UIImageView!
}
