//
//  ChatHistoryVC.swift
//  FIFOMatch
//
//  Created by octal-mac206 on 04/03/22.
//

import UIKit
import IQKeyboardManagerSwift

class ChatDetailVC: UIViewController {
  
  @IBOutlet weak var textViewHeight: NSLayoutConstraint!
  @IBOutlet weak var userImageView: UIImageView!
  @IBOutlet weak var nameLbl: UILabel!
  @IBOutlet weak var lastSeenLbl: UILabel!
  
  @IBOutlet weak var tableViewChatDetail: UITableView!
  @IBOutlet weak var viewRounded: UIView!
  @IBOutlet weak var txtViewMessage: UITextView!
  @IBOutlet weak var btnSendMessage: UIButton!
  @IBOutlet weak var tfBottom: NSLayoutConstraint!
  
  let userId = UserDefault.shared.getUserId() ?? 0
  
  private let imageView = UIImageView()
  var chatCount = 0
  var senderID = ""
  var senderUserImg:String?
  var senderFirebaseId = ""
  
  var previousPosTextview : CGRect!
  var room : String = ""
  var senderName : String = ""
  var rooms : ChatRoom = ChatRoom()
  var alldata : NSMutableDictionary = [:]
  var arrmessage = [Message]()
  var selectedImage : UIImage!
  var lastMsgtimeStamp:Double!
  var isSubcribed : Bool = false
  var dataImage = Data()
  var isSenderSent = false
  var isReceiverSent = false

  var isComingFromNotification = false
  
  var timer : Timer? = nil {
      willSet {
          timer?.invalidate()
      }
  }
  
  private var totalTime = 60

  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //lastSeenLbl.isHidden = true
    tableViewChatDetail.delegate = self
    tableViewChatDetail.dataSource = self
    tableViewChatDetail.keyboardDismissMode = .onDrag
    
    
    txtViewMessage.text = "Message"
    txtViewMessage.textColor = UIColor.lightGray
    txtViewMessage.delegate = self
    
    btnSendMessage.isSelected = true
  
