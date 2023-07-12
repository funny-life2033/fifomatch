//
//  ChatVC.swift
//  FIFOMatch
//
//  Created by octal-mac206 on 04/03/22.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ChatVC: UIViewController {
  
  @IBOutlet weak var tableViewChat: UITableView!
  @IBOutlet weak var searchBar: UISearchBar!
  
  var arrayChatList : Array<ChatRoom> = []
  var filterChatList : Array<ChatRoom> = []
  
  var fromSearch = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableViewChat.delegate = self
    tableViewChat.dataSource = self
    tableViewChat.tableFooterView = UIView()
    tableViewChat.keyboardDismissMode = .onDrag
    
    searchBar.delegate = self
    
    self.searchBar.searchTextField.borderStyle = .none
    self.searchBar.searchTextField.backgroundColor = .white
    
    self.navigationController?.navigationBar.isHidden = true
  }
  
  override func viewWillAppear(_ animated: Bool) {
    getChatList()
  }

  @IBAction func archiveBtnAction(_ sender: UIButton) {
    
    openViewController(controller: ArchivedChatListVC.self, storyBoard: .homeStoryboard) { (vc) in
    }
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


//MARK: - Chat TableView Delegate and DataSource
extension ChatVC : UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return fromSearch ? filterChatList.count : arrayChatList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "CellMessages") as! CellMessages
    
    cell.onlineView.isHidden = true
    var chatList: Array<ChatRoom> = []
    
    if fromSearch {
      chatList = filterChatList
    }else {
      chatList = arrayChatList
    }
    
    guard chatList.count > indexPath.row else { return  cell }
    
    let dict = chatList[indexPath.row]
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
    
    // Delete Chat
    let delete = UIContextualAction(style: .destructive, title: "Delete") {  (contextualAction, view, boolValue) in
      print(indexPath.row)
      
      let chatList = self.fromSearch ? self.filterChatList : self.arrayChatList
      let dict = chatList[indexPath.row]
      if let node = dict.group_id {
        self.deleteUserChat(by: node)
      }
    }
    
    // Archive Chat
    let more = UIContextualAction(style: .normal, title: "Archive") {  (contextualAction, view, boolValue) in
      
      
      let chatList = self.fromSearch ? self.filterChatList : self.arrayChatList
      let dict = chatList[indexPath.row]
      let users = dict.group_member
      for user in users {
        if (user as! RoomUser).user_id != String(userId) {
          let roomID = dict.ID
          let userid = (user as! RoomUser).user_id ?? ""
          Constants.refs.databaseChats.child(roomID!).child("group_member").child("user_\(userid)").updateChildValues(["is_archived" : 1])
          self.getChatList()
        }
      }
    }
    
    let swipeActions = UISwipeActionsConfiguration(actions: [delete,more])
    return swipeActions
  }
  
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
      return true
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    var chatList: Array<ChatRoom> = []
    
    if fromSearch {
      chatList = filterChatList
    }else {
      chatList = arrayChatList
    }
    
    let dict = chatList[indexPath.row]
    
    
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
extension ChatVC {
  
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
    
    self.arrayChatList.removeAll()
    self.tableViewChat.reloadData()
    
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
              if (user as! RoomUser).is_archived == 0 {
                if (user as! RoomUser).user_id != String(userId) {
                  self.arrayChatList.append(dict)
                }
              }
            }
            
          }
          
          self.tableViewChat.reloadData()
          
        }else {
          self.arrayChatList.removeAll()
          self.tableViewChat.reloadData()
        }
      }
    }
  }
  
  // Delete Users Chat by Node
  func deleteUserChat(by node: String){
      
    AppManager().startActivityIndicator(sender: self.view)
    
    ChatViewModel.shared.deletChat(chatNode: node) { response, isSuccess, message in
      
      AppManager().stopActivityIndicator(self.view)
      
      guard let response = response, isSuccess else {
        Common.showAlert(alertMessage: message ?? "Something went wrong", alertButtons: ["Ok"]) { (bt) in
        }
        return
      }
      
      guard self.checkStatus(status: response.status, message: response.message) else {
        return
      }
      
      self.getChatList()
    }
    
  }
  
}

extension ChatVC: UISearchBarDelegate {
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    
    if let searchText = searchBar.text, searchText != "" {
      filterChatList = filterChatList(searchText: searchText.lowercased())
      fromSearch = true
    }else {
      fromSearch = false
      searchBar.text = ""
      searchBar.showsCancelButton = false
    }
    
    tableViewChat.reloadData()
    searchBar.resignFirstResponder()
    
  }
  
  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    searchBar.showsCancelButton = true
  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    fromSearch = false
    searchBar.text = ""
    tableViewChat.reloadData()
    searchBar.showsCancelButton = false
    searchBar.resignFirstResponder()
  }
  
  func filterChatList(searchText: String) -> Array<ChatRoom> {
    
    let userId = "\(UserDefault.shared.getUserId() ?? 0)"
    
    var filterChat = [ChatRoom]()
    arrayChatList.forEach { chatroom in
      let users = chatroom.group_member
      
      for user in users {
        
        if let user = user as? RoomUser  {
          if user.user_id != userId {
            
            if let userName = user.user_name?.lowercased() {
              if userName.contains(searchText) {
                filterChat.append(chatroom)
              }
            }
          }
        }
      }
    }
    
    return filterChat
  }
}



class CellMessages : UITableViewCell {
  
  @IBOutlet weak var onlineView: UIView!
  @IBOutlet weak var img: UIImageView!
  @IBOutlet weak var lblHeading: UILabel!
  @IBOutlet weak var lblHeading2: UILabel!
  @IBOutlet weak var lblLastSend: UILabel!
  @IBOutlet weak var lblNewMessageCount: UILabel!
  
  override  func awakeFromNib() {
    super.awakeFromNib()
    lblNewMessageCount.layer.masksToBounds = true
    lblNewMessageCount.layer.cornerRadius = lblNewMessageCount.frame.height/2
    
    onlineView.layer.cornerRadius = onlineView.frame.height/2
  }
}
