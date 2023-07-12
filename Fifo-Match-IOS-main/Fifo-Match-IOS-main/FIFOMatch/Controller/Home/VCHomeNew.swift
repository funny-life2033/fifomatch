//
//  VCHomeNew.swift
//  FiFoMatch
//
//  Created by Diwakar Tak on 28/02/22.
//

import UIKit
import Kingfisher

class VCHomeNew: UIViewController {
  
  @IBOutlet weak var RoundedView: UIView!
  @IBOutlet weak var btnOnline: UIButton!
  @IBOutlet weak var btnPremium: UIButton!
  @IBOutlet weak var btnNew: UIButton!
  @IBOutlet weak var notAvailableView: UIView!
  
  @IBOutlet weak var viewOnline: UIView!
  @IBOutlet weak var viewPremium: UIView!
  @IBOutlet weak var viewNew: UIView!
  @IBOutlet weak var collectionViewMatch: UICollectionView!
  
  var premiumUsers = [UserInfo]()
  var onlineUsers = [UserInfo]()
  var newUsers = [UserInfo]()
  
  var selectedTab = 0
  
  var applyFilters = [String: Any]()
  
  private var refreshControl: UIRefreshControl!
  
  private var timer : Timer? = nil {
      willSet {
          timer?.invalidate()
      }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()

    self.navigationController?.setNavigationBarHidden(true, animated: false)
    
    setupCollectionView()
    refreshData()
    updateOnlineTime()
    startTimer()
    addObserver()
    checkApiInQueue()
    getData()
  }
  
