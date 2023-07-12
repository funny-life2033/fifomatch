//
//  VCFavouritesSaved.swift
//  FIFOMatch
//
//  Created by octal-mac206 on 08/03/22.
//

import UIKit

class VCFavouritesSaved: UIViewController {
  
  @IBOutlet weak var topHeaderLbl: UILabel!
  
  @IBOutlet weak var collectionViews: UICollectionView!
  
  var savedUsers = [LikeSavedUserData1]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    collectionViews.collectionViewLayout = UICollectionViewFlowLayout()
    // Do any additional setup after loading the view.
  }
  override func viewWillAppear(_ animated: Bool) {
    self.navigationController?.navigationBar.isHidden = true
    getSavedUsers()
    
  }
  @IBAction func btnBAck(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
  }
  
  func getSavedUsers() {
    
    HomeViewModel.shared.getViewedSavedHideUsers(by: "saved") { response, isSuccess, message in
      
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

        self.topHeaderLbl.text = "You have \(data.count ?? 0) profile saved"
        self.savedUsers = allUsers
      }
      
      self.collectionViews.reloadData()
    }
  }
  
  func unsaveUser(index: Int) {
    
    guard let userId = savedUsers[index].savedUserID else {
      return
    }
    
    AppManager().startActivityIndicator(sender: self.view)
    
    HomeViewModel.shared.saveHideCancelUser(by: "\(userId)", type: "saved", apiType: "remove") { response, isSuccess, error in
     
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
      
      self.getSavedUsers()
      
    }
  }
  
}

extension VCFavouritesSaved: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return savedUsers.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellFavouritesSaved", for: indexPath) as! CellFavouritesSaved
   
    let userInfo = savedUsers[indexPath.item]
    
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
    
    cell.savedBtn.tag = indexPath.item
    cell.savedBtn.addTarget(self, action: #selector(unsaveUser(_:)), for: .touchUpInside)
    
    return cell
    
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    let userInfo = savedUsers[indexPath.item]
    
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
  
  @objc func unsaveUser(_ sender: UIButton) {
    let index = sender.tag
    unsaveUser(index: index)
  }
}


class CellFavouritesSaved :UICollectionViewCell{
  
  @IBOutlet weak var verifyImg: UIImageView!
  @IBOutlet weak var savedBtn: UIButton!
  @IBOutlet weak var img: UIImageView!
  @IBOutlet weak var lblUserName: UILabel!
  @IBOutlet weak var chatBtn: UIButton!
  @IBOutlet weak var lblDesignation: UILabel!
}