    startObservingKeyboard()
    setupTapGesture()
    startObserver()
    
    
  }
  
  private func startObservingKeyboard() {
    let notificationCenter = NotificationCenter.default
    notificationCenter.addObserver(
      forName: UIResponder.keyboardWillShowNotification,
      object: nil,
      queue: nil,
      using: keyboardWillAppear)
    notificationCenter.addObserver(
      forName: UIResponder.keyboardWillHideNotification,
      object: nil,
      queue: nil,
      using: keyboardWillDisappear)
  }
  
  deinit {
    let notificationCenter = NotificationCenter.default
    notificationCenter.removeObserver(
      self,
      name: UIResponder.keyboardWillShowNotification,
      object: nil)
    notificationCenter.removeObserver(
      self,
      name: UIResponder.keyboardWillHideNotification,
      object: nil)
  }
  
  private func keyboardWillAppear(_ notification: Notification) {
    
    let key = UIResponder.keyboardFrameEndUserInfoKey
      guard let keyboardFrame = notification.userInfo?[key] as? CGRect else {
        return
      }
      let safeAreaBottom = view.safeAreaLayoutGuide.layoutFrame.maxY
      let viewHeight = view.bounds.height
      let safeAreaOffset = viewHeight - safeAreaBottom
      let lastVisibleCell = tableViewChatDetail.indexPathsForVisibleRows?.last
    
    UIView.animate(
      withDuration: 0.3,
      delay: 0,
      options: [.curveEaseInOut],
      animations: {
        self.tfBottom.constant = keyboardFrame.height - safeAreaOffset
        self.view.layoutIfNeeded()
        if let lastVisibleCell = lastVisibleCell {
          self.tableViewChatDetail.scrollToRow(
            at: lastVisibleCell, at: .bottom, animated: false)
        }
    })
  }

  private func keyboardWillDisappear(_ notification: Notification) {
  
    UIView.animate(
        withDuration: 0.3,
        delay: 0,
        options: [.curveEaseInOut],
        animations: {
          self.tfBottom.constant = 0
          self.view.layoutIfNeeded()
      })
  }
  
  override func viewWillLayoutSubviews() {
    //viewRounded.dropShadowTop()
    
    viewRounded.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    viewRounded.layer.cornerRadius = 24
    
    viewRounded.layer.shadowOpacity = 0.25
    viewRounded.layer.shadowOffset = CGSize(width: 0, height: -3)
    viewRounded.layer.shadowRadius = 2.5
    viewRounded.layer.shadowColor = UIColor.lightGray.cgColor
  }
  
  override func viewWillAppear(_ animated: Bool) {
    
    self.navigationController?.navigationBar.isHidden = true
    
    getUserDetails()
    getUserTimeStamp()
    startTimer()
    getRoomDetails()
    
  }
  
  func startTimer() {
      stopTimer()
      guard self.timer == nil else { return }
    self.timer = Timer.scheduledTimer(timeInterval: 30.0, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)
  }
  
  func stopTimer() {
      guard timer != nil else { return }
      timer?.invalidate()
      timer = nil
  }
  
  @objc func updateTime() {
    getUserTimeStamp()
  }

  
  private func keyboardManagerVisible(_ state: Bool) {
    IQKeyboardManager.shared.enableAutoToolbar = state
    IQKeyboardManager.shared.enable = state
  }
  
  override func viewDidAppear(_ animated: Bool) {
    self.keyboardManagerVisible(false)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    stopTimer()
    self.keyboardManagerVisible(true)
    //self.updateOnlineStatus(value: 0)
  }
  
  func setupTapGesture() {
    
    let photoTap = UITapGestureRecognizer(target: self, action: #selector(openUserProfile))
    userImageView.isUserInteractionEnabled = true
    userImageView.addGestureRecognizer(photoTap)
  }
  
  @objc func openUserProfile() {
    openViewController(controller: VCUserProfile.self, storyBoard: .homeStoryboard) { (vc) in
      vc.userId = self.senderID
    }
  }
  
  
  @IBAction func btnBAck(_ sender: Any) {
    
    ChatManager().stopObserver(room: room)
    if isComingFromNotification {
      appDelegate.setHomeView()
    }
    else {
      self.navigationController?.popViewController(animated: true)
    }
  }
  
  @IBAction func sendBtnAction(_ sender: UIButton) {
    self.sendMessage()
  }
  
  
}

//MARK: - Api Call's
extension ChatDetailVC {
  
  func getUserTimeStamp() {
    
    guard senderFirebaseId != "" else { return }
    
    ChatManager().getUserTimestamp(userId: senderFirebaseId) { user in
        
      if let timeStamp = user.object(forKey: "timestamp") as? Double {
        self.setLastSeenOnlineTime(time: timeStamp)
      }
      
    }
  }
  
  func getRoomDetails() {
    
    ChatManager().roomDetails(room: room) { (crooms) in
      self.rooms = crooms
      self.setupUserData(chatRoom: crooms)
      if self.rooms.arrCount != nil {
        let ids = self.rooms.arrCount.allKeys
        for key in ids {
          if key as? String == String("user_\(self.userId)"){
            
            Constants.refs.databaseChats.child(self.room).child("unread_messages_count").updateChildValues(["user_\(self.userId)": 0])
            
          }
        }
      }
      
      //self.updateOnlineStatus(value: 1)
    }
  }
  
  func setupUserData(chatRoom: ChatRoom) {
    let users = chatRoom.group_member
    let userId =  UserDefault.shared.getUserId() ?? 0
    
    for user in users {
      guard let user = user as? RoomUser else { return }
      if user.user_id != "\(userId)" {
        nameLbl.text = user.user_name
        
        if let img = user.user_image {
          if let url = URL(string: img) {
            userImageView.kf.setImage(with: url)
          }
        }
        
        if let firebaseId = user.firebase_id {
          if self.senderFirebaseId == "" {
            self.senderFirebaseId = firebaseId
          }
        }
      }
    }
  }
  
  func updateOnlineStatus(value: Int) {
    
    if self.rooms.arrCount != nil {
      let ids = self.rooms.arrCount.allKeys
      for key in ids {
        if key as? String == String("user_\(self.userId)"){
          
          Constants.refs.databaseChats.child(self.room).child("group_member").child("user_\(self.userId)").child("is_online").setValue(value)
          
        }
      }
    }
  }
  
