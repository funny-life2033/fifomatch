//
//  Common.swift
//  BypassQ
//
//  Created by Pankaj Tahiliani on 17/07/17.
//  Copyright © 2017 Dotsquares. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration
import AVKit
import AVFoundation
import CoreLocation
import LocalAuthentication

class Common: NSObject {
  
  static func isConnectedToNetwork() -> Bool {
    var zeroAddress = sockaddr_in()
    zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
    zeroAddress.sin_family = sa_family_t(AF_INET)
    let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
      $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
        SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
      }
    }
    if(defaultRouteReachability == nil){
      return false
    }
    var flags : SCNetworkReachabilityFlags = []
    if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
      return false
    }
    
    let isReachable = flags.contains(.reachable)
    let needsConnection = flags.contains(.connectionRequired)
    
    return (isReachable && !needsConnection)
  }
  static func dateformater()->DateFormatter{
    let df = DateFormatter()
    df.timeZone = NSTimeZone.system
    df.locale = NSLocale.current
    return df
  }
  static func shakeView(viewToShake:UIView){
    let animation = CABasicAnimation(keyPath: "position")
    animation.duration = 0.07
    animation.repeatCount = 4
    animation.autoreverses = true
    animation.fromValue = NSValue(cgPoint: CGPoint(x: viewToShake.center.x - 10, y: viewToShake.center.y))
    animation.toValue = NSValue(cgPoint: CGPoint(x: viewToShake.center.x + 10, y: viewToShake.center.y))
    viewToShake.layer.add(animation, forKey: "position")
  }
  static func UTCToLocal(date:String, time: Bool) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
    
    let dt = dateFormatter.date(from: date)
    dateFormatter.timeZone = TimeZone.current
    if time {
      dateFormatter.dateFormat = "h:mm a"
    }else {
      dateFormatter.dateFormat = "dd/MM/yy"
    }
  
    return dateFormatter.string(from: dt!)
  }
  
  static func getDateFromString(date:String, format : String) -> Date? {
    let dateFormator = DateFormatter()
    dateFormator.locale =  Locale.init(identifier: "en_US_POSIX")
    dateFormator.dateFormat = format
    let dt = dateFormator.date(from: date)
    if (dt == nil){
      return nil
    }else{
      return dt
    }
  }
  
  static func getStringFromDate(date:Date, format : String) -> String {
    let dateFormator = DateFormatter()
    dateFormator.locale =  Locale.init(identifier: "en_US_POSIX")
    dateFormator.dateFormat = format
    let dt = dateFormator.string(from: date)
    return dt
  }
  
  static func getTopViewController() -> UIViewController? {
    
    
    if var topController = appdelegate.window?.rootViewController {
      while let presentedViewController = topController.presentedViewController {
        topController = presentedViewController
      }
      return topController
    }
    return nil
  }
  //
  //    static func getDeviceToken() -> String {
  //        return kUserDefault.value(forKey: UserDefaultKey.DEVICE_TOKEN.rawValue) as? String ?? "ios123"
  //    }
  
  //    static func setDeviceToken(token:String){
  //        kUserDefault.set(token , forKey: UserDefaultKey.DEVICE_TOKEN.rawValue)
  //    }
  
  
  
  
  // MARK:- Show Alert
  static func showAlert(alertMessage: String?, alertButtons: [String]?, callback: @escaping (String?) -> Void) {
    let alertController = UIAlertController(title: kAppName, message: alertMessage, preferredStyle:.alert)
    
    for item in alertButtons! {
      let alertButton = UIAlertAction(title: item, style: .default, handler: { (action) -> Void in
        callback( item);
      })
      alertController.addAction(alertButton)
    }
    _ = false
    
    Common.getTopViewController()?.present(alertController, animated: true, completion: nil)
  }
  
  static func showAlert( alertMessage: String?, alertButtons: [String]?,  alertStyle: UIAlertController.Style?, callback: @escaping ( String?) -> Void) {
    let alertController = UIAlertController(title: kAppName, message: alertMessage, preferredStyle: alertStyle ?? .alert)
    
    for item in alertButtons! {
      let alertButton = UIAlertAction(title: item, style: .default, handler: { (action) -> Void in
        callback( item);
      })
      alertController.addAction(alertButton)
    }
    
    if alertStyle == .actionSheet {
      let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
      alertController.addAction(cancelButton)
    }
    Common.getTopViewController()?.present(alertController, animated: true, completion: nil)
  }
  
  static func showTextAlert( alertMessage: String?, alertButton: String?,  alertStyle: UIAlertController.Style?, callback: @escaping ( String?) -> Void) {
    let alertController = UIAlertController(title: kAppName, message: alertMessage, preferredStyle: alertStyle ?? .alert)
    alertController.addTextField { (textField) in
      textField.text = ""
    }
    
    let alertButton = UIAlertAction(title: alertButton, style: .default, handler: { (action) -> Void in
      let textField = alertController.textFields![0]
      callback( textField.text!);
    })
    alertController.addAction(alertButton)
    
    let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    alertController.addAction(cancelButton)
    
    Common.getTopViewController()?.present(alertController, animated: true, completion: nil)
  }
  
  
  // MARK:- PREFERANCE
  /*static func getUserInfo() -> RegisterModel? {
   if let savedPerson = kUserDefault.object(forKey: userLoginDBKey) as? Data {
   let decoder = JSONDecoder()
   if let loginInfo = try? decoder.decode(RegisterModel.self, from: savedPerson) {
   return loginInfo
   }
   }
   return nil
   }*/
  
  
  //MARK:- processing image
  static func compressImage(image: UIImage) -> Data? {
    var compression: CGFloat = 0.5
    let maxCompression: CGFloat = 0.30
    let maxFileSize = 250 * 1024
    let kImage = Common.fixrotation(image: image)
    var imageData = kImage.jpegData(compressionQuality: compression)
    while imageData!.count > maxFileSize && compression > maxCompression {
      compression -= 1.5
      imageData = kImage.jpegData(compressionQuality: compression)
    }
    
    return imageData
  }
  
  
  // helper function (compressImage)
  static func fixrotation(image: UIImage) -> UIImage {
    if image.imageOrientation == .up {
      return image
    }
    //        var transform = CGAffineTransformIdentity
    var transform = CGAffineTransform.identity
    switch image.imageOrientation {
    case .down, .downMirrored:
      transform = transform.translatedBy(x: image.size.width, y: image.size.height)
      transform = transform.rotated(by: CGFloat(Double.pi))
    case .left, .leftMirrored:
      transform = transform.translatedBy(x: image.size.width, y: 0)
      transform = transform.rotated(by: CGFloat(Double.pi/2))
    case .right, .rightMirrored:
      transform = transform.translatedBy(x: 0, y: image.size.height)
      transform = transform.rotated(by: CGFloat(-Double.pi/2))
    case .up, .upMirrored:
      break
    @unknown default:
      break
    }
    
    switch image.imageOrientation {
    case .upMirrored, .downMirrored:
      transform = transform.translatedBy(x: image.size.width, y: 0)
      transform = transform.scaledBy(x: -1, y: 1)
    case .leftMirrored, .rightMirrored:
      transform = transform.translatedBy(x: image.size.height, y: 0)
      transform = transform.scaledBy(x: -1, y: 1)
    case .up, .down, .left, .right:
      break
    @unknown default:
      break
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    let ctx = CGContext(data: nil, width: Int(ceil(image.size.width)), height: Int(ceil(image.size.height)), bitsPerComponent: image.cgImage!.bitsPerComponent, bytesPerRow: 0, space: image.cgImage!.colorSpace!, bitmapInfo: image.cgImage!.bitmapInfo.rawValue)
    ctx!.concatenate(transform)
    switch image.imageOrientation {
    case .left, .leftMirrored, .right, .rightMirrored:
      // Grr...
      //            CGContextDrawImage(ctx, CGRectMake(0, 0, image.size.height, image.size.width), image.cgImage)
      //CGContextDrawImage(ctx, CGRect(x: 0, y: 0, width: image.size.height, height: image.size.width), image.cgImage)
      //CGContextDrawImage(ctx, CGRect(x: 0, y: 0, width: image.size.height, height: image.size.width), image.cgImage)
      ctx?.draw(image.cgImage!, in: CGRect(x: 0, y: 0, width: image.size.height, height: image.size.width))
    default:
      //CGContextDrawImage(ctx, CGRectMake(0, 0, image.size.width, image.size.height), image.cgImage)
      ctx?.draw(image.cgImage!, in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
    }
    
    // And now we just create a new UIImage from the drawing context
    let cgimg = ctx!.makeImage()
    let img = UIImage(cgImage: cgimg!)
    return img
  }
  
  //decode codable
  static func jsonData(obj:Any) -> Data{
    let jsonData = try? JSONSerialization.data(withJSONObject: obj, options: [])
    let reqJSONStr = String(data: jsonData!, encoding: .utf8)
    let data = reqJSONStr?.data(using: .utf8)
    
    return data!
  }
  
  static func setTLBRForView(view:UIView, superview:UIView, padding:UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)){
    view.translatesAutoresizingMaskIntoConstraints = false;
    superview.addConstraints([
      NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1.0, constant: padding.top),
      NSLayoutConstraint(item: view, attribute: .left, relatedBy: .equal, toItem: superview, attribute: .left, multiplier: 1.0, constant: padding.left),
      NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: superview, attribute: .bottom, multiplier: 1.0, constant: padding.bottom),
      NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal, toItem: superview, attribute: .right, multiplier: 1.0, constant: padding.right)
    ]);
  }
  
  static func getOrdinalNumber(number:NSNumber)-> String {
    let frmt =  NumberFormatter()
    frmt.numberStyle = .ordinal
    return frmt.string(from: number)!
  }
  
  static  func getUnderlinedStr(str:String, font:UIFont) -> NSMutableAttributedString {
    let attributedStr = NSMutableAttributedString(string: str)
    
    attributedStr.addAttribute(NSAttributedString.Key.underlineColor, value: UIColor.black, range: NSRange(location: 0, length: str.count))
    attributedStr.addAttribute(NSAttributedString.Key.underlineStyle, value: UIColor.black, range: NSRange(location: 0, length: str.count))
    attributedStr.addAttribute(NSAttributedString.Key.font, value: font, range: NSRange(location: 0, length: str.count))
    
    return attributedStr
  }
  
}




