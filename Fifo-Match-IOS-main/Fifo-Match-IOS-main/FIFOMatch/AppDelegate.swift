//
//  AppDelegate.swift
//  FIFOMatch
//
//  Created by Subhash Sharma on 01/03/22.
//

import UIKit
import IQKeyboardManagerSwift
import UserNotifications
import Firebase
import SwiftyStoreKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var tabBarController = UITabBarController()
  var navigationController:UINavigationController?
  var window: UIWindow?
  
  var timer : Timer? = nil {
      willSet {
          timer?.invalidate()
      }
  }
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    FirebaseApp.configure()
    Messaging.messaging().delegate = self
    registerForPushNotifications()
    IQKeyboardManager.shared.enable = true
    UINavigationBar.appearance().isTranslucent = false
    
    UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
    completeTransactions()
    updateUserTimeStamp()
    startTimer()
    
    debugPrint("Auth Token = \(UserDefault.shared.getSessionId())")
    debugPrint("FId = \( UserDefault.shared.getUserFirebaseId())")
    
    if UserDefault.shared.isUserLogin() {
      
      let profileStatus = UserDefault.shared.getProfileUpdateStatus()
      
      if profileStatus == 0 {
        openCompleteProfilePage()
      }else if profileStatus == 1 {
        openProfileUploadImagePage()
      }else if profileStatus == 2 {
        
        if UserDefault.shared.isSubscriptionPurchased() {
          if UserDefault.shared.getSurveyStatus() == 7 {
            checkFromNotification(launchOptions: launchOptions)
          }else {
            openSurveyPage()
          }
        }else {
          
          if UserDefault.shared.getSurveyStatus() == 7 {
            checkFromNotification(launchOptions: launchOptions)
          }else {
            openSubscriptionPage()
          }
          
        }
        
      }else {
        checkFromNotification(launchOptions: launchOptions)
      }
      
    }else {
      setinitalViewController()
    }
    return true
    
  }
  
  func applicationWillResignActive(_ application: UIApplication) {
    updateUserTimeStamp()
    stopTimer()
  }
  
  func applicationWillTerminate(_ application: UIApplication) {
    updateUserTimeStamp()
    stopTimer()
  }
  
  func updateUserTimeStamp() {
    
    let userFirebaseId = UserDefault.shared.getUserFirebaseId()
    if userFirebaseId != "" {
      let timestamp = Date.currentTimeStamp
      Constants.refs.databaseUsers.child(userFirebaseId).child("timestamp").setValue(timestamp)
    }
    
  }
  
  func startTimer() {
      stopTimer()
      guard self.timer == nil else { return }
    self.timer = Timer.scheduledTimer(timeInterval: 30.0, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)
  }
  
  func stopTimer() {
      guard timer != nil else { return }
      timer?.invalidate()
      timer = nil
  }
  
  @objc func updateTime() {
    updateUserTimeStamp()
  }
  
  func checkFromNotification(launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
    
    if let option = launchOptions {
      let info = option[UIApplication.LaunchOptionsKey.remoteNotification]
      if (info != nil) {
        return notificationVC()
      }
    }
    return setHomeView()
  }
  
  func completeTransactions() {
    
    SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
      for purchase in purchases {
        switch purchase.transaction.transactionState {
        case .purchased, .restored:
          if purchase.needsFinishTransaction {
            // Deliver content from server, then:
            SwiftyStoreKit.finishTransaction(purchase.transaction)
          }
          // Unlock content
        case .failed, .purchasing, .deferred:
          break // do nothing
        @unknown default:
          break
        }
      }
    }
    
  }
  
  func openCompleteProfilePage() {
    
    let storyBoard  = UIStoryboard(name: "Main", bundle: nil)
    if let vc1 = storyBoard.instantiateViewController(withIdentifier: "CompleteProfile1VC") as? CompleteProfile1VC {
      let nv4 = UINavigationController(rootViewController: vc1)
      
      self.window?.rootViewController = nv4
      self.window?.makeKeyAndVisible()
    }
    
  }
  
  func openProfileUploadImagePage() {
    
    let storyBoard  = UIStoryboard(name: "Main", bundle: nil)
    if let vc1 = storyBoard.instantiateViewController(withIdentifier: "MultiplePictureUploadVC") as? MultiplePictureUploadVC {
      let nv4 = UINavigationController(rootViewController: vc1)
      
      self.window?.rootViewController = nv4
      self.window?.makeKeyAndVisible()
    }
    
  }
  
  func openSubscriptionPage() {
    
    let storyBoard  = UIStoryboard(name: "Main", bundle: nil)
    if let vc1 = storyBoard.instantiateViewController(withIdentifier: "SubcriptionViewController") as? SubcriptionViewController {
      let nv4 = UINavigationController(rootViewController: vc1)
      
      self.window?.rootViewController = nv4
      self.window?.makeKeyAndVisible()
    }
    
  }
  
  func openSurveyPage() {
    
    let storyBoard  = UIStoryboard(name: "Main", bundle: nil)
    if let vc1 = storyBoard.instantiateViewController(withIdentifier: "CompleteypuProfileVC4") as? CompleteypuProfileVC4 {
      let nv4 = UINavigationController(rootViewController: vc1)
      nv4.isNavigationBarHidden = true
      self.window?.rootViewController = nv4
      self.window?.makeKeyAndVisible()
    }
    
  }
  
  func setinitalViewController() {
    //  ViewController
    let storyBoard  = UIStoryboard(name: "Main", bundle: nil)
    let vc1 = storyBoard.instantiateViewController(withIdentifier: "IntroductionVC") as! IntroductionVC
    let nv4 = UINavigationController(rootViewController: vc1)
    
    self.window?.rootViewController = nv4
    self.window?.makeKeyAndVisible()
  }
  
  func setHomeView(selectTab: Int = 0) {
    
    let storyBoard  = UIStoryboard(name: "HomeNewStoryboard", bundle: nil)
    
    let vc1 = storyBoard.instantiateViewController(withIdentifier: "VCHomeNew") as! VCHomeNew
    let nv1 = UINavigationController(rootViewController: vc1)
    
    var nv2 : UINavigationController!
    let vc2 = storyBoard.instantiateViewController(withIdentifier: "VCFavouritesSaved") as! VCFavouritesSaved
    nv2 = UINavigationController(rootViewController: vc2)
    
    let vc3 = storyBoard.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
    let nv3 = UINavigationController(rootViewController: vc3)
    
    
    let vc4 = storyBoard.instantiateViewController(withIdentifier: "LikeVC") as! LikeVC
    let nv4 = UINavigationController(rootViewController: vc4)
    
    let vc5 = storyBoard.instantiateViewController(withIdentifier: "profileVC") as! ProfileVC
    let nv5 = UINavigationController(rootViewController: vc5)
    
    
    nv1.tabBarItem = UITabBarItem.init(title: "", image: UIImage(named: "home-inactive")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "home-active")?.withRenderingMode(.alwaysOriginal))
    nv2.tabBarItem = UITabBarItem.init(title: "", image: UIImage(named: "save-inactive")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "save-tab-active")?.withRenderingMode(.alwaysOriginal))
    nv3.tabBarItem = UITabBarItem.init(title: "", image: UIImage(named: "message-inactive")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "message-active")?.withRenderingMode(.alwaysOriginal))
    nv4.tabBarItem = UITabBarItem.init(title: "", image: UIImage(named: "heart-inactive")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "heart-active")?.withRenderingMode(.alwaysOriginal))
    nv5.tabBarItem = UITabBarItem.init(title: "", image: UIImage(named: "profile-inactive")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "profile-active")?.withRenderingMode(.alwaysOriginal))
    