  func startObserver() {
    
    ChatManager().newMessage(room: room) { (msg, isGet) in
      
      if isGet{
        
        let date = Date(timeIntervalSince1970: TimeInterval((msg.timeStamp ?? 0) / 1000))
        // self.lastMsgtimeStamp = msg.timeStamp
        Common.dateformater().dateFormat = nil
        Common.dateformater().dateStyle = .medium
        Common.dateformater().timeStyle = .none
        
        let strDate = Common.getStringFromDate(date: date, format: "yyyy-MM-dd")
        let msgdate = strDate.toDate()
        
        self.arrmessage.append(msg)
        
        let arrKeys = self.alldata.allKeys as NSArray
        if !arrKeys.contains(msgdate ){
          
          self.alldata[msgdate] = [msg]
          
          let sections = self.alldata.allKeys.sorted { (a, b) -> Bool in
            return (a as! Date ) < (b as! Date)
          }
          //  sections = (sections as NSArray).reversed()
          
          let arrmsgDateWise = self.alldata[sections[sections.count-1]]  as! Array<Message>
          
          
          let lastIndexPath = IndexPath(row: arrmsgDateWise.count-1, section: self.alldata.allKeys.count-1)
          
          self.tableViewChatDetail.insertSections([lastIndexPath.section], with: .automatic)
          self.tableViewChatDetail.scrollToRow(at: lastIndexPath,
                                               at: UITableView.ScrollPosition.bottom,
                                               animated: false)
          
          
        }else{
          
          var arrdateWithMsg : Array<Message> = (self.alldata[msgdate ] as! NSArray).mutableCopy() as! Array
          arrdateWithMsg.append(msg)
          self.alldata[msgdate ] = arrdateWithMsg
          
          let lastIndexPath = IndexPath(row: arrdateWithMsg.count-1, section: self.alldata.allKeys.count-1)
          
          
          self.tableViewChatDetail.beginUpdates()
          self.tableViewChatDetail.insertRows(at: [lastIndexPath], with: .none)
          self.tableViewChatDetail.endUpdates()
          
          self.tableViewChatDetail.scrollToRow(at: lastIndexPath,
                                               at: UITableView.ScrollPosition.bottom,
                                               animated: false)
        }
        
        let TempSender = self.arrmessage.filter({$0.senderID ?? "" == "\(self.userId)"}).count
        
        if TempSender > 0
        {
          self.isSenderSent = true
        }
        
        let TempReceiver = self.arrmessage.filter({$0.senderID ?? "" != "\(self.userId)"}).count
        
        if TempReceiver > 0
        {
          self.isReceiverSent = true
        }
        
        //        if self.isSenderSent && self.isReceiverSent
        //        {
        //          self.btnAttached.isHidden = false
        //        }
        //        else
        //        {
        //          self.btnAttached.isHidden = true
        //        }
      }
    }
  }
  
  func updateUserTimeStamp() {
    
    let userFirebaseId = UserDefault.shared.getUserFirebaseId()
    if userFirebaseId != "" {
      let timestamp = Date.currentTimeStamp
      Constants.refs.databaseUsers.child(userFirebaseId).child("timestamp").setValue(timestamp)
    }
    
  }
  
