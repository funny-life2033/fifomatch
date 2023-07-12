//
//  VCNotificationScreen.swift
//  FIFOMatch
//
//  Created by octal-mac206 on 04/03/22.
//

import UIKit

class VCNotificationScreen: UIViewController {
  
  @IBOutlet weak var tableViewNotification: UITableView!
  @IBOutlet weak var clearAllBtn: UIButton!
  @IBOutlet weak var notificationLbl: UILabel!
    
  private var notificationArr = [NotificationData]()
  var openFromNotification = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableViewNotification.delegate = self
    tableViewNotification.dataSource = self
    self.navigationController?.navigationBar.isHidden = true
    // Do any additional setup after loading the view.
    clearAllBtn.isHidden = true
    getNotifications()
  }
  
  @IBAction func btnClearAllNotification(_ sender: Any) {
    self.clearAllNotifications()
  }
  
  
  @IBAction func btnBack(_ sender: UIButton) {
    
    if openFromNotification {
      appDelegate.setHomeView(selectTab: 0)
    }else {
      self.navigationController?.popViewController(animated: true)
    }
    
  }
  
  func getNotifications() {
    
    AppManager().startActivityIndicator(sender: self.view)
    
    NotificationViewModel.shared.getNotifications { response, isSuccess, message in
      
      AppManager().stopActivityIndicator(self.view)
      
      guard let response = response, isSuccess else {
        self.notificationArr = []
        Common.showAlert(alertMessage: message ?? "Something went wrong", alertButtons: ["Ok"]) { (bt) in
        }
        return
      }
      
      guard self.checkStatus(status: response.status, message: response.message) else {
        self.notificationArr = []
        return
      }
        
      self.notificationLbl.isHidden = true
      
      if let allNotification = response.data {
        self.notificationArr = allNotification.reversed()
       
        if !allNotification.isEmpty {
          self.clearAllBtn.isHidden = false
          self.notificationLbl.isHidden = false
        }else {
         
          Toast.shared.show(message: "No Notification available for you.", controller: self)
        }
        
        self.tableViewNotification.reloadData()
      }else {
        Toast.shared.show(message: "No Notification available for you.", controller: self)
      }
      
      self.tableViewNotification.reloadData()
    }
  }
  
  func clearAllNotifications() {
    
    AppManager().startActivityIndicator(sender: self.view)
    
    NotificationViewModel.shared.clearAllNotifications { response, isSuccess, message in
      
      AppManager().stopActivityIndicator(self.view)
      
      guard let response = response, isSuccess else {
        Common.showAlert(alertMessage: message ?? "Something went wrong", alertButtons: ["Ok"]) { (bt) in
        }
        return
      }
      
      guard self.checkStatus(status: response.status, message: response.message) else {
        return
      }
    
      Toast.shared.show(message: response.message ?? "Notification cleared successfully" , controller: self)
      self.clearAllBtn.isHidden = true
      self.getNotifications()
      
    }
  }
}

extension VCNotificationScreen : UITableViewDelegate,UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return notificationArr.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "CellNotification") as! CellNotification
    
    let notification = notificationArr[indexPath.item]
    
    if let image = notification.photo?.name {
      if let url = URL(string: image){
        
        cell.img.kf.indicatorType = .activity
        cell.img.kf.setImage(with: url)
      }
    }
    
    cell.lblHeading.text = notification.title
    cell.lblHeading2.text = notification.subtitle
    
    //cell.lblNewMessageCount.isHidden = true
    
    if let dateS = notification.createdAt {
      
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
      dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
      if let date = dateFormatter.date(from: dateS) {
        setTimeStampInLabel(lbl: cell.lblLastSend, date: date)
      }
      //cell.lblLastSend.text = messageDate
      
    }
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    let info = notificationArr[indexPath.item]
    if info.type == "like" {
      if let userId = info.fromID {
        openViewController(controller: VCUserProfile.self, storyBoard: .homeStoryboard) { (vc) in
          vc.userId = "\(userId)"
        }
      }
    }else if info.type == "match" {
      
      if let id = info.openId {
        openViewController(controller: MatchViewController.self, storyBoard: .homeStoryboard) { (vc) in
          vc.id = "\(id)"
        }
      }
      
    }
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
  
  func setTimeStampInLabel(lbl: UILabel, date: Date) {
  
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



class CellNotification : UITableViewCell{
  
  @IBOutlet weak var img: UIImageView!
  @IBOutlet weak var lblHeading: UILabel!
  @IBOutlet weak var lblHeading2: UILabel!
  @IBOutlet weak var lblLastSend: UILabel!
  @IBOutlet weak var lblNewMessageCount: UILabel!
  
  
  
  
}