//    tabBarController.tabBar.cornerRadius = 30
    tabBarController.tabBar.dropShadow2()
    
    tabBarController.tabBar.layer.backgroundColor = UIColor.white.cgColor
    tabBarController.tabBar.shadowImage = nil
    
    
    tabBarController.viewControllers = [nv1, nv2, nv3, nv4, nv5]
    tabBarController.selectedIndex = selectTab
    
    if self.navigationController == nil {
      self.window?.rootViewController = self.tabBarController
      self.window?.makeKeyAndVisible()
    }else {
      self.navigationController?.present(tabBarController, animated: true, completion: {
        
      })
    }
    
  }
  
  func setHomeVC(hitHomeApi:Bool){
    let storyBoard  = UIStoryboard(name: "Main", bundle: nil)
    let vc1 = storyBoard.instantiateViewController(withIdentifier: "profileVC") as! ProfileVC
    let nv4 = UINavigationController(rootViewController: vc1)
    self.window?.rootViewController = nv4
    self.window?.makeKeyAndVisible()
  }
  
}


extension UIViewController {
  var topViewController: UIViewController? {
    return self.topViewController(currentViewController: self)
  }
  
  private func topViewController(currentViewController: UIViewController) -> UIViewController {
    if let tabBarController = currentViewController as? UITabBarController,
       let selectedViewController = tabBarController.selectedViewController {
      return self.topViewController(currentViewController: selectedViewController)
    } else if let navigationController = currentViewController as? UINavigationController,
              let visibleViewController = navigationController.visibleViewController {
      return self.topViewController(currentViewController: visibleViewController)
    } else if let presentedViewController = currentViewController.presentedViewController {
      return self.topViewController(currentViewController: presentedViewController)
    } else {
      return currentViewController
    }
  }
}

