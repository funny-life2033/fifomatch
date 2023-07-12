//
//  RemoveAccountVC.swift
//  FIFOMatch
//
//  Created by Subhash Sharma on 03/03/22.
//

import UIKit

class RemoveAccountVC: UIViewController {
  
  @IBOutlet weak var btnDactivate: UIButton!
  
  @IBOutlet weak var btnDelete: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationController?.navigationBar.isHidden = true
    // Do any additional setup after loading the view.
  }
  
  @IBAction func btnDeactivateClick(_ sender: UIButton) {
   
    self.alertBoxWithAction(message: Messages.DEACTIVATEACCOUNT.rawValue, btnTitle: "Deactivate") {
      self.deactivateAccount()
    }
  }
  
  @IBAction func btnDeleteClick(_ sender: UIButton) {
    
    self.alertBoxWithAction(message: Messages.DELETEACCOUNT.rawValue, btnTitle: "Delete") {
      self.logOutAccount(type: .deleteAccount)
    }
  }
  
  @IBAction func btnBAck(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
  }
  
  func logOutAccount(type: LogoutTypes) {
    
    AppManager().startActivityIndicator(sender: self.view)
    
    UserProfileViewModel.shared.logoutUser(type: type) { response, isSuccess, message in
      
      AppManager().stopActivityIndicator(self.view)
      
      guard let response = response, isSuccess else {
        Common.showAlert(alertMessage: message ?? "", alertButtons: ["Ok"]) { (bt) in
        }
        return
      }
      
      guard self.checkStatus(status: response.status, message: response.message) else {
        return
      }
      
      UserDefault.shared.logoutUser()
      appdelegate.setinitalViewController()
      
    }
  }
  
  func deactivateAccount() {
    
    AppManager().startActivityIndicator(sender: self.view)
    
    
    UserProfileViewModel.shared.deactivateAccount { response, isSuccess, message in
      
      AppManager().stopActivityIndicator(self.view)
      
      guard let response = response, isSuccess else {
        Common.showAlert(alertMessage: message ?? "", alertButtons: ["Ok"]) { (bt) in
        }
        return
      }
      
      guard self.checkStatus(status: response.status, message: response.message) else {
        return
      }
      
      UserDefault.shared.logoutUser()
      appdelegate.setinitalViewController()
      
    }
  }
  
}
