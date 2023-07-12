//
//  SubcriptionViewController.swift
//  FlowDating
//
//  Created by deepti on 09/04/21.
//

import UIKit
import StoreKit
import SwiftyStoreKit

class SubcriptionViewController: UIViewController {
  
  @IBOutlet weak var flowerLbl: UILabel!
  @IBOutlet weak var flowerOutlt: UIButton!
  @IBOutlet weak var subscriptionOutlt: UIButton!
  @IBOutlet weak var view2: UIView!
  @IBOutlet weak var view1: UIView!
  
  @IBOutlet weak var memberShipLbl: UILabel!
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var btnContinue: UIButton!
  
  @IBOutlet weak var skipBtn: UIButton!
  @IBOutlet weak var skipBtnHeight: NSLayoutConstraint!
  
  var iscomingFromHome = false
  
  var indexPathSelection = 0
  var isFlowerSelection = false
  
  var planDetails: [SubscriptionInfoData] = []
  
  let productIds = ["plan_id_01", "plan_id_02"]
  let productAmount = ["$15.95","$30.95"]
  
  var productsArray: Array<SKProduct> = []{
    didSet {
      self.collectionView.reloadData()
    }
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.delegate = self
    tableView.dataSource = self
    
    collectionView.delegate = self
    collectionView.dataSource = self
    
    if UserDefault.shared.getUserGender()?.lowercased() == "woman" {
      skipBtn.isHidden = false
      skipBtn.setTitle("Skip", for: .normal)
      skipBtnHeight.constant = 40
    }else {
      skipBtn.isHidden = true
      skipBtn.setTitle(nil, for: .normal)
      skipBtnHeight.constant = 0
    }
    
    getPlanDetails()
    getProductInfo()
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    
    self.navigationController?.setNavigationBarHidden(true, animated: false)
  }
  
  
  @IBAction func btnContinue(_ sender: Any) {
    //updatePlan()
    
    guard planDetails.count > indexPathSelection else { return }
    
    let selectedPlan = planDetails[indexPathSelection]
    
    if selectedPlan.slug == "premium" {
      setupInAppPurches(productId: "plan_id_02")
    }else {
      setupInAppPurches(productId: "plan_id_01")
    }
    
  }
  
  @IBAction func skipBtnAction(_ sender: UIButton) {
    
    let survayStatus = UserDefault.shared.getSurveyStatus()
    if survayStatus == 7 {
      appDelegate.setHomeView()
    }else {
      UserDefault.shared.saveSubscriptionStatus(status: true)
      self.openViewController(controller: CompleteypuProfileVC4.self, storyBoard: .mainStoryBoard) { (vc) in
      }
    }
    
    
    
  }
  
//  func updatePlan() {
//
//    guard planDetails.count > indexPathSelection else { return }
//
//    let selectedPlan = planDetails[indexPathSelection]
//
//    var planKey = ""
//
//    if selectedPlan.slug == "premium" {
//      planKey = "plan_id_02"
//    }else {
//      planKey = "plan_id_01"
//    }
//
//    let timeStamp = Int(Date().timeIntervalSince1970)
//    let transactionId = "trn_\(timeStamp)"
//
//    let params : [String: Any] =
//    [
//      "transaction_id" : transactionId,
//      "type" : "apple",
//      "product_id" : planKey,
//      "amount" : "50",
//      "transaction_datetime" : "2022-04-01 11:30:52",
//      "membership_type" : "month",
//      "membership_type_value" : 30
//
//    ]
//
//
//    AppManager().startActivityIndicator(sender: self.view)
//
//    SubscriptionInfoViewModel.shared.sendSubscriptionDetailsToServer(parameters: params) { response, isSuccess, message in
//
//      AppManager().stopActivityIndicator(self.view)
//
//      guard let response = response, isSuccess else {
//        Common.showAlert(alertMessage: message ?? "", alertButtons: ["Ok"]) { (bt) in
//        }
//        return
//      }
//
//      debugPrint("update purchase response \(response)")
//
//      UserDefault.shared.saveSubscriptionStatus(status: true)
//
//      self.openViewController(controller: CompleteypuProfileVC4.self, storyBoard: .mainStoryBoard) { (vc) in
//      }
//
//    }
//  }
  