//MARK: - Firbase Messaging Delegate
extension AppDelegate: MessagingDelegate{
  
  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
    debugPrint("fcm_token = \(fcmToken ?? "")")
    if let token = fcmToken {
      UserDefault.shared.saveDeviceToken(token: token)
    }
  }
}

// MARK: - Notification Center Delegate
extension AppDelegate: UNUserNotificationCenterDelegate {
  
  func registerForPushNotifications() {
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
      (granted, error) in
      print("Permission granted: \(granted)")
      
      guard granted else {
        print(error ?? "Request Push Authorization error.")
        return
      }
      self.getNotificationSettings()
    }
  }
  
  func getNotificationSettings() {
    UNUserNotificationCenter.current().getNotificationSettings { (settings) in
      print("Notification settings: \(settings)")
      guard settings.authorizationStatus == .authorized else { return }
      
      DispatchQueue.main.async { UIApplication.shared.registerForRemoteNotifications() }
    }
  }
  
  func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    print("Fail To Register For Remote Notifications: \(error.localizedDescription)")
  }
  
  func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    print("notification Message = \(userInfo)")
    
    if application.applicationState == .active || application.applicationState == .background {
      
      if let payload = userInfo["aps"]{
        
        if let alertMessage = (payload as AnyObject).object(forKey: "alert"){
          
          let title = (alertMessage as AnyObject).object(forKey: "title") as? String ?? ""
          let body = (alertMessage as AnyObject).object(forKey: "body") as? String ?? ""
          
          
          if self.window?.rootViewController?.topViewController is ChatDetailVC {
            if title.contains("sent a message") {
              completionHandler(.noData)
              return
            }
          }
          
          let content = UNMutableNotificationContent()
          
          content.body = body
          content.title = title
          
          //content.badge = 1
          
          //getting the notification trigger
          //it will be called after 5 seconds
          let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
          
          //getting the notification request
          let request = UNNotificationRequest(identifier: "SimplifiedIOSNotification", content: content, trigger: trigger)
          
          UNUserNotificationCenter.current().delegate = self
          
          //adding the notification to notification center
          UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
          
        }
      }
      
    }else{
      completionHandler(.noData)
    }
  }
  
  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void){
    
    let userInfo = notification.request.content.userInfo
    
    if self.window?.rootViewController?.topViewController is ChatDetailVC {
      if let payload = userInfo["aps"]{
        
        if let alertMessage = (payload as AnyObject).object(forKey: "alert"){
          
          let title = (alertMessage as AnyObject).object(forKey: "title") as? String ?? ""
      
          if title.contains("sent a message") {
            completionHandler([])
            return
          }
          
        }
      }
    }
    
    
    completionHandler([UNNotificationPresentationOptions.alert,UNNotificationPresentationOptions.sound,UNNotificationPresentationOptions.badge])
  }
  
  func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void){
    
    
    print("receive notification userNotificationCenter didReceive = \(response) )")
    
    let userInfo = response.notification.request.content.userInfo
    print(userInfo)
    
    //NotificationCenter.default.post(name: Notification.Name("ReceiveData"), object: nil, userInfo: userInfo)
    
    notificationVC()
    
    completionHandler()
  }
  
  private func notificationVC()
  {
    
    let storyBoard  = UIStoryboard(name: "HomeNewStoryboard", bundle: nil)
    
    if let notificationVC = storyBoard.instantiateViewController(identifier: "VCNotificationScreen") as? VCNotificationScreen {
      
      notificationVC.openFromNotification = true
      let navController = UINavigationController(rootViewController: notificationVC)
      window?.rootViewController = navController
      window?.makeKeyAndVisible()
    
    }
  }
  
}