  func sendMessage() {
    
    self.updateUserTimeStamp()

    var strMessage = txtViewMessage.text?.trimmingCharacters(in: .whitespaces) ?? ""

    if strMessage.count > 0 && strMessage != "Message" {
      
      if isSubcribed {
        let sections = self.alldata.allKeys.sorted { (a, b) -> Bool in
          return (a as! Date ) < (b as! Date)
        }
        
        //  sections = (sections as NSArray).reversed()
        
        if sections.count < 5 {
          var countMsg : Int = 0
          for (i, _) in self.alldata.allKeys.enumerated() {
            let arrmsgDateWise = self.alldata[sections[i]]  as! Array<Message>
            let sortedArr = arrmsgDateWise.sorted { (a , b) -> Bool in
              return (a).senderID == "\(userId)"
            }
            countMsg = countMsg + sortedArr.count
            if (countMsg > 4){
              self.txtViewMessage.resignFirstResponder()
              return;
            }
          }
        }else{
          self.txtViewMessage.resignFirstResponder()
          return;
          
        }
      }
      
      if btnSendMessage.isSelected {
      
        self.txtViewMessage.text = ""
        self.btnSendMessage.isSelected = false
        self.txtViewMessage.resignFirstResponder()
        
        if rooms.arrCount != nil
        {
          let ids = rooms.arrCount.allKeys
          for key in ids {
            if key as? String != String("user_\(userId))") {
              
              chatCount = (rooms.arrCount[key] as? Int ?? 0)
              
            }
          }
        }
        
        chatCount = chatCount + 1
        
        ChatManager().sendMessage(data: strMessage, type: MessageType.TextMessage, room: room, rooms: self.rooms, count: chatCount) { (issent) in
          if issent{
            print("sent")
            
            //  self.lastMsgtimeStamp = time
            let userRoom = self.room.split(separator: "_") as NSArray
            for item in userRoom {
              if item as? String ?? "" != "\(self.userId)" {
                self.callAPINotification(struserId: item as? String ?? "" , message: strMessage)

              }
            }
            
            strMessage = ""
          }
        }
      }
    }
    else {
      Common.showAlert(alertMessage: "Please add some text", alertButtons: ["Ok"]) { (bt) in
      }
    }
  }
  
  // MARK: - API call for notification
  func callAPINotification(struserId: String, message: String) {
    
    var params =  [String : Any]()
    params["user_id"] = struserId
    params["message"] = message
 
    //AppManager().startActivityIndicator(sender: self.view)
    
    ChatViewModel.shared.sendNotification(params: params) { response, isSuccess, message in
      
      //AppManager().stopActivityIndicator(self.view)
      
      guard let response = response, isSuccess else {
        Common.showAlert(alertMessage: message ?? "Something went wrong", alertButtons: ["Ok"]) { (bt) in
        }
        return
      }
      
      guard self.checkStatus(status: response.status, message: response.message) else {
        return
      }
    }
      
      
  }
  
  //MARK: - Get User Details
  func getUserDetails() {
    
    AppManager().startActivityIndicator(sender: self.view)
    
    HomeViewModel.shared.getUserDetail(by: senderID) { response, isSuccess, message in
      
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
        if userDetails.isChatEnable == true {
          self.viewRounded.isHidden = false
        }else {
          self.viewRounded.isHidden = true
          self.textViewHeight.constant = 0
        }
        
      }
      
    }
  }
  
}

//MARK: - TableView Delegate and DataSource Methods
extension ChatDetailVC : UITableViewDelegate, UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int  {
    return alldata.allKeys.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let sections = alldata.allKeys.sorted { (a, b) -> Bool in
      return (a as! Date ) < (b as! Date)
    }
    //sections = (sections as NSArray).reversed()
    
    let arrmsgDateWise = alldata[sections[section]] as! NSArray
    
