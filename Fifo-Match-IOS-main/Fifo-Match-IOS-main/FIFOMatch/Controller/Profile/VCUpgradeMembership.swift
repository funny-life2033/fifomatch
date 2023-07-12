//
//  VCUpgradeMembership.swift
//  FIFOMatch
//
//  Created by octal-mac206 on 07/03/22.
//


import UIKit
import StoreKit
import SwiftyStoreKit

class VCUpgradeMembership: UIViewController {
  
  @IBOutlet weak var tableViewUpgradeMemberShip: UITableView!
  @IBOutlet weak var upgradeMembershipBtn: UIButton!
  
  var selectPlan = false
  var isUserFemale = false
  var activePlan: ActivePlanData?
  var allPlanDetails: SubscriptionInfoData?
  
  let productIds = ["plan_id_01", "plan_id_02"]
  let productAmount = ["$15.95","$30.95"]
  
  var productsArray: Array<SKProduct> = []{
    didSet {
      self.tableViewUpgradeMemberShip.reloadData()
    }
  }
  var isActivePlanPremium = false
  var isFromSetting = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationController?.navigationBar.isHidden = true
    tableViewUpgradeMemberShip.delegate = self
    tableViewUpgradeMemberShip.dataSource = self
    tableViewUpgradeMemberShip.isHidden = true
    upgradeMembershipBtn.isHidden = true
    getUserActivePlan()
    getProductInfo()
  }
  
  @IBAction func btnUpgradeMemberShip(_ sender: Any) {
    //        openViewController(controller: CompleteypuProfileVC4.self, storyBoard: .mainStoryBoard) { (vc) in
    //
    //        }
    
    setupInAppPurches(productId: "plan_id_02")
    
  }
  
  @IBAction func btnBack(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
  }
  
  @objc func selectPlan(sender: UIButton){
    if selectPlan{
      selectPlan = false
    }else{
      selectPlan = true
    }
    tableViewUpgradeMemberShip.reloadData()
  }
  
  @objc func renewMemberShip(_ sender: UIButton){
    //alert(message: "Update Soon")
  }
  
  func getUserActivePlan() {
    
    AppManager().startActivityIndicator(sender: self.view)
    
    HomeViewModel.shared.getUserActivePlan { response, isSuccess, message in
      
      AppManager().stopActivityIndicator(self.view)
      guard let response = response, isSuccess else {
        
        Common.showAlert(alertMessage: message ?? "Something went wrong", alertButtons: ["Ok"]) { (bt) in }
        return
      }
      
      guard self.checkStatus(status: response.status, message: response.message) else {
        return
      }
      
      self.activePlan = response.data
      
      self.getPlanDetails()
     
    }
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
      
      if let activePlan = self.activePlan {
        if activePlan.plan_id == "plan_id_01" {
          if let row = response.firstIndex(where: {$0.slug == "premium"}) {
            self.allPlanDetails = response[row]
            self.isActivePlanPremium = false
            self.upgradeMembershipBtn.isHidden = false
          }
        }else if let row = response.firstIndex(where: {$0.slug == "standard"}) {
          self.allPlanDetails = response[row]
          self.isActivePlanPremium = true
          self.upgradeMembershipBtn.isHidden = true
          
          //14-06-2022 checking expiry date for check subscription expired
          if let expireDate = activePlan.end_datetime {
            if let differenceDays = expireDate.getDays() {
              if differenceDays < 0 {
                self.upgradeMembershipBtn.isHidden = false
              }
            }
          }
          
        }
        
      }else {
        if let row = response.firstIndex(where: {$0.slug == "premium"}) {
          self.allPlanDetails = response[row]
          self.upgradeMembershipBtn.isHidden = false
        }
      }
      self.tableViewUpgradeMemberShip.isHidden = false
      self.tableViewUpgradeMemberShip.reloadData()
    }
  }
  
}

