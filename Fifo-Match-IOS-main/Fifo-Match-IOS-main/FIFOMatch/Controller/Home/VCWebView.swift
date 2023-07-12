//
//  VCWebView.swift
//  FIFOMatch
//
//  Created by octal-mac206 on 08/03/22.
//

import UIKit
import WebKit

class VCWebView: UIViewController {
  
  @IBOutlet weak var webView: WKWebView!
  @IBOutlet weak var lblScreenTitle: UILabel!
  
  var screenTitle = String()
  var content = ""
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationController?.isNavigationBarHidden = true
    lblScreenTitle.text = screenTitle
    webView.backgroundColor = .white
    getContent()
  }
  
  @IBAction func btnBack(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
  }
  
  
  func getContent() {
    
    AppManager().startActivityIndicator(sender: self.view)
    
    SettingsViewModel.shared.getHtmlData(from: screenTitle) { response, isSuccess, message in
      AppManager().stopActivityIndicator(self.view)
      
      
      guard isSuccess else {
        Common.showAlert(alertMessage: message ?? "Something went wrong", alertButtons: ["Ok"]) { (bt) in
        }
        return
      }
      
      debugPrint("response html = \(response)")
      self.webView.loadHTMLString(response, baseURL: nil)
      
    }
    
  }
}