    return arrmsgDateWise.count
    
  }
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let sections = alldata.allKeys.sorted { (a, b) -> Bool in
      return (a as! Date ) < (b as! Date)
    }
    
    let arrmsgDateWise = alldata[sections[indexPath.section]]  as! Array<Message>
    
    let msg = arrmsgDateWise[indexPath.row]
    
    if "\(userId)" != msg.senderID  {
      
      if msg.mtype == "text" {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellReciever") as! CellReciever
        
        cell.lblMessage.text = msg.text
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.lblTime.text = self.setTimeStampInLabel(msg: msg)
        
        return cell
      }
      
      return .init()
      
    }else{
      
      if msg.mtype == "text" {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellSender") as! CellSender
        
        cell.lblMessage.text = msg.text
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.lblTime.text = self.setTimeStampInLabel(msg: msg)
        
        return cell

      }
    }
    
    return UITableViewCell()
    
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
  
  func setTimeStampInLabel(msg:Message) -> String {
      
      let date = Date(timeIntervalSince1970: TimeInterval((msg.timeStamp ?? 0) / 1000))
      
      Common.dateformater().dateFormat = nil
      Common.dateformater().dateStyle = .none
      Common.dateformater().timeStyle = .short

    return Common.UTCToLocal(date: Common.getStringFromDate(date: date.toGlobalTime(), format: "yyyy-MM-dd HH:mm:ss"), time: true)
  }
  
  func setLastSeenOnlineTime(time: Double) {
    
    let date = Date(timeIntervalSince1970: TimeInterval((time) / 1000))
    
    let time = date.timeAgoDisplay()
    
    Common.dateformater().dateFormat = nil
    Common.dateformater().dateStyle = .none
    Common.dateformater().timeStyle = .short
    
    var onlineTime = ""
    
    if time == "hrs" {
      onlineTime =  Common.UTCToLocal(date: Common.getStringFromDate(date: date.toGlobalTime(), format: "yyyy-MM-dd HH:mm:ss"), time: true)
      
    }else if time == "week"{
      if Calendar.current.isDateInYesterday(date) {
        onlineTime = "Yesterday"
      }else {
        let f = DateFormatter()
        let weekDay = f.weekdaySymbols[Calendar.current.component(.weekday, from: date) - 1]
        onlineTime = String(weekDay.prefix(3))
      }
      
    }else if time == "date" {

      onlineTime =  Common.UTCToLocal(date: Common.getStringFromDate(date: date.toGlobalTime(), format: "yyyy-MM-dd HH:mm:ss"), time: false)
      
    }else {
      onlineTime = time
    }
    
    if onlineTime != "" {
      if onlineTime == "now" {
        lastSeenLbl.text = "Online"
         
      }else {
        lastSeenLbl.text = "Last seen \(onlineTime)"
        lastSeenLbl.isHidden = false
      }

    }else {
      lastSeenLbl.isHidden = true
    }
  }
  
}

//MARK: - TextView Delegate
extension ChatDetailVC : UITextViewDelegate {
  
  func textViewDidBeginEditing(_ textView: UITextView) {
    if textView.textColor == UIColor.lightGray {
      txtViewMessage.text = nil
      txtViewMessage.textColor = UIColor.black
    }
    
    let pos: UITextPosition = textView.endOfDocument
    
    previousPosTextview = textView.caretRect(for: pos)
    
  }
  
  func textViewDidEndEditing(_ textView: UITextView) {
    if textView.text.isEmpty {
      txtViewMessage.text = "Message"
      txtViewMessage.textColor = UIColor.lightGray
    }
  }
  
  func textViewDidChange(_ textView: UITextView) {

      // updating chatview container height according to message height

      let pos: UITextPosition = textView.endOfDocument

      let currentRect: CGRect = textView.caretRect(for: pos)

      let trimmedString = textView.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

      btnSendMessage.isSelected = trimmedString.count > 0

      // threshold for maximum height of textview
      let threshold: Int = 120

      if currentRect.origin.y > previousPosTextview.origin.y {

          for constraint in viewRounded.constraints {

              if constraint.firstAttribute == .height && constraint.constant < CGFloat(threshold) {

                  constraint.constant = constraint.constant + 11
                  break
              }
          }

          UIView.animate(withDuration: 0.3, animations: {

              self.view.layoutIfNeeded()

          })
      }else {
          print(currentRect.origin.y,previousPosTextview.origin.y
          )

          if (currentRect.origin.y) < (previousPosTextview.origin.y) {

              for constraint in viewRounded.constraints {

                  if (constraint.firstAttribute) == .height && constraint.constant < CGFloat(threshold) {

                      constraint.constant = constraint.constant - 11
                      break
                  }
              }

              UIView.animate(withDuration: 0.3, animations: {

                  self.view.layoutIfNeeded()

              })
          }

      }

      previousPosTextview = currentRect
  }
  
}

//MARK: - Sender TableView Cell
class CellSender : UITableViewCell {
  
  @IBOutlet weak var lblMessage: UILabel!
  @IBOutlet weak var lblTime: UILabel!
}

//MARK: - Receiver TableView Cell
class CellReciever : UITableViewCell {
  
  @IBOutlet weak var lblMessage: UILabel!
  @IBOutlet weak var lblTime: UILabel!
  
}
