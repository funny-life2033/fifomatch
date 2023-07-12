//
//  ComplaintViewController.swift
//  MSVilla
//
//  Created by apple on 04/09/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class MultiplePictureUploadVC: UIViewController  {
  
  
  @IBOutlet weak var topCameraBtn: UIButton!
  @IBOutlet weak var imageCollectionView: UICollectionView!
  @IBOutlet weak var roundedView: UIView!
  @IBOutlet weak var imgCollectionHeight: NSLayoutConstraint!
  
  var selectedIndex = -1
  
  var isProfileImgSelect = false
  var imgSelectedItem = [Int]()
  
  var selectedImages = [ProfileImage]()
  
  //var indexPath = IndexPath(item: 0, section: 0)
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    // Call the roundCorners() func right there.
    self.navigationController?.setNavigationBarHidden(true, animated: false)
    self.roundedView.roundCorners(corners: [.topLeft, .topRight], radius: 40)
  }
  
  @IBAction func btnOpenCamera(_ sender: Any) {
    selectedIndex = -1
    openPickerForImage(index: 0)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    imageCollectionView.dataSource = self
    imageCollectionView.delegate = self
  }
  
  override func viewWillAppear(_ animated: Bool) {
    
    self.navigationController?.setNavigationBarHidden(true, animated: false)
    self.tabBarController?.tabBar.isHidden = true
    self.navigationController?.navigationBar.isHidden = true
    
  }
  override func viewWillDisappear(_ animated: Bool) {
    self.tabBarController?.tabBar.isHidden = true
  }
  
  @IBAction func btnComplaintAction(_ sender: UIButton) {
    
  }
  @IBAction func backButtonAction(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
    //self.tabBarController?.tabBar.isHidden = true
    
  }
  
  
  fileprivate func openGallery() {
    if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
      let imagePicker = UIImagePickerController()
      imagePicker.delegate = self
      imagePicker.allowsEditing = true
      imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
      self.present(imagePicker, animated: true, completion: nil)
    } else {
      let alert  = UIAlertController(title: "Warning", message: "You don't have permission to access gallery.", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
      self.present(alert, animated: true, completion: nil)
    }
  }
  
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
  
  func openPickerForImage(index:Int) {
    
    let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
    alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
      self.openCamera()
    }))
    alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
      self.openGallery()
    }))
    //        alert.addAction(UIAlertAction(title: "Facebook", style: .default, handler: { _ in
    //            self.openFacebook()
    //        }))
    alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
    self.present(alert, animated: true, completion: nil)
  }
  
  @IBAction func saveProfileBtnAction(_ sender: Any) {
    
    selectedImages.removeAll()
    
    if isProfileImgSelect {
      if let profileImg = topCameraBtn.imageView?.image {
        selectedImages.append(ProfileImage(index: -1, image: profileImg))
      }
    }else {
        
        if imgSelectedItem.count < 3 {
            Common.showAlert(alertMessage: Messages.PROFILE_IMAGE_ERROR2.rawValue, alertButtons: ["Ok"]) { (bt) in
            }
        }else {
            Common.showAlert(alertMessage: Messages.PROFILE_IMAGE_ERROR1.rawValue, alertButtons: ["Ok"]) { (bt) in
            }
        }
        
      
      return
    }
    
    guard imgSelectedItem.count >= 3 else {
      Common.showAlert(alertMessage: Messages.PROFILE_IMAGE_ERROR.rawValue, alertButtons: ["Ok"]) { (bt) in
      }
      return
    }
    
    for index in imgSelectedItem {
      let indexPath = IndexPath(item: index, section: 0)
      if let cell = imageCollectionView.cellForItem(at: indexPath) as? InchargeImageCollectionViewCell {
        if let img = cell.imgeView.image {
          selectedImages.append(ProfileImage(index: index, image: img))
        }
        
      }
    }
    
    if selectedImages.count >= 3 {
      
      AppManager().startActivityIndicator(sender: self.view)
      
      CompleteProfileViewModel.shared.uploadProfileImages(images: selectedImages) { response, isSuccess, message in
        
        AppManager().stopActivityIndicator(self.view)
        
        guard let response = response, isSuccess else {
          Common.showAlert(alertMessage: message ?? "", alertButtons: ["Ok"]) { (bt) in
          }
          return
        }
        
        
        if let profileStatus = response.data?.profileComplete {
          UserDefault.shared.saveProfileUpdate(status: profileStatus)
        }
        
        self.openViewController(controller: SubcriptionViewController.self, storyBoard: .mainStoryBoard) { (vc) in
          /// vc.getData = self.getDataProfile
        }
        
      }
    }else {
      
      Common.showAlert(alertMessage: Messages.PROFILE_IMAGE_ERROR.rawValue, alertButtons: ["Ok"]) { (bt) in
      }
      
    }
  }
  
}