  func updatePlan1(transId: String, transDate: String, productId: String, amount: String, membershipType: String) {
    
    
    let params : [String: Any] =
    [
      "transaction_id" : transId,
      "type" : "apple",
      "product_id" : productId,
      "amount" : amount,
      "transaction_datetime" : transDate,
      "membership_type" : "month",
      "membership_type_value" : membershipType
    ]
    
    AppManager().startActivityIndicator(sender: self.view)
    
    SubscriptionInfoViewModel.shared.sendSubscriptionDetailsToServer(parameters: params) { response, isSuccess, message in
      
      AppManager().stopActivityIndicator(self.view)
      
      guard let response = response, isSuccess else {
        Common.showAlert(alertMessage: message ?? "", alertButtons: ["Ok"]) { (bt) in
        }
        return
      }
      
      debugPrint("update purchase response \(response)")
      
      UserDefault.shared.saveSubscriptionStatus(status: true)

      self.openViewController(controller: CompleteypuProfileVC4.self, storyBoard: .mainStoryBoard) { (vc) in
      }
      
    }
  }
  
  @IBAction func backBtnAction(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
  }
  
  func getPlanDetails() {
    
    AppManager().startActivityIndicator(sender: self.view)
    
    SubscriptionInfoViewModel.shared.getSubscriptionDetails { response, isSuccess, message in
      
      AppManager().stopActivityIndicator(self.view)
      
      guard let response = response, isSuccess else {
        Common.showAlert(alertMessage: message ?? "", alertButtons: ["Ok"]) { (bt) in
        }
        return
      }
      
      self.planDetails = response
      self.collectionView.reloadData()
      self.tableView.reloadData()
    }
  }
  
}

extension SubcriptionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if UserDefault.shared.getUserGender()?.lowercased() == "woman" {
      return planDetails.count - 1
    }
    return planDetails.count
    
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
                                                    "cellMemberCollectionTop", for: indexPath) as! cellMemberCollectionTop
    if indexPathSelection == indexPath.row {
      cell.viewBackground.borderColor1 = UIColor(red: 255/255, green: 186/255, blue: 0/255, alpha: 1)
      cell.viewBackground.borderWidth1 = 1.5
      cell.view12.isHidden = false
    }
    else{
      cell.viewBackground.borderColor1 = .white
      cell.viewBackground.borderWidth1 = 1.5
      cell.view12.isHidden = true
    }
    cell.viewBackground.layer.shadowOpacity = 5
    cell.viewBackground.layer.shadowOffset = CGSize(width: 3, height: 3)
    cell.viewBackground.layer.shadowRadius = 15.0
    cell.viewBackground.layer.shadowColor = UIColor.black.cgColor
    
    let plan = planDetails[indexPath.item]
    
    let planName = plan.name?.split(separator: " ")
    
