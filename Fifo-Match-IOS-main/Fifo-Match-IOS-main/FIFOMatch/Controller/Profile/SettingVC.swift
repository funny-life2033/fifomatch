//
//  SettingVC.swift
//  FIFOMatch
//
//  Created by Subhash Sharma on 03/03/22.
//

import UIKit
import SwiftUI

class SettingVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  @IBOutlet weak var tblView: UITableView!
  
  @IBOutlet weak var btnOnlineStatusToggle: UISwitch!
  @IBOutlet weak var btnNotificationToggle: UISwitch!
  
  var currentPlan = ""
  var isUserFemale = false
  
  let arrayTitles = ["About us","Contact us","Help","Privacy Policy","Terms & Conditions"]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationController?.navigationBar.isHidden = true
    
    let userDefault = UserDefault.shared
    btnNotificationToggle.isOn = userDefault.isNotificationOn()
    btnOnlineStatusToggle.isOn = userDefault.isUserOnline()
  }
  
  @IBAction func btnBAck(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
  }
  
  @IBAction func btnOnlineClick(_ sender: UISwitch) {
    
    if currentPlan != "premium" {
      sender.isOn = !sender.isOn
      self.alertBoxWithAction(message: Messages.MEMBERSHIP_ERROR.rawValue, btnTitle: "Premium") {
        self.openViewController(controller: VCUpgradeMembership.self, storyBoard: .mainStoryBoard) { (vc) in
          vc.isFromSetting = true
          vc.isUserFemale = self.isUserFemale
        }
      }
    }else {
    
      let status = sender.isOn ? "online" : "offline"
      self.updateStatus(type: "login", status: status)
    }
    
  }
  
  @IBAction func btnNotificationClick(_ sender: UISwitch) {
    let status = sender.isOn ? "on" : "off"
    self.updateStatus(type: "notification", status: status)
  }
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return arrayTitles.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tblView.dequeueReusableCell(withIdentifier: "SettingVCCell", for: indexPath) as! SettingVCCell
    cell.lblTitle.text = arrayTitles[indexPath.row]
    return cell
  }
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 70
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let index = indexPath.row
    openViewController(controller: VCWebView.self, storyBoard: .homeStoryboard) { (vc) in
      
      switch index {
      case 0:
        vc.screenTitle = "About us"
        break;
      case 1:
        vc.screenTitle = "Contact us"
        break;
      case 2:
        vc.screenTitle = "Help"
        break;
      case 3:
        vc.screenTitle = "Privacy policy"
        break;
      case 4:
        vc.screenTitle = "Terms & Conditions"
        break;
      default:
        vc.screenTitle = "About us"
        break;
      }
    }
  }
}

extension SettingVC {
  
  func updateStatus(type: String, status: String) {
    
    SettingsViewModel.shared.updateLoginNotificationStatus(status: status, type: type) { response, isSuccess, message in
    
      
      guard let response = response, isSuccess else {
        Common.showAlert(alertMessage: message ?? "", alertButtons: ["Ok"]) { (bt) in
        }
        self.reverseBtnStatus(type: type, status: status)
        return
      }
      
      guard self.checkStatus(status: response.status, message: response.message) else {
        self.reverseBtnStatus(type: type, status: status)
        return
      }
      
      if type == "login" {
        UserDefault.shared.saveOnlineStatus(status: status)
      }else {
        UserDefault.shared.saveNotificationStatus(status: status)
      }
      
      
      
      Toast.shared.show(message: response.message ?? "Update Successfully", controller: self)
      
    }
  }
  
  func reverseBtnStatus(type: String, status: String) {
    
    if type == "login" {
      btnOnlineStatusToggle.isOn = status == "online" ? false : true
    }else {
      btnNotificationToggle.isOn = status == "on" ? false : true
    }
  }
}

class SettingVCCell: UITableViewCell {
  
  @IBOutlet weak var lblTitle: UILabel!
  
}
