//
//  ArchivedChatListVC.swift
//  FIFOMatch
//
//  Created by Harendra Singh Rathore on 28/04/22.
//

import UIKit

class ArchivedChatListVC: UIViewController {
  
  @IBOutlet weak var tableViewChat: UITableView!
  @IBOutlet weak var notAvailableView: UIView!
  
  var arrayChatList : Array<ChatRoom> = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableViewChat.delegate = self
    tableViewChat.dataSource = self
    tableViewChat.tableFooterView = UIView()
    tableViewChat.keyboardDismissMode = .onDrag
    
    self.navigationController?.navigationBar.isHidden = true
  }
  
  override func viewWillAppear(_ animated: Bool) {
    getChatList()
  }

  @IBAction func backBtnAction(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
  }
  
  func setLastSeenOnlineTime(time: Double, onlineView: UIView) {
    
    let date = Date(timeIntervalSince1970: TimeInterval((time) / 1000))
    
    let status = date.timeAgoDisplay()
    
    debugPrint("StatusTime = \(status)")
    if status == "now" {
      onlineView.isHidden = false
    }else {
      onlineView.isHidden = true
    }
    
  }
  
}


//MARK: - Archive Chat TableView Delegate and DataSource
extension ArchivedChatListVC : UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return arrayChatList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "CellMessages") as! CellMessages
    
    cell.onlineView.isHidden = true
    
    guard arrayChatList.count > indexPath.row else { return  cell }
    
    let dict = arrayChatList[indexPath.row]
    let message = dict.messageLast!
    let users = dict.group_member
    
    let userId =  UserDefault.shared.getUserId() ?? 0
    
    for user in users {
      
      guard let user = user as? RoomUser else { return cell }
      
      if user.user_id != "\(userId)" {
        cell.lblHeading2.text = (message.mtype == "image") ? "🏞️ Image" : message.text
        cell.lblHeading.text = user.user_name
        
        if let img = user.user_image {
          if let url = URL(string: img) {
            cell.img.kf.setImage(with: url)
          }
        }
        
        self.setTimeStampInLabel(lbl: cell.lblLastSend, msg: dict.messageLast)
        
        
        self.getUserTimeStamp(fId: user.firebase_id, onlineView: cell.onlineView)
        
        if dict.arrCount != nil
        {
          let ids = dict.arrCount.allKeys
          for key in ids {
            if key as? String == String("user_\(userId)") {
              
              cell.lblNewMessageCount.text = "\(dict.arrCount[key] as? Int ?? 0)"
              if dict.arrCount[key] as? Int ?? 0 > 0
              {
                cell.lblHeading2.textColor = .black
                cell.lblNewMessageCount.isHidden = false
              }
              else
              {
                cell.lblHeading2.textColor = .lightGray
                cell.lblNewMessageCount.isHidden = true
              }
              break
            }
          }
        }
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        
      }
    }
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    
    let userId =  UserDefault.shared.getUserId() ?? 0
    
