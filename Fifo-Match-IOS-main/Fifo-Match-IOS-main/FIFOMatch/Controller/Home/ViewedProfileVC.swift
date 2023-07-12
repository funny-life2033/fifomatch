//
//  ViewedProfileVC.swift
//  FIFOMatch
//
//  Created by Subhash Sharma on 03/03/22.
//

import UIKit

class ViewedProfileVC: UIViewController {
  
  @IBOutlet weak var topHeaderLbl: UILabel!
  @IBOutlet weak var collectionViews: UICollectionView!
  
  var viewUsers = [LikeSavedUserData1]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    collectionViews.collectionViewLayout = UICollectionViewFlowLayout()
    getViewProfiles()
    
  }
  override func viewWillAppear(_ animated: Bool) {
    self.navigationController?.navigationBar.isHidden = true
    
  }
  @IBAction func btnBAck(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
  }
  
  func getViewProfiles() {
    
    HomeViewModel.shared.getViewedSavedHideUsers(by: "view") { response, isSuccess, message in
      
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
        
        self.topHeaderLbl.text = "\(data.count ?? 0) people viewed  your profile"
        self.viewUsers = allUsers
      }
      
      self.collectionViews.reloadData()
    }
  }
  
}
extension ViewedProfileVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewUsers.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellProfile", for: indexPath) as! CellProfile
    
    let userInfo = viewUsers[indexPath.item]
    
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
    
    return cell
    
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    let userInfo = viewUsers[indexPath.item]
    
    openViewController(controller: VCUserProfile.self, storyBoard: .homeStoryboard) { (vc) in
      vc.userId = "\(userInfo.savedUserID ?? 0)"
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let collectionWidth = collectionViews.bounds.width
    return CGSize(width: collectionWidth/2 - 10 , height: 258 - 15)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 10
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 15
  }
}


class CellProfile :UICollectionViewCell{
  
  @IBOutlet weak var img: UIImageView!
  @IBOutlet weak var lblUserName: UILabel!
  
  @IBOutlet weak var lblDesignation: UILabel!
  @IBOutlet weak var verifyImg: UIImageView!
}
