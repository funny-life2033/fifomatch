//
//  ProfileImageVC.swift
//  FIFOMatch
//
//  Created by Harendra Singh Rathore on 25/04/22.
//

import UIKit

class ProfileImageVC: UIViewController {
  
  @IBOutlet weak var cameraIconImg: UIImageView!
  @IBOutlet weak var profileImgBtn: UIButton!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var collectionView: UICollectionView!
  
  var selectedIndex = -1
  var selectedImages = [ProfileImage]()
  
  var uploadedPhotos = [UserPhoto]()
  var imgSelectedItem = [Int]()
  
  private var isProfileSet = false
  private var userProfileSelect = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    getUserProfileDetails()
  }
  
  @IBAction func backBtnAction(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
  }
  
  @IBAction func profileImgBtnAction(_ sender: UIButton) {
//    selectedIndex = -1
//    openPickerForImage(index: 0)
  }
  
  func setImages() {
  
    for index in 0...uploadedPhotos.count - 1 {
      
      if index == 0 {
        if let profilePic = uploadedPhotos.first?.name {
          
          if let url = URL(string: profilePic) {
            profileImgBtn.kf.setImage(with: url, for: .normal)
            profileImgBtn.tag = uploadedPhotos[0].id ?? 0
          }
        }
        
      }else {
      
        let itemIndex = index - 1
        let indexPath = IndexPath(item: itemIndex, section: 0)
        if let cell = collectionView.cellForItem(at: indexPath) as? UserImageCell {
          
          if let profilePic = uploadedPhotos[index].name {
            
            if let url = URL(string: profilePic) {
                
              cell.tag = uploadedPhotos[index].id ?? 0
              cell.imgeView.kf.setImage(with: url)
              cell.crossImageView.isHidden = false
              cell.hiddenImageView.isHidden = true
              
            }
          }
        }
      }
    }
    
    debugPrint("uploadedImages = \(imgSelectedItem)")
    self.isProfileSet = true
  }
  
    func refershPreviousImages() {
        
        for index in 0...8 {
            let indexPath = IndexPath(item: index, section: 0)
            if let cell = collectionView.cellForItem(at: indexPath) as? UserImageCell {
              
                cell.tag = 0
                cell.imgeView.image = nil
                cell.crossImageView.isHidden = true
                cell.hiddenImageView.isHidden = false
            }
        }
    }
  
  @IBAction func uploadBtnAction(_ sender: UIButton) {
    
    selectedImages.removeAll()
    
    for index in imgSelectedItem {
      let indexPath = IndexPath(item: index, section: 0)
      if let cell = collectionView.cellForItem(at: indexPath) as? UserImageCell {
        if let img = cell.imgeView.image {
          selectedImages.append(ProfileImage(index: index, image: img))
        }
        
      }
    }
    
    debugPrint("Selected Image = \(selectedImages)")
    
    if !selectedImages.isEmpty {
      uploadImages()
    }
    
  }
  
  //MARK: - Get User Details
  func getUserProfileDetails() {
    
    AppManager().startActivityIndicator(sender: self.view)
    
    UserProfileViewModel.shared.getUserProfileDetails { response, isSuccess, message in
      
      AppManager().stopActivityIndicator(self.view)
      
      guard let response = response, isSuccess else {
        Common.showAlert(alertMessage: message ?? "", alertButtons: ["Ok"]) { (bt) in
        }
        return
      }
      
      guard self.checkStatus(status: response.status, message: response.message) else {
        return
      }
        
      self.refershPreviousImages()
      
      if let user = response.data {
        if let photos = user.photos {
          self.uploadedPhotos = photos
          
          for index in self.imgSelectedItem {
            let indexpath = IndexPath(item: index, section: 0)
            guard let cell = self.collectionView.cellForItem(at: indexpath) as? UserImageCell else { return }
            
            cell.imgeView.image = nil
            cell.crossImageView.isHidden = true
            cell.hiddenImageView.isHidden = false
          }
          
          
          
          self.imgSelectedItem.removeAll()
          self.setImages()
        }
      }
    }
  }
  
  //MARK: - Upload Images Api Call
  func uploadImages() {
    
    AppManager().startActivityIndicator(sender: self.view)
    
    CompleteProfileViewModel.shared.uploadProfileImages(images: selectedImages) { response, isSuccess, message in
      
      AppManager().stopActivityIndicator(self.view)
      
      guard let response = response, isSuccess else {
        Common.showAlert(alertMessage: message ?? "", alertButtons: ["Ok"]) { (bt) in
        }
        return
      }
      
      guard self.checkStatus(status: response.status, message: response.message) else {
        return
      }
      
      NotificationCenter.default.post(name: .updateProfile, object: nil)
      Toast.shared.show(message: "Updated Successfully", controller: self)
     // self.navigationController?.popViewController(animated: true)
      
      self.getUserProfileDetails()
      
    }
  }
  
}