extension MultiplePictureUploadVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
    picker.dismiss(animated: true,completion: nil)
    
    
    
    if let img = info[.editedImage] as? UIImage {
      storeShowSelectedImage(img: img)
      
    }else if let img = info[.originalImage] as? UIImage {
      storeShowSelectedImage(img: img)
    }
    
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    print("picker cancel.")
    picker.dismiss(animated: true, completion: nil)
  }
  
  func storeShowSelectedImage(img: UIImage) {
    
    
    if selectedIndex == -1 {
    
      self.topCameraBtn.imageView?.contentMode = .scaleAspectFit
      self.topCameraBtn.setImage(img, for: .normal)
      self.isProfileImgSelect = true
      
//      if let row = selectedImages.firstIndex(where: {$0.index == selectedIndex}){
//        selectedImages[row] = .init(index: selectedIndex, image: img)
//      }else {
//        selectedImages.append(.init(index: selectedIndex, image: img))
//      }
      
      return
    }
    
    
    let indexpath = IndexPath(item: selectedIndex, section: 0)
    
//    if !selectedImages.isEmpty {
//      if let row = selectedImages.firstIndex(where: {$0.index == selectedIndex}){
//        selectedImages[row] = .init(index: selectedIndex, image: img)
//      }else {
//        selectedImages.append(.init(index: selectedIndex, image: img))
//      }
//
//    }else {
//      selectedImages.append(.init(index: selectedIndex, image: img))
//    }
    
    //debugPrint("SelectedImages Count = \(selectedImages.count)")
    
    guard let cell = imageCollectionView.cellForItem(at: indexpath) as? InchargeImageCollectionViewCell else { return }
    imgSelectedItem.append(selectedIndex)
    DispatchQueue.main.async {
      cell.imgeView.image = img
      cell.crossImageView.isHidden = false
      cell.hiddenImageView.isHidden = true
    }
  }
  
}



extension MultiplePictureUploadVC : UITextFieldDelegate {
  
  
  func convertImageToBase64String (img: UIImage) -> String {
    let imageData:NSData = img.jpegData(compressionQuality: 0.50)! as NSData //UIImagePNGRepresentation(img)
    let imgString = imageData.base64EncodedString(options: .init(rawValue: 0))
    
    return imgString
  }
}

extension MultiplePictureUploadVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
  
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: ((self.imageCollectionView.frame.width/3) - 10), height: 100)
  }
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 9
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = imageCollectionView.dequeueReusableCell(withReuseIdentifier: "InchargeImageCollectionViewCell", for: indexPath) as? InchargeImageCollectionViewCell else { return .init()}
    
    cell.removeBtn.tag = indexPath.item
    cell.removeBtn.addTarget(self, action: #selector(removeImage(_:)), for: .touchUpInside)
    
    return cell
  }
  
  
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
  
    selectedIndex = indexPath.row
    openPickerForImage(index: indexPath.row)
  }
  
  @objc func removeImage(_ sender: UIButton) {
    
    let index = sender.tag
    
//    if let row = selectedImages.firstIndex(where: {$0.index == index}){
      //selectedImages.remove(at: row)
      
      let indexpath = IndexPath(item: index, section: 0)
      guard let cell = imageCollectionView.cellForItem(at: indexpath) as? InchargeImageCollectionViewCell else { return }
      
      cell.imgeView.image = nil
      cell.crossImageView.isHidden = true
      cell.hiddenImageView.isHidden = false
      
      if let row = imgSelectedItem.firstIndex(where: {$0 == index}){
        imgSelectedItem.remove(at: row)
      }
      
    //}
  }
  
}


class InchargeImageCollectionViewCell: UICollectionViewCell {
  
  @IBOutlet weak var crossImageView: UIImageView!
  @IBOutlet weak var hiddenImageView: UIImageView!
  @IBOutlet weak var selectedImageView: UIImageView!
  @IBOutlet weak var imgeView: UIImageView!
  @IBOutlet weak var removeBtn: UIButton!
  
  override  func awakeFromNib() {
    super.awakeFromNib()

  }
  
  //    func confirgureCell(response:AllPhotos){
  //        self.selectedImageView.isHidden = false
  //        if let imageStr = response.name{
  //            print(imageStr)
  //
  //     let urlString = imageStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
  //            let imageUrl = URL(string: urlString ?? "")
  //            selectedImageView?.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: ""), options: .continueInBackground) { (img, err, cacheType, url) in
  //            }
  //        }
  ////
  //    }

}