  func refreshData(){
      
      refreshControl = UIRefreshControl()
      collectionViewMatch.refreshControl = refreshControl
      refreshControl.addTarget(self, action: #selector(getLatestDataFromServer), for: .valueChanged)
      refreshControl.tintColor=UIColor.black
      refreshControl.attributedTitle = NSAttributedString(string: "Fetching  Data ...", attributes: nil)
  }
  
  @objc func getLatestDataFromServer() {
    getData()
  }
  
  func setupCollectionView() {
    
    collectionViewMatch.delegate = self
    collectionViewMatch.dataSource = self
    
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    layout.scrollDirection = .vertical
    collectionViewMatch.collectionViewLayout = layout
  }
  
  
  @IBAction func notificationBtnAction(_ sender: UIButton) {
    openViewController(controller: VCNotificationScreen.self, storyBoard: .homeStoryboard) { (vc) in
    }
  }
  
  @IBAction func btnShowfilter(_ sender: Any) {
    let secondStoryBoard = UIStoryboard(name: "HomeNewStoryboard", bundle: nil)
    let vc = secondStoryBoard.instantiateViewController(withIdentifier: "VCFilter") as! VCFilter
    vc.applyFilterDelegate = self
    vc.previousApplyFilters = applyFilters
    self.present(vc, animated: true, completion: nil)
  }
  
  @IBAction func btnSelectOnline(_ sender: UIButton) {
    if sender.tag == 1 {
      viewOnline.backgroundColor = CustomColor.themeOrangecolor
      viewPremium.backgroundColor = .white
      viewNew.backgroundColor = .white
      selectedTab = 0
      notAvailableView.isHidden = onlineUsers.isEmpty ? false : true
    }else if sender.tag == 2{
      viewOnline.backgroundColor = .white
      viewPremium.backgroundColor = CustomColor.themeOrangecolor
      viewNew.backgroundColor = .white
      selectedTab = 1
      notAvailableView.isHidden = premiumUsers.isEmpty ? false : true
    }else if sender.tag == 3{
      viewOnline.backgroundColor = .white
      viewPremium.backgroundColor = .white
      viewNew.backgroundColor = CustomColor.themeOrangecolor
      selectedTab = 2
      notAvailableView.isHidden = newUsers.isEmpty ? false : true
    }
    
    DispatchQueue.main.async {
      self.collectionViewMatch.reloadData()
    }
    
  }
  
  func startTimer() {
      stopTimer()
      guard self.timer == nil else { return }
      self.timer = Timer.scheduledTimer(timeInterval: 600, target: self, selector: #selector(updateOnlineTime), userInfo: nil, repeats: true)
  }
  
  func stopTimer() {
      guard timer != nil else { return }
      timer?.invalidate()
      timer = nil
  }
  
  //MARK:- When subscription not to saved on server after purchase
  func checkApiInQueue() {
    if let params = UserDefault.shared.getPurchaseDetails() {
      self.updatePlan(params: params)
    }
  }
  
  func getData() {
    
    if self.refreshControl.isRefreshing {
        self.refreshControl.endRefreshing()
    }
    
    AppManager().startActivityIndicator(sender: self.view)
    
    HomeViewModel.shared.getHomeData(parameters: applyFilters) { response, isSuccess, message in
      
      AppManager().stopActivityIndicator(self.view)
      
      guard let response = response, isSuccess else {
        Common.showAlert(alertMessage: message ?? "", alertButtons: ["Ok"]) { (bt) in
        }
        return
      }
      
      guard self.checkStatus(status: response.status, message: response.message) else {
        return
      }
      
      guard let users = response.data else { return }
      if let premiumUsers = users.premiumUser {
        self.premiumUsers = premiumUsers
      }
      
      if let onlineUsers = users.onlineUsers {
        self.onlineUsers = onlineUsers
      }
      
      if let newUsers = users.newUsers {
        self.newUsers = newUsers
      }
      
      if self.selectedTab == 0 {
        self.notAvailableView.isHidden = self.onlineUsers.isEmpty ? false : true
      }else if self.selectedTab == 1{
        self.notAvailableView.isHidden = self.premiumUsers.isEmpty ? false : true
      }else {
        self.notAvailableView.isHidden = self.newUsers.isEmpty ? false : true
      }
      
      
      
      self.collectionViewMatch.reloadData()
      
    }
    
  }
  
  func updatePlan(params: [String: Any]) {
    
    SubscriptionInfoViewModel.shared.sendSubscriptionDetailsToServer(parameters: params) { response, isSuccess, message in
      
      guard let response = response, isSuccess else {
        Common.showAlert(alertMessage: message ?? "", alertButtons: ["Ok"]) { (bt) in
        }
        return
      }
      
      UserDefault.shared.removePurchaseDetails()
      debugPrint("update purchase response \(response)")
      UserDefault.shared.saveSubscriptionStatus(status: true)
    }
  }
  
}

//MARK:- Home get data Notifier
extension VCHomeNew {
  
  func addObserver() {
    NotificationCenter.default.addObserver(self, selector: #selector(onDidReceiveData(_:)), name: .refreshHome, object: nil)
  }
  
  @objc func onDidReceiveData(_ notification: Notification) {
    getData()
  }
}

extension VCHomeNew:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
    if selectedTab == 0 {
      return onlineUsers.count
    }else if selectedTab == 1 {
      return premiumUsers.count
    }else {
      return newUsers.count
    }
    
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellMatchHome", for: indexPath) as! CellMatchHome
    
    var users = [UserInfo]()
    
    if selectedTab == 0 {
      users = onlineUsers
    }else if selectedTab == 1 {
      users = premiumUsers
    }else {
      users = newUsers
    }
    
    let user = users[indexPath.item]
    
    if let userName = user.name {
      if let userAge = user.age {
        cell.lblName.text = userName + ", " + String(userAge)
      }else {
        cell.lblName.text = userName
      }
    }
    
    cell.lblAddress.text = user.countryName ?? "-"
    
    if let image = user.photo?.name {
      if let url = URL(string: image){
        
        cell.img.kf.indicatorType = .activity
        cell.img.kf.setImage(with: url)
      }
    }else {
      cell.img.image = nil
    }
    
    if let isUserVerified = user.userVerified?.isAccepted, isUserVerified  {
      cell.verifyImg.isHidden = false
    }else {
      cell.verifyImg.isHidden = true
    }
    
    cell.btnCross.tag = indexPath.row
    cell.btnFav.tag = indexPath.row
    cell.btnBookMark.tag = indexPath.row
    
    cell.btnCross.addTarget(self, action: #selector(cancelUser(_:)), for: .touchUpInside)
    cell.btnFav.addTarget(self, action: #selector(likeUser(_:)), for: .touchUpInside)
    cell.btnBookMark.addTarget(self, action: #selector(saveUser(_:)), for: .touchUpInside)
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    var userId = ""
    if selectedTab == 0 {
      userId = String(onlineUsers[indexPath.item].id ?? 0)
    }else if selectedTab == 1 {
      userId = String(premiumUsers[indexPath.item].id ?? 0)
    }else {
      userId = String(newUsers[indexPath.item].id ?? 0)
    }
    
    openViewController(controller: VCUserProfile.self, storyBoard: .homeStoryboard) { (vc) in
      vc.userId = userId
    }
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let collectionWidth = collectionViewMatch.frame.width
    return CGSize(width: collectionWidth/2 - 15 , height: 250)
  }
  
//  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//    return 10
//  }
//
//  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//    return 10
//  }
  
  @objc func cancelUser(_ sender: UIButton) {
    let index = sender.tag
    saveCancelUser(type: "cancel", index: index)
  }
  
  @objc func likeUser(_ sender: UIButton) {
    let index = sender.tag
    userLike(index: index, type: "like")
  }
  
  @objc func saveUser(_ sender: UIButton) {
    let index = sender.tag
    saveCancelUser(type: "saved", index: index)
  }
  
  func saveCancelUser(type: String, index: Int) {
    
    var users = [UserInfo]()
    
    if selectedTab == 0 {
      users = onlineUsers
    }else if selectedTab == 1 {
      users = premiumUsers
    }else {
      users = newUsers
    }
    
    guard let userId = users[index].id else {
      return
    }
    
    AppManager().startActivityIndicator(sender: self.view)
    
    HomeViewModel.shared.saveHideCancelUser(by: "\(userId)", type: type, apiType: "add") { response, isSuccess, error in
     
      AppManager().stopActivityIndicator(self.view)
      
      guard let response = response, isSuccess else {
        Common.showAlert(alertMessage: error ?? "Something went wrong", alertButtons: ["Ok"]) { (bt) in
        }
        return
      }
      
      guard self.checkStatus(status: response.status, message: response.message) else {
        return
      }
      
      Toast.shared.show(message: "User \(type) successfully", controller: self)
      self.getData()
      
    }
  }
  
  
  func userLike(index: Int, type: String) {
    
    var users = [UserInfo]()
    
    if selectedTab == 0 {
      users = onlineUsers
    }else if selectedTab == 1 {
      users = premiumUsers
    }else {
      users = newUsers
    }
    
    guard let userId = users[index].id else {
      return
    }
    
    AppManager().startActivityIndicator(sender: self.view)
    
    HomeViewModel.shared.likelUser(by: "\(userId)", type: type) { response, isSuccess, error in
      
      AppManager().stopActivityIndicator(self.view)
      
      guard let response = response, isSuccess else {
        Common.showAlert(alertMessage: error ?? "Something went wrong", alertButtons: ["Ok"]) { (bt) in
        }
        return
      }
      
      guard self.checkStatus(status: response.status, message: response.message) else {
        return
      }
      
      Toast.shared.show(message: "User like successfully", controller: self)
      self.getData()
      
    }
  }
  
  @objc func updateOnlineTime() {
    
    HomeViewModel.shared.updateOnlineTime { isSuccess, error in
      
      if isSuccess {
        debugPrint(" Time update successfully")
      }else {
//        Common.showAlert(alertMessage: error ?? "Something went wrong", alertButtons: ["Ok"]) { (bt) in
//        }
        debugPrint(error ?? "Something went wrong")
      }
    }
    
  }
  
}

extension VCHomeNew: ApplyFilterDelegate {

  func applyFilter(params: [String : Any]) {
    self.applyFilters = params
    getData()
  }
  
}

class CellMatchHome: UICollectionViewCell {
  
  @IBOutlet weak var viewBackground: UIView!
  @IBOutlet weak var img: UIImageView!
  @IBOutlet weak var lblName: UILabel!
  @IBOutlet weak var lblAddress: UILabel!
  
  @IBOutlet weak var btnCross: UIButton!
  @IBOutlet weak var btnFav: UIButton!
  @IBOutlet weak var btnBookMark: UIButton!
  @IBOutlet weak var verifyImg: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    self.layer.masksToBounds = false
    self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.09).cgColor
    self.layer.shadowOpacity = 1
    self.layer.shadowRadius = 2
    self.layer.shadowOffset = CGSize(width: 0, height: 1)
  }
  
  
  
  
}