//    // Delete Chat
//    let delete = UIContextualAction(style: .destructive, title: "Delete") {  (contextualAction, view, boolValue) in
//      print(indexPath.row)
//
//      let chatList = self.fromSearch ? self.filterChatList : self.arrayChatList
//      let dict = chatList[indexPath.row]
//      let users = dict.group_member
//      let user = users[indexPath.row]
//      //self.apiCallChatDelete(node: (user as! RoomUser).user_id ?? "" )
//
//    }
    
    // Archive Chat
    let more = UIContextualAction(style: .normal, title: "Unarchive") {  (contextualAction, view, boolValue) in
      
      let dict = self.arrayChatList[indexPath.row]
      let users = dict.group_member
      for user in users {
        if (user as! RoomUser).user_id != String(userId) {
          let roomID = dict.ID
          let userid = (user as! RoomUser).user_id ?? ""
          Constants.refs.databaseChats.child(roomID!).child("group_member").child("user_\(userid)").updateChildValues(["is_archived" : 0])
          self.getChatList()
        }
      }
    }
    
    let swipeActions = UISwipeActionsConfiguration(actions: [more])
    return swipeActions
  }
  
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
      return true
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    let dict = arrayChatList[indexPath.row]
      
    openViewController(controller: ChatDetailVC.self, storyBoard: .homeStoryboard) { (vc) in
      
      let users = dict.group_member
      let userId = UserDefault.shared.getUserId() ?? 0
      var strName : String = ""
      
      for user in users {
        
        guard let user = user as? RoomUser else { return }
        if user.user_id != "\(userId)" {
          strName = user.user_name ?? ""
          vc.senderUserImg = user.user_image ?? ""
          vc.senderID  = user.user_id ?? ""
          vc.senderFirebaseId = user.firebase_id ?? ""
        }
      }
      
      vc.room = dict.ID ?? ""
      vc.senderName = strName
      
    }
  }
  
  func setTimeStampInLabel(lbl: UILabel, msg: Message) {
    
    let date = Date(timeIntervalSince1970: TimeInterval((msg.timeStamp ?? 0) / 1000))
    
    let time = date.timeAgoDisplay()
    
    Common.dateformater().dateFormat = nil
    Common.dateformater().dateStyle = .none
    Common.dateformater().timeStyle = .short
    
    if time == "hrs" {
      lbl.text =  Common.UTCToLocal(date: Common.getStringFromDate(date: date.toGlobalTime(), format: "yyyy-MM-dd HH:mm:ss"), time: true)
      
    }else if time == "week"{
      if Calendar.current.isDateInYesterday(date) {
        lbl.text = "Yesterday"
      }else {
        let f = DateFormatter()
        let weekDay = f.weekdaySymbols[Calendar.current.component(.weekday, from: date) - 1]
        lbl.text = String(weekDay.prefix(3))
      }
      
    }else if time == "date" {
      
      lbl.text =  Common.UTCToLocal(date: Common.getStringFromDate(date: date.toGlobalTime(), format: "yyyy-MM-dd HH:mm:ss"), time: false)
      
    }else {
      lbl.text = time
      
    }
  }
  
}

//MARK: - Api's Call
extension ArchivedChatListVC {
  
  // Get User Current Time Stamp For check online or not
  func getUserTimeStamp(fId: String?, onlineView: UIView) {
    
    guard let senderFirebaseId = fId, senderFirebaseId != "" else { return }
    
    ChatManager().getUserTimestamp(userId: senderFirebaseId) { user in
      
      if let timeStamp = user.object(forKey: "timestamp") as? Double {
        self.setLastSeenOnlineTime(time: timeStamp, onlineView: onlineView)
      }
      
    }
  }
  
  // Get Chat List From Firebase
  func getChatList() {
    
    let userFirebaseId = UserDefault.shared.getUserFirebaseId()
    let userId =  UserDefault.shared.getUserId() ?? 0
    
    guard userFirebaseId.count > 0 else {
      Common.showAlert(alertMessage: "No chat here yet.", alertButtons: ["Ok"]) { (bt) in
      }
      return
    }
    
    AppManager().startActivityIndicator(sender: self.view)
    
    ChatManager().roomList(user: userFirebaseId, child: "chat_room") { list in
      
      guard list.count > 0 else {
        AppManager().stopActivityIndicator(self.view)
        return
      }
      
      self.arrayChatList = []
      
      ChatManager().filterWithTime(userRooms: list, child: "") { room in
        
        AppManager().stopActivityIndicator(self.view)
        
        self.arrayChatList = []
        
        if(room.count > 0) {
          guard let arr =  (room as NSArray).mutableCopy() as? Array<ChatRoom> else { return }
          
          var reversedChatList : Array<ChatRoom> = []
          reversedChatList = arr.reversed()
          
          // Filter unarchive user list
          for  dict in reversedChatList{
            let users = dict.group_member
            
            for user in users {
              if (user as! RoomUser).is_archived == 1 {
                if (user as! RoomUser).user_id != String(userId) {
                  self.arrayChatList.append(dict)
                }
              }
            }
            
          }
          
          if !self.arrayChatList.isEmpty {
            self.notAvailableView.isHidden = true
          }else {
            self.notAvailableView.isHidden = false
          }
          
          self.tableViewChat.reloadData()
          
        }else {
          self.notAvailableView.isHidden = false
          self.arrayChatList.removeAll()
          self.tableViewChat.reloadData()
        }
      }
    }
  }
  
}