extension VCUpgradeMembership:UITableViewDelegate,UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    if self.isActivePlanPremium {
      return 1
    }
    return 3
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    if indexPath.row == 0 {
      let cell = tableView.dequeueReusableCell(withIdentifier: "CellActiveMemberShip") as! CellActiveMemberShip
      
      if let activePlan = activePlan  {
        
        var planName = ""
        var planPrice = ""
        
        if activePlan.plan_id == "plan_id_01" { // Standard
          
          if let standardProduct = productsArray.first(where: {$0.productIdentifier == "plan_id_01"}) {
            let localPrice = standardProduct.localizedPrice ?? "$16.99"
            planPrice = localPrice
          }else {
            planPrice = "$16.99"
          }
          
          planName = "Standard"
          
          cell.planImg.setImage(UIImage(named: "standard-membership"), for: .normal)
        
        }else if activePlan.plan_id == "plan_id_02" { // Premium
          
          if let premiumProduct = productsArray.first(where: {$0.productIdentifier == "plan_id_02"}) {
            planPrice = premiumProduct.localizedPrice ?? "$30.99"
          }else {
            planPrice = "$30.99"
          }
          
          planName = "Premium"
    
          cell.planImg.setImage(UIImage(named: "premium-membership"), for: .normal)
        }
        
        cell.lblMemberShipTitle.text = planName + " Membership"
        cell.lblMemberShipPrice.text = planPrice
        
        if let expireDate = activePlan.end_datetime {
          if let differenceDays = expireDate.getDays() {
            
            if differenceDays == 0 || differenceDays < 0 {
              cell.lblMemberExpires.text = "Expired"
            }else {
              cell.lblMemberExpires.text = "Expire in next \(differenceDays) days."
            }
            
          }
        }
        
      }else {
        if isUserFemale {
          cell.lblMemberShipTitle.text = "Standard Membership"
          cell.lblMemberShipPrice.text = "Free"
          cell.lblMemberExpires.text = ""
          cell.lblPerMonth.isHidden = true
        }
      }
      
      cell.btnRenewMemberShip.addTarget(self, action: #selector(renewMemberShip(_ :)), for: .touchUpInside)
      
      return cell
    }else if indexPath.row == 1 {
      let cell = tableView.dequeueReusableCell(withIdentifier: "CellUpgradeMemberShip") as! CellUpgradeMemberShip
      
      if selectPlan{
        cell.selectPlanBtn.setImage(UIImage(named: "tick"), for: .normal)
        cell.selectPlanBtn.backgroundColor = .white
      }else{
        cell.selectPlanBtn.setImage(UIImage(named: "WhiteCheckBox"), for: .normal)
        cell.selectPlanBtn.backgroundColor = .clear
        
      }
      cell.selectPlanBtn.addTarget(self, action: #selector(selectPlan(sender:)), for: .touchUpInside)
      
      if let plan = allPlanDetails {
        let planName = plan.name?.split(separator: " ")
        
        //cell.lblMemberShipPrice.text = "\(planName?.last ?? "")"
        cell.lblMemberShipTitle.text = (planName?.first)?.description
        
        if plan.slug == "premium" {
          
          if let premiumProduct = productsArray.first(where: {$0.productIdentifier == "plan_id_02"}) {
            cell.lblMemberShipPrice.text = premiumProduct.localizedPrice ?? "$30.99"
          }else {
            cell.lblMemberShipPrice.text = "$30.99"
          }
          
          cell.planImg.setImage(UIImage(named: "premium-membership"), for: .normal)
          cell.upgradeMembershipLbl.text = "Upgrade to Premium Membership"
          cell.membershipBenefitsLbl.text = "Premium Membership Benefits"
        }else {
          cell.planImg.setImage(UIImage(named: "standard-membership"), for: .normal)
          cell.upgradeMembershipLbl.text = "Upgrade to Standard Membership"
          cell.membershipBenefitsLbl.text = "Standard Membership Benefits"
        }
      }
      
      return cell
    }else{
      let cell = tableView.dequeueReusableCell(withIdentifier: "CellMemberShipBenifits") as! CellMemberShipBenifits
      
      if let plan = allPlanDetails {
        cell.lblTitle.attributedText = plan.cmsBody?.convertToAttributedString()
      }
      return cell
    }
    
  }
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.row == 0 {
      return 232
    }else if indexPath.row == 1 {
      
      if self.isActivePlanPremium {
        return 0
      }
      return 230
      
    }else{
      
      if self.isActivePlanPremium {
        return 0
      }
      return UITableView.automaticDimension
    }
  }
  
}
extension UICollectionView {
  var visibleCurrentCellIndexPath1: IndexPath? {
    for cell in self.visibleCells {
      let indexPath = self.indexPath(for: cell)
      return indexPath
    }
    
    return nil
  }
}