//    cell.lblTitlePlanPrice.text = "\(planName?.last ?? "")"
    cell.lblTitlePlan.text = (planName?.first)?.description
    
    if plan.slug == "premium" {
      cell.lblImage.image = UIImage(named: "premium-membership")
      
      if let premiumProduct = productsArray.first(where: {$0.productIdentifier == "plan_id_02"}) {
        cell.lblTitlePlanPrice.text = premiumProduct.localizedPrice ?? "$30.99"
      }else {
        cell.lblTitlePlanPrice.text = "$30.99"
      }
      
    }else {
      cell.lblImage.image = UIImage(named: "standard-membership")
      
      if let standardProduct = productsArray.first(where: {$0.productIdentifier == "plan_id_01"}) {
        let localPrice = standardProduct.localizedPrice ?? "$16.99"
        cell.lblTitlePlanPrice.text = localPrice
      }else {
        cell.lblTitlePlanPrice.text = "$16.99"
      }
    }
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    indexPathSelection = indexPath.row
    
    self.collectionView.reloadData()
    self.tableView.reloadData()
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: collectionView.frame.width/2 , height: collectionView.frame.height - 25)
    
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  
  
  
  //func memberShipApi(transaction_id :String, transactionDate:String, membershipType: String,type:String,product_id:String,amount:String,membership_type_value:String){
  //    var param = [String:Any]()
  //    param["transaction_id"]  = transaction_id
  //    param["type"]  = "apple"
  //    param["product_id"] = product_id
  //    param["amount"] = amount
  //        param["transaction_datetime"] =  transactionDate
  //    param["membership_type"] = membershipType
  //        param["membership_type_value"] = membership_type_value
  //    AppManager.init().hudShow()
  //    ServiceClass.sharedInstance.hitServicesForMembershipSubscription(param, completion: { (type:ServiceClass.ResponseType, parseData:JSON, errorDict:AnyObject?) in
  //        print_debug("response: \(parseData)")
  //        AppManager.init().hudHide()
  //        if (ServiceClass.ResponseType.kresponseTypeSuccess==type){
  //            //
  //            AppHelper.setBoolForKey(true, key: ServiceKeys.is_subscribed)
  //            self.navigationController?.popViewController(animated: true)
  //        }
  //
  //        else {
  //
  //            guard let dicErr = errorDict?["msg"] as? String else {
  //                return
  //            }
  //            Common.showAlert(alertMessage: (dicErr), alertButtons: ["Ok"]) { (bt) in
  //            }
  //
  //
  //        }
  //    })
  //}
  
}

extension SubcriptionViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "cellmemberShipPlan") as! cellmemberShipPlan
    
    guard planDetails.count > indexPathSelection else { return cell}
    let plan = planDetails[indexPathSelection]
    
    let planName = plan.name?.split(separator: " ")
    
    memberShipLbl.text = ((planName?.first)?.description ?? "Premium") + " Membership Benefits"
    
    cell.lblTitle.attributedText = plan.cmsBody?.convertToAttributedString()
    return cell
  }
}

extension UICollectionView {
  var visibleCurrentCellIndexPath: IndexPath? {
    for cell in self.visibleCells {
      let indexPath = self.indexPath(for: cell)
      return indexPath
    }
    
    return nil
  }
}

class cellmemberShipPlan : UITableViewCell {
  @IBOutlet weak var lblTitle: UILabel!
}

class cellMemberCollectionTop:UICollectionViewCell{
  
  @IBOutlet weak var viewBackground: UIView!
  
  @IBOutlet weak var view12: UIView!
  @IBOutlet weak var lblTitlePlanSelected: UILabel!
  @IBOutlet weak var lblImage: UIImageView!
  @IBOutlet weak var lblTitlePlan: UILabel!
  @IBOutlet weak var lblTitlePlanPrice: UILabel!
  @IBOutlet weak var lblTitlePlanDuration: UILabel!
  
}

//MARK: - In App Purchase Subscription
extension SubcriptionViewController {
  
  func getProductInfo() {
    
    SwiftyStoreKit.retrieveProductsInfo(["plan_id_01", "plan_id_02"]) { result in
      if let product = result.retrievedProducts.first {
        let priceString = product.localizedPrice!
        print("Product: \(product.localizedDescription), price: \(priceString)")
        self.productsArray = Array(result.retrievedProducts)
        
        if self.productsArray.count > 0
        {
          self.productsArray = self.productsArray.sorted(by: { (first, second) -> Bool in
            return Double("\(first.price)") ?? 0.0 < Double("\(second.price)") ?? 0.0
          })
        }
        
        print("self.productsArray-->",self.productsArray)
        
      }
      else if let invalidProductId = result.invalidProductIDs.first
      {
        print("Invalid product identifier: \(invalidProductId)")
      }
      else
      {
        print("Error: \(String(describing: result.error))")
      }
    }
  }
  
