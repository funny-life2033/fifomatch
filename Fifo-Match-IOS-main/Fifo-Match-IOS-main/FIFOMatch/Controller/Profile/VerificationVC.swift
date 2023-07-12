//
//  VerificationVC.swift
//  FIFOMatch
//
//  Created by Harendra SIngh Rathore on 13/04/22.
//

import UIKit

class VerificationVC: UIViewController {
  
  @IBOutlet weak var succsfuleLbl: UILabel!
  @IBOutlet weak var submitView: UIView!
  @IBOutlet weak var verifySubmitView: UIView!
  
  @IBOutlet weak var baseView2: UIView!
  
  @IBOutlet var lbl1: UILabel!
  @IBOutlet var lbl2: UILabel!
  @IBOutlet var btn_Submit: UIButton!
  @IBOutlet var btn_retake: UIButton!
  
  @IBOutlet var img1: UIImageView!
  @IBOutlet var img2: UIImageView!
  @IBOutlet var img3: UIImageView!
  
  var verification1 = true
  var isVerify = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupUI()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    DispatchQueue.main.async {
      if let basev = self.baseView2 {
        basev.roundCorners(corners: [.topLeft, .topRight], radius: 15)
      }
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    
    if self.isVerify == 0 {
      self.submitView.isHidden = true
    }
    else if self.isVerify == 1 {
      self.submitView.isHidden = false
      succsfuleLbl.text = " You have successfully submitted your verification. When FIFO Match approves your request you will receive a notification."
    }
    else {
      succsfuleLbl.text = "Verified"
      self.submitView.isHidden = false
      succsfuleLbl.text = "You are verified now."
    }
    self.navigationController?.setNavigationBarHidden(true, animated: false)
  }
  
  func setupUI(){

      btn_retake.layer.borderColor = UIColor.lightGray.cgColor
      if verification1{
          img1.isHidden = false
          img2.isHidden = true
          img3.isHidden = true

          lbl1.text = "Copy This Gesture"
          lbl2.text = "Copy the gesture in the photo below and make a selfy. We will compare it with your profile picture. If they match then your profile will be verified."
          btn_retake.isHidden = true
          btn_Submit.setTitle("I'm ready", for: .normal)

      }else{
          img1.isHidden = true
          img2.isHidden = false
          img3.isHidden = false
          lbl1.text = "Do they Match?"
          lbl2.text = "If your photo looks like the sample then submit it for verification. FIFO will notify you as soon as your profile is verified."
          btn_retake.isHidden = false
          btn_Submit.setTitle("Submit", for: .normal)

      }
  }
  
  @IBAction func btn_Back(_ sender: Any) {
      self.navigationController?.popViewController(animated: true)
  }
  
  @IBAction func btn_Submit(_ sender: UIButton) {
      if verification1{
          openCamera()
      }else{
        uploadImage()
      }
  }
  
  @IBAction func btn_retake(_ sender: Any) {
      verification1 = true
      openCamera()
  }
  
}

extension VerificationVC {
  
  func uploadImage() {
    
    AppManager().startActivityIndicator(sender: self.view)
    
    let photoParams: [String: UIImage?] = ["photo": img3.image]
    
    CompleteProfileViewModel.shared.verificationProfileImages(images: photoParams) { response, isSuccess, message in
      
      AppManager().stopActivityIndicator(self.view)
      
      guard let response = response, isSuccess else {
        Common.showAlert(alertMessage: message ?? "Something went wrong", alertButtons: ["Ok"]) { (bt) in
        }
        return
      }
      
      guard self.checkStatus(status: response.status, message: response.message) else {
        return
      }
      
      NotificationCenter.default.post(name: .updateProfile, object: nil)
      self.navigationController?.popViewController(animated: true)
      
    }
  }
  
}

extension VerificationVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  fileprivate func openCamera() {
    if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
      let imagePicker = UIImagePickerController()
      imagePicker.delegate = self
      imagePicker.sourceType = UIImagePickerController.SourceType.camera
      imagePicker.allowsEditing = true
      self.present(imagePicker, animated: true, completion: nil)
    } else {
      let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
      self.present(alert, animated: true, completion: nil)
    }
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
    verification1 = false
    setupUI()
    
    picker.dismiss(animated: true,completion: nil)
    
    if let pickedImage = info[.editedImage] as? UIImage {
      img3.image = pickedImage
      
    }else if let pickedImage = info[.originalImage] as? UIImage {
      img3.image = pickedImage
    }
    
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    print("picker cancel.")
    picker.dismiss(animated: true, completion: nil)
  }
  
}