extension ProfileImageVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 9
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserImageCell", for: indexPath) as? UserImageCell else { return .init()}
    
    cell.removeBtn.tag = indexPath.item
    cell.removeBtn.addTarget(self, action: #selector(removeImage(_:)), for: .touchUpInside)
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: ((self.collectionView.frame.width/3) - 10), height: 100)
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    guard let cell = collectionView.cellForItem(at: indexPath) as? UserImageCell else { return }
    
    if cell.crossImageView.isHidden == true {
      selectedIndex = indexPath.row
      openPickerForImage(index: indexPath.row)
    }
    
    
  }
  
  @objc func removeImage(_ sender: UIButton) {
    
    let totalImages = (uploadedPhotos.count - 1)
    
    guard totalImages > 3 else {
      Common.showAlert(alertMessage: "3 Photos are mandatory, Please add and upload one more image to delete last one", alertButtons: ["Ok"]) { (bt) in
      }
      return
    }
    
    let index = sender.tag
    
    let indexpath = IndexPath(item: index, section: 0)
    guard let cell = collectionView.cellForItem(at: indexpath) as? UserImageCell else { return }
    
    cell.imgeView.image = nil
    cell.crossImageView.isHidden = true
    cell.hiddenImageView.isHidden = false
    
    if let row = imgSelectedItem.firstIndex(where: {$0 == index}){
      imgSelectedItem.remove(at: row)
      debugPrint("selected Image = \(imgSelectedItem)")
    }
    
    let imageId = "\(cell.tag)"
    
    if imageId != "0" {
      deleteUserImage(by: imageId)
    }
    
  }
  
  func deleteUserImage(by id: String, hideToast: Bool = false) {
    
    AppManager().startActivityIndicator(sender: self.view)
    
    CompleteProfileViewModel.shared.deleteProfile(by: id) { response, isSuccess, message in
      
      AppManager().stopActivityIndicator(self.view)
      
      guard let response = response, isSuccess else {
        Common.showAlert(alertMessage: message ?? "", alertButtons: ["Ok"]) { (bt) in
        }
        return
      }
      
      guard self.checkStatus(status: response.status, message: response.message) else {
        return
      }
      
      NotificationCenter.default.post(name: .updateProfile, object: nil)
      if !hideToast {
        Toast.shared.show(message: "Image deleted successfully", controller: self)
      }
      
      self.getUserProfileDetails()
      
    }
  }
  
}

extension ProfileImageVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
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
    alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
    self.present(alert, animated: true, completion: nil)
  }
  
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
    
    let indexpath = IndexPath(item: selectedIndex, section: 0)
    
    guard let cell = collectionView.cellForItem(at: indexpath) as? UserImageCell else { return }
    imgSelectedItem.append(selectedIndex)

      cell.imgeView.image = img
      cell.crossImageView.isHidden = false
      cell.hiddenImageView.isHidden = true
      cell.tag = 0
      
    debugPrint("selected Image = \(imgSelectedItem)")
  }
  
}


class UserImageCell: UICollectionViewCell {
  
  @IBOutlet weak var crossImageView: UIImageView!
  @IBOutlet weak var hiddenImageView: UIImageView!
  @IBOutlet weak var selectedImageView: UIImageView!
  @IBOutlet weak var imgeView: UIImageView!
  @IBOutlet weak var removeBtn: UIButton!
  
  override  func awakeFromNib() {
    super.awakeFromNib()

  }

}