  func setupInAppPurches(productId: String) {
    AppManager().startActivityIndicator(sender: self.view)
    
    SwiftyStoreKit.purchaseProduct(productId, quantity: 1, atomically: true) { result in
      
      AppManager().stopActivityIndicator(self.view)
      
      switch result {
      case .success(let purchase):
        print("Purchase Success: \(purchase.productId)")
        let transectionID = purchase.transaction.transactionIdentifier
        let transectionDate = purchase.transaction.transactionDate
        //let transectionState = purchase.transaction.transactionState
        let productId = purchase.productId
        let purchaseDate = AppManager().convertDate(toString: transectionDate, dateFormate: "yyyy-MM-dd hh:mm a")
        
        if productId == "plan_id_01" {
          
          let productPrice = self.productsArray[0].localizedPrice ?? "$16.99"
          
          self.updatePlan1(transId: transectionID ?? "", transDate: purchaseDate ?? "", productId: productId, amount: productPrice, membershipType: "1")
          
        }else {
          
          let productPrice = self.productsArray[1].localizedPrice ?? "$30.99"
          
          self.updatePlan1(transId: transectionID ?? "", transDate: purchaseDate ?? "", productId: productId, amount: productPrice, membershipType: "1")
        }
        
        //self.verifySubcription(transectionID: transectionID!, date: changeDate!, productId: productId)
      case .error(let error):
        //                   AppManager.stopActivityIndicator()
        switch error.code {
        case .unknown: print("Unknown error. Please contact support")
        case .clientInvalid: print("Not allowed to make the payment")
        case .paymentCancelled: break
        case .paymentInvalid: print("The purchase identifier was invalid")
        case .paymentNotAllowed: print("The device is not allowed to make the payment")
        case .storeProductNotAvailable: print("The product is not available in the current storefront")
        case .cloudServicePermissionDenied: print("Access to cloud service information is not allowed")
        case .cloudServiceNetworkConnectionFailed: print("Could not connect to the network")
        case .cloudServiceRevoked: print("User has revoked permission to use this cloud service")
        default: print((error as NSError).localizedDescription)
        }
      }
    }
  }
  
//  func verifySubcription(transectionID: String, date: String, productId: String) {
//
//    let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: IAPHelper.sharedSecret)
//    SwiftyStoreKit.verifyReceipt(using: appleValidator) { result in
//      switch result {
//      case .success(let receipt):
//
//        let purchaseResult = SwiftyStoreKit.verifyPurchase(
//          productId: productId,
//          inReceipt: receipt)
//        switch purchaseResult {
//        case .purchased(_):
//          print("")
//
//          if self.productIds[self.indexPathSelection] == "plan_id_01"
//          { // Standard
//
//            let productId = self.productsArray[0].productIdentifier ?? self.productIds[0]
//            let productPrice = self.productsArray[0].localizedPrice ?? "15.99"
//
//            self.updatePlan1(transId: transectionID, transDate: date, productId: productId, amount: productPrice, membershipType: "1")
//
//          }
//          else if self.productIds[self.indexPathSelection] == "plan_id_02" { // Premium
//
//            let productId = self.productsArray[1].productIdentifier ?? self.productIds[1]
//            let productPrice = self.productsArray[1].localizedPrice ?? "30.99"
//
//            self.updatePlan1(transId: transectionID, transDate: date, productId: productId, amount: productPrice, membershipType: "1")
//
//          }
//
//        case .notPurchased:
//          print(" Not Purchased")
//
//
//        }
//      case .error(let error):
//        print(error.localizedDescription)
//
//      }
//    }
//  }
}