extension UIImage {
  func imagetAccodingToExtension(extensionStr : String) -> UIImage {
    let arrExt = extensionStr.split(separator: ".")
    let extensionStr1 = arrExt.last?.lowercased()
    var imageReturn = UIImage()
    
    if extensionStr1?.lowercased() == "jpg" || extensionStr1?.lowercased() == "jpeg" || extensionStr1?.lowercased() == "png" || extensionStr1?.lowercased() == "heic"{
      imageReturn = #imageLiteral(resourceName: "img")
    }
    else if extensionStr1?.lowercased() == "mov" || extensionStr1?.lowercased() == "mp4" || extensionStr1?.lowercased() == "avi" || extensionStr1?.lowercased() == "flv" || extensionStr1?.lowercased() == "wmv" || extensionStr1?.lowercased() == "mpeg" || extensionStr1?.lowercased() == "m4v"
    {
      imageReturn = #imageLiteral(resourceName: "video_icon")
    }
    else if extensionStr1?.lowercased() == "zip" || extensionStr1?.lowercased() == "rar" || extensionStr1?.lowercased() == "Zip"
    {
      imageReturn = #imageLiteral(resourceName: "zip_icon")
    }
    else if extensionStr1?.lowercased() == "pdf"
    {
      imageReturn = #imageLiteral(resourceName: "pdf_icon")
    }
    else if extensionStr1?.lowercased() == "doc" || extensionStr1?.lowercased() == "docx"
    {
      imageReturn = #imageLiteral(resourceName: "doc")
    }
    else if extensionStr1?.lowercased() == "txt" || extensionStr1?.lowercased() == "text"
    {
      imageReturn = #imageLiteral(resourceName: "text")
    }
    else if extensionStr1?.lowercased() == "xlsx" || extensionStr1?.lowercased() == "xlt" || extensionStr1?.lowercased() == "xls"
    {
      imageReturn = #imageLiteral(resourceName: "excel")
    }
    else if extensionStr1?.lowercased() == "ppt" || extensionStr1?.lowercased() == "pptx" || extensionStr1?.lowercased() == "pptm"
    {
      imageReturn = #imageLiteral(resourceName: "ppt")
    }
    else if extensionStr1?.lowercased() == "apk"
    {
      imageReturn = #imageLiteral(resourceName: "img")
    }
    else if extensionStr1?.lowercased() == "mp3"
    {
      imageReturn = #imageLiteral(resourceName: "audio_icon")
    }
    else
    {
      imageReturn = #imageLiteral(resourceName: "img")
    }
    return imageReturn
  }
  
}


