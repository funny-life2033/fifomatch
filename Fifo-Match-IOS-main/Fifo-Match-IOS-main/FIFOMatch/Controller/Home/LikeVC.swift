//
//  LikeVC.swift
//  FIFOMatch
//
//  Created by Harendra Singh Rathore on 31/03/22.
//

import UIKit

class LikeVC: UIViewController {
  
  
  @IBOutlet weak var topHeaderLbl: UILabel!
  @IBOutlet weak var collectionViews: UICollectionView!
 
  var likedUsers = [LikeUserData]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    collectionViews.collectionViewLayout = UICollectionViewFlowLayout()
    
    // Do any additional setup after loading the view.
  }
  override func viewWillAppear(_ animated: Bool) {
    getLikedUsers()
    self.navigationController?.navigationBar.isHidden = true
    
  }
  @IBAction func btnBAck(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
  }
  
  func getLikedUsers() {
    
    AppManager().startActivityIndicator(sender: self.view)
    
    HomeViewModel.shared.getLikedUsers { response, isSuccess, message in
      
      AppManager().stopActivityIndicator(self.view)
      
      guard let response = response, isSuccess else {
        
        Common.showAlert(alertMessage: message ?? "", alertButtons: ["Ok"]) { (bt) in
        }
        return
      }
      
      guard self.checkStatus(status: response.status, message: response.message) else {
        return
      }
      
      if let allLikeUsers = response.data {

        self.topHeaderLbl.text = "You have \(allLikeUsers.count) profile like"
        self.likedUsers = allLikeUsers
      }
      
      self.collectionViews.reloadData()
    }
  }
  
  //MARK: - Create Chat between Match Users
  func createChat(user: Receiver?) {
    
    guard let user = user, let userId = user.id else {
      return
    }
    
    let params = ["user_id": "\(userId)"]
    
    AppManager().startActivityIndicator(sender: self.view)
    
    ChatViewModel.shared.createChat(params: params) { response, isSuccess, message in
      
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
        let node = data.node ?? ""
       
        let userImage = user.photo?.name
        let userName = user.name
        
        
        self.openViewController(controller: ChatDetailVC.self, storyBoard: .homeStoryboard) { (vc) in
            vc.room = node
            vc.senderName = userName ?? "Not Available"
            vc.senderUserImg = userImage ?? ""
            vc.senderID = "\(userId)"
            vc.senderFirebaseId = user.firebase_id ?? ""

        }
      }

      //Toast.shared.show(message: response.message ?? "", controller: self)
      
    }
  }
  
}

extension LikeVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return likedUsers.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellFavouritesSaved", for: indexPath) as! CellFavouritesSaved
    
    let userInfo = likedUsers[indexPath.item]
    let userId = UserDefault.shared.getUserId() ?? 0
    
    var likeUser: Receiver?
    
    if userId == userInfo.senderID {
      likeUser = userInfo.receiver
      
      if let isUserVerified = userInfo.userVerifiedReceiver?.isAccepted, isUserVerified  {
        cell.verifyImg.isHidden = false
      }else {
        cell.verifyImg.isHidden = true
      }
    }else {
      likeUser = userInfo.sender
      
      if let isUserVerified = userInfo.userVerifiedSender?.isAccepted, isUserVerified  {
        cell.verifyImg.isHidden = false
      }else {
        cell.verifyImg.isHidden = true
      }
    }
    
    guard let user = likeUser else { return cell }
    
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
    
    cell.chatBtn.tag = indexPath.item
    cell.chatBtn.addTarget(self, action: #selector(clickOnChatBtn(_:)), for: .touchUpInside)
    
    return cell
    
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let collectionWidth = collectionViews.bounds.width
    return CGSize(width: collectionWidth/2 - 10 , height: 258 - 15)
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    let userInfo = likedUsers[indexPath.item]
    
    let userId = UserDefault.shared.getUserId() ?? 0
    
    var matchedUserId = ""
    
    if userId == userInfo.senderID {
      matchedUserId = "\(userInfo.receiverID ?? 0)"
    }else {
      matchedUserId = "\(userInfo.senderID ?? 0)"
    }
    
    if matchedUserId != "0" {
      openViewController(controller: VCUserProfile.self, storyBoard: .homeStoryboard) { (vc) in
        vc.userId = matchedUserId
      }
    }
      
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 10
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 15
  }
  
  @objc func clickOnChatBtn(_ sender: UIButton) {
    let index = sender.tag
    
    let userInfo = likedUsers[index]
    let userId = UserDefault.shared.getUserId() ?? 0
    
    if userId == userInfo.senderID {
      guard let user = userInfo.receiver else { return }
      createChat(user: user)
    }else {
      guard let user = userInfo.sender else { return }
      createChat(user: user)
    }
  }
}