class CellActiveMemberShip : UITableViewCell{
  
  @IBOutlet weak var viewBackground: GradientView!
  
  @IBOutlet weak var planImg: UIButton!
  @IBOutlet weak var lblMemberShipTitle: UILabel!
  @IBOutlet weak var lblMemberShipPrice: UILabel!
  @IBOutlet weak var lblPerMonth: UILabel!
  @IBOutlet weak var lblMemberExpires: UILabel!
  @IBOutlet weak var btnRenewMemberShip: UIButton!
  
  
}


class CellUpgradeMemberShip : UITableViewCell{
  
  @IBOutlet weak var upgradeMembershipLbl: UILabel!
  @IBOutlet weak var membershipBenefitsLbl: UILabel!
  
  @IBOutlet weak var viewBackground: GradientView!
  @IBOutlet weak var lblMemberShipTitle: UILabel!
  @IBOutlet weak var lblMemberShipPrice: UILabel!
  @IBOutlet weak var selectPlanBtn: UIButton!
  @IBOutlet weak var planImg: UIButton!
  
  override func layoutSubviews() {
    selectPlanBtn.setTitle("", for: .normal)
  }
  
}

class CellMemberShipBenifits : UITableViewCell{
  
  @IBOutlet weak var lblImage: UIImageView!
  @IBOutlet weak var lblTitle: UILabel!
  
}


//MARK: - In App Purchase Subscription
extension VCUpgradeMembership {
  
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
        let changeDate = AppManager().convertDate(toString: transectionDate, dateFormate: "yyyy-MM-dd hh:mm a")
        
        let productPrice = self.productsArray[1].localizedPrice ?? "30.99"
        
        self.updatePlan(transId: transectionID ?? "", transDate: changeDate ?? "", productId: productId, amount: productPrice, membershipType: "1")
        
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
  
  
  func updatePlan(transId: String, transDate: String, productId: String, amount: String, membershipType: String) {
    
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
    
    UserDefault.shared.savePurchaseDetails(parameters: params)
    
    AppManager().startActivityIndicator(sender: self.view)
    
    SubscriptionInfoViewModel.shared.sendSubscriptionDetailsToServer(parameters: params) { response, isSuccess, message in
      
      AppManager().stopActivityIndicator(self.view)
      
      guard let response = response, isSuccess else {
        Common.showAlert(alertMessage: message ?? "", alertButtons: ["Ok"]) { (bt) in
        }
        return
      }
      
      UserDefault.shared.removePurchaseDetails()
      debugPrint("update purchase response \(response)")
      
      UserDefault.shared.saveSubscriptionStatus(status: true)
      let updatePlan = ["updatePlan": true]
      NotificationCenter.default.post(name: .updateProfile, object: nil, userInfo: updatePlan)
      
      if self.isFromSetting {
        self.navigationController?.popToRootViewController(animated: true)
      }else {
        self.navigationController?.popViewController(animated: true)
      }
      
    }
  }
}
