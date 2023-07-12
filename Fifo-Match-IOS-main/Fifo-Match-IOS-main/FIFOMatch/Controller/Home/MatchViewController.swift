//
//  MatchViewController.swift
//  FlowDating
//
//  Created by deepti on 23/03/21.
//

import UIKit
import CloudKit
//import SDWebImage
class MatchViewController: UIViewController {
  
  @IBOutlet weak var bothNameLbl: UILabel!
  @IBOutlet weak var titleLbl: UILabel!
  @IBOutlet weak var userTwoImageView: UIImageView!
  @IBOutlet weak var user1ImageView: UIImageView!
  
  var likeUserImage = ""
  var likeUserName = ""
  
  var id = ""
  var matchUsers: MatchProfileData?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.navigationController?.setNavigationBarHidden(true, animated: false)
    
    user1ImageView.transform = user1ImageView.transform.rotated(by: -(.pi * 0.02))    // 90˚
    userTwoImageView.transform = user1ImageView.transform.rotated(by: (.pi * 0.05))    // 90˚
    
    let userName = UserDefault.shared.getUserName()
    titleLbl.text = "It's a match, \(userName)!"
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    // setup()
    getMatchUsersDetail()
  }
  
  @IBAction func btnBack(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
  }
  
  @IBAction func closeBtn(_ sender: Any) {
    appDelegate.setHomeView(selectTab: 0)
  }
  
  @IBAction func sayHelloBtn(_ sender: UIButton) {
    
    let userId = UserDefault.shared.getUserId() ?? 0
    
    if userId == matchUsers?.senderID {
     
      if let matchedUserId = matchUsers?.receiverID {
        createChat(id: "\(matchedUserId)")
      }
    }else {
      if let matchedUserId = matchUsers?.senderID {
        createChat(id: "\(matchedUserId)")
      }
    }
    
  
    
    
  }
  
  //MARK: - Get Match Users Details
  func getMatchUsersDetail() {
    
    AppManager().startActivityIndicator(sender: self.view)
    
    
    HomeViewModel.shared.getMatchUsersDetail(by: id) { response, isSuccess, message in
      
      AppManager().stopActivityIndicator(self.view)
      
      guard let response = response, isSuccess else {
        
        Common.showAlert(alertMessage: message ?? "", alertButtons: ["Ok"]) { (bt) in
        }
        return
      }
      
      guard self.checkStatus(status: response.status, message: response.message) else {
        return
      }
      
      if let matchUsers = response.data {
        self.matchUsers = matchUsers
        
        if let senderImg = matchUsers.senderPhoto?.name {
          if let url = URL(string: senderImg) {
            self.user1ImageView.kf.setImage(with: url)
          }
        }
        
        if let receiverImg = matchUsers.receiverPhoto?.name {
          self.likeUserImage = receiverImg
          if let url = URL(string: receiverImg) {
            self.userTwoImageView.kf.setImage(with: url)
          }
        }
      }
    }
  }
  
  //MARK: - Create Chat between Match Users
  func createChat(id: String) {
    
    let params = ["user_id":id]
    
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
       
        guard let likeUserProfile = self.matchUsers?.receiverPhoto, let likeUserId = likeUserProfile.userID else {
          return
        }
        
        self.openViewController(controller: ChatDetailVC.self, storyBoard: .homeStoryboard) { (vc) in
            vc.room = node
            vc.senderName = "Don't have yet"
            vc.senderUserImg = likeUserProfile.name
            vc.senderID = "\(likeUserId)"
          vc.isComingFromNotification = true
        }
      }

      Toast.shared.show(message: response.message ?? "", controller: self)
      
    }
  }
  
}
