//
//  Extension.swift
//  TradeInYourLease
//
//  Created by Sourabh Sharma on 10/4/17.
//  Copyright © 2017 Ajay Vyas. All rights reserved.
//



import Foundation
import UIKit
//import FAPanels
extension UIButton {
    func selectedbtn(){
        self.layer.cornerRadius = 5
      
        self.backgroundColor = .white
        self.layer.borderColor = UIColor(red: 138/255, green: 0/255, blue: 96/255, alpha: 1).cgColor
//        self.imageView?.image = #imageLiteral(resourceName: <#T##String#>)
        self.layer.borderWidth = 1.5
        self.isSelected = true
      
        self.setTitleColor(UIColor.white, for: .normal)
    }
    
    func normalbtn(){
        self.layer.cornerRadius = 5
//        self.backgroundColor = TextfiledColor
        self.layer.borderColor = UIColor.lightGray
            .cgColor
        self.layer.borderWidth = 1
        self.isSelected = false
        self.setTitleColor(.lightGray, for: .normal)
    }
    
    
}
private var kAssociationKeyMaxLength: Int = 0
extension UITextField {
  
    public func LeftView(of image: UIImage?) {
        
        //setting left image
        if(image == nil)
        {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 40))
            self.leftView = paddingView
        }
        else
        {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            if let image = image {
                let paddingImage = UIImageView()
                paddingImage.image = image
                paddingImage.contentMode = .left
                paddingImage.frame = CGRect(x: 8, y: 0, width: 18, height: 40)
                paddingView.addSubview(paddingImage)
            }
            self.leftView = paddingView
        }
        self.leftView?.isUserInteractionEnabled = false
        self.leftViewMode = UITextField.ViewMode.always
        
        
    }
    
   
        @IBInspectable var maxLength: Int {
            get {
                if let length = objc_getAssociatedObject(self, &kAssociationKeyMaxLength) as? Int {
                    return length
                } else {
                    return Int.max
                }
            }
            set {
                objc_setAssociatedObject(self, &kAssociationKeyMaxLength, newValue, .OBJC_ASSOCIATION_RETAIN)
                addTarget(self, action: #selector(checkMaxLength), for: .editingChanged)
            }
        }
        
        @objc func checkMaxLength(textField: UITextField) {
            guard let prospectiveText = self.text,
                prospectiveText.count > maxLength
                else {
                    return
            }
            
            let selection = selectedTextRange
            
            let indexEndOfText = prospectiveText.index(prospectiveText.startIndex, offsetBy: maxLength)
            let substring = prospectiveText[..<indexEndOfText]
            text = String(substring)
            
            selectedTextRange = selection
        }
        
  var placeholder: String? {
      get {
          attributedPlaceholder?.string
      }

      set {
          guard let newValue = newValue else {
              attributedPlaceholder = nil
              return
          }

        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(red: 72/255, green: 70/255, blue: 70/255, alpha: 1.0)]

          let attributedText = NSAttributedString(string: newValue, attributes: attributes)

          attributedPlaceholder = attributedText
      }
  }
    public func RightViewImage(_ textFieldImg: UIImage?) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        if let image = textFieldImg {
            let paddingImage = UIImageView()
            paddingImage.image = image
            paddingImage.contentMode = .center
            paddingImage.frame = CGRect(x: 6, y: 6, width: 14, height: 18)
            paddingView.addSubview(paddingImage)
        }
        self.rightView = paddingView
        self.rightViewMode = UITextField.ViewMode.always
    }
}



extension UIDevice {
   
    var hasNotch: Bool {
        
        if #available(iOS 11.0, tvOS 11.0, *) {
            return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
        } else {
            let keyWindow = UIApplication.shared.connectedScenes
              .filter({$0.activationState == .foregroundActive})
              .map({$0 as? UIWindowScene})
              .compactMap({$0})
              .first?.windows
              .filter({$0.isKeyWindow}).first
              let bottom = keyWindow?.safeAreaInsets.bottom ?? 0
             return bottom > 0
        }
       
    }
}



extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    @IBInspectable var borderWidth1: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor1: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    func addBackground(str:String) {
        // screen width and height:
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        
        let imageViewBackground = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        imageViewBackground.image = UIImage(named: str)
        
        // you can change the content mode:
        imageViewBackground.contentMode = UIView.ContentMode.scaleAspectFill
        
        self.addSubview(imageViewBackground)
        self.sendSubviewToBack(imageViewBackground)
    }
    
    func startShimmering(){
        let light = UIColor.white.cgColor
        let alpha = UIColor.white.withAlphaComponent(0.7).cgColor
        
        let gradient = CAGradientLayer()
        gradient.colors = [alpha, light, alpha, alpha, light, alpha]
        gradient.frame = CGRect(x: -self.bounds.size.width, y: 0, width: 3 * self.bounds.size.width, height: self.bounds.size.height)
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.525)
        gradient.locations = [0.4, 0.5, 0.6]
        self.layer.mask = gradient
        
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [0.0, 0.1, 0.2]
        animation.toValue = [0.8, 0.9, 1.0]
        animation.duration = 1.5
        animation.repeatCount = HUGE
        gradient.add(animation, forKey: "shimmer")
    }
    
    func stopShimmering(){
        self.layer.mask = nil
    }
    
    func applyGradient(colours: [UIColor]) -> Void {
        self.applyGradient(colours: colours, locations: nil)
    }
    
    func applyGradient(colours: [UIColor], locations: [NSNumber]?) -> Void {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        gradient.startPoint = CGPoint(x : 0.0, y : 0.5)
        gradient.endPoint = CGPoint(x :1.0, y: 0.5)
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func setshadowWithRadius(radius: CGFloat = 7, shadowOpacity: Float = 0.7) {
              self.layer.cornerRadius = radius
             
              self.layer.shadowColor = UIColor.lightGray.cgColor
              self.layer.shadowOffset = CGSize(width: 0, height: 0)
              self.layer.shadowOpacity = shadowOpacity
              self.layer.shadowRadius = 5.0
    }
    
    
    
}

//public extension UIViewController {
//
//    //  Get Current Active Panel
//    var panel: FAPanelController? {
//
//        get{
//            var iter:UIViewController? = self.parent
//
//            while (iter != nil) {
//                if iter is FAPanelController {
//                    return iter as? FAPanelController
//                }else if (iter?.parent != nil && iter?.parent != iter) {
//                    iter = iter?.parent
//                }else {
//                    iter = nil
//                }
//            }
//            return nil
//        }
//    }
//
//    class var storyboardID : String {
//
//        return "\(self)"
//    }
//
//}

extension UITextField {
    
    func setPlaceHolderColor(name: String ) {
        
        self.setLeftPaddingPoints(10)
//        Utilities.setleftViewIcon(name: name, field: self)
    }

    
    func setBottomBorder() {
        
        self.borderStyle = UITextField.BorderStyle.none;
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.gray.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width,   width:  self.frame.size.width, height: self.frame.size.height)
        
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    func modifyClearButton() {
        let clearButton = UIButton(type: .custom)
        clearButton.setImage(UIImage(named : "img_clear"), for: .normal)
        clearButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        clearButton.contentMode = .scaleAspectFit
        clearButton.addTarget(self, action: #selector(UITextField.clear(_:)), for: .touchUpInside)
        rightView = clearButton
        rightViewMode = .whileEditing
    }
    
    @objc func clear(_ sender : AnyObject) {
        self.text = ""
        
//        sendActions(for: .editingChanged)
    }
    
    func decreaseFontSize () {
        self.font =  UIFont(name: (self.font?.fontName)!, size: (self.font?.pointSize)!-2)!
    }
    func addPlaceholderSpacing(spacing: CGFloat){
        let attributedString = NSMutableAttributedString(string: self.placeholder!)
        attributedString.addAttribute(NSAttributedString.Key.kern, value: spacing, range: NSRange(location: 0, length: self.placeholder!.count))
        self.attributedPlaceholder = attributedString
    }
    
    
        func setLeftPaddingPoints(_ amount:CGFloat){
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
            self.leftView = paddingView
            self.leftViewMode = .always
        }
        func setRightPaddingPoints(_ amount:CGFloat) {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
            self.rightView = paddingView
            self.rightViewMode = .always
        }
    
}

extension UILabel {
    func decreaseFontSize () {
        self.font =  UIFont(name: (self.font?.fontName)!, size: (self.font?.pointSize)!-5)!
    }
    func addTextSpacing(spacing: CGFloat){
        let attributedString = NSMutableAttributedString(string: self.text!)
        attributedString.addAttribute(NSAttributedString.Key.kern, value: spacing, range: NSRange(location: 0, length: self.text!.count))
        self.attributedText = attributedString
    }
}


extension UITextView {
    func addTextSpacing(spacing: CGFloat){
        let attributedString = NSMutableAttributedString(string: self.text!)
        attributedString.addAttribute(NSAttributedString.Key.kern, value: spacing, range: NSRange(location: 0, length: self.text!.count))
        self.attributedText = attributedString
    }
    
    
}

//MARK:- Validation Extension -

extension String {
    
    
      func toDate(withFormat format: String = "yyyy-MM-dd") -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        guard let date = dateFormatter.date(from: self) else {
          preconditionFailure("Take a look to your format")
        }
        return date
      }
    
     
     subscript(i: Int) -> String {
             return String(self[index(startIndex, offsetBy: i)])
     }

     func isEqualToString(find: String) -> Bool {
             return String(format: self) == find
     }
     
     func isEmptyString() -> Bool {
         if(self.isEmpty) {
             return true
         }
         return (self.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines) == "")
     }
     
     func isValidEmail() -> Bool {
         let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
         let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
         return emailTest.evaluate(with: self)
     }
     
     
     func validate() -> Bool {
         let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
         let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
         let result =  phoneTest.evaluate(with: self)
         return result
     }
     
       func isNumeric() -> Bool {
              guard self.count > 0 else { return false }
              let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
              return Set(self).isSubset(of: nums)
          }

    
    func capitalizingFirstLetter() -> String {
        let first = String(self.prefix(1)).capitalized
        let other = String(self.dropFirst())
        return first + other
    }
    
    var isAlphanumeric: Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }
    
    func size(OfFont font: UIFont) -> CGSize {
        return (self as NSString).size(withAttributes: [NSAttributedString.Key.font: font])
    }
    
    func size(_ font: UIFont) -> CGSize {
        return NSAttributedString(string: self, attributes: [.font: font]).size()
    }
    
    func width(_ font: UIFont) -> CGFloat {
        return size(font).width
    }
    
    func height(_ font: UIFont) -> CGFloat {
        return size(font).height
    }
    
    
    //To check text field or String is blank or not
    var isBlank: Bool {
        get {
            let trimmed = trimmingCharacters(in: CharacterSet.whitespaces)
//            print_debug(trimmed.isEmpty)
            return trimmed.isEmpty
        }
    }
    var trim : String {
        return self.trimmingCharacters(in: CharacterSet.whitespaces)
    }
    var isEmptyOrWhitespace : Bool {
      
      // Check empty string
      if self.isEmpty {
          return true
      }
      // Trim and check empty string
      return (self.trimmingCharacters(in: .whitespaces) == "")
  }
    var isEmail: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}", options: .caseInsensitive)
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count)) != nil
        } catch {
            return false
        }
    }
    
    var containsEmoji: Bool {
        for scalar in unicodeScalars {
            switch scalar.value {
            case 0x1F600...0x1F64F, // Emoticons
            0x1F300...0x1F5FF, // Misc Symbols and Pictographs
            0x1F680...0x1F6FF, // Transport and Map
            0x2600...0x26FF,   // Misc symbols
            0x2700...0x27BF,   // Dingbats
            0xFE00...0xFE0F,   // Variation Selectors
            0x1F900...0x1F9FF, // Supplemental Symbols and Pictographs
            0x1F1E6...0x1F1FF: // Flags
                return true
            default:
                continue
            }
        }
        return false
    }
    
   
    
    func stringHeightWith(_ font:UIFont,width:CGFloat)->CGFloat
    {
        let size = CGSize(width: width,height: CGFloat.greatestFiniteMagnitude)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping;
        let  attributes = [NSAttributedString.Key.font:font,
                           NSAttributedString.Key.paragraphStyle:paragraphStyle.copy()]
        
        let text = self as NSString
        let rect = text.boundingRect(with: size, options:.usesLineFragmentOrigin, attributes: attributes, context:nil)
        return rect.size.height
    }
    
//    func slice(from: String, to: String) -> String? {
//
//        return (range(of: from)?.upperBound).flatMap { substringFrom in
//            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
//                substring(with: substringFrom..<substringTo)
//            }
//        }
//    }
    
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: Data(utf8),
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            print("error: ", error)
            return nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
  
  func convertToAttributedString() -> NSAttributedString? {
  
    let modifiedFontString = "<span style=\"font-family: SF-Pro-Text-Regular; font-size: 16; color: rgb(60, 60, 60)\">" + self + "</span>"
    return modifiedFontString.html2AttributedString
  }
    

    var isAlphabetic: Bool {
        guard self.count > 0 else { return false }
        let nums: Set<Character> = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
        return Set(self).isSubset(of: nums)
    }
    
  func formatDate() -> String? {
      
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
      if let date1 = dateFormatter.date(from: self) {
          dateFormatter.dateFormat = "dd-MM-yyyy"
          let date2 = dateFormatter.string(from: date1)
          return date2
      }
      return nil
  }
  
  func getDays() -> Int? {
    
    let today = Date()
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    if let date1 = dateFormatter.date(from: self) {
      let diffInDays = Calendar.current.dateComponents([.day], from: today, to: date1).day
      return diffInDays
    }
    return nil
  }
  
}

extension UITableView {
    func setOffsetToBottom(animated: Bool) {
        
        self.setContentOffset(CGPoint(x: 0, y: self.contentSize.height - self.frame.size.height), animated: true)
    }
    
    func scrollToLastRow(animated: Bool) {
        
        if self.numberOfRows(inSection: 0) > 0 {
            
            let index = IndexPath(row: self.numberOfRows(inSection: 0) - 1, section: 0)
            
            self.scrollToRow(at: index, at: .bottom, animated: true)
            //self.scrollToRowAtIndexPath(NSIndexPath(forRow: self.numberOfRowsInSection(0) - 1, inSection: 0), atScrollPosition: .Bottom, animated: animated)
        }
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
//    func alert(message: String, title: String = "Forsa",completion:(()->())? = nil) {
//        let alertController = UIAlertController(title: title , message: message, preferredStyle: .alert)
//
//
//
//        let myString  = title
//                 var myMutableString = NSMutableAttributedString()
//        myMutableString = NSMutableAttributedString(string: myString as String, attributes: [NSAttributedString.Key.font:UIFont(name: "SF-Pro-Text-Regular", size: 18.0)])
//        myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range: NSRange(location:0,length:myString.count))
//                 alertController.setValue(myMutableString, forKey: "attributedTitle")
//
//                 // Change Message With Color and Font
//
//                 let message  = message
//                 var messageMutableString = NSMutableAttributedString()
//        messageMutableString = NSMutableAttributedString(string: message as String, attributes: [NSAttributedString.Key.font:UIFont(name: "SF-Pro-Text-Regular", size: 14.0)])
//        messageMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range: NSRange(location:0,length:message.count))
//                 alertController.setValue(messageMutableString, forKey: "attributedMessage")
//
//
//                 // Action.
//        let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.default){ (handler) in
//            completion?()
//        }
//        //action.setValue(AppColors.themeColor, forKey: "titleTextColor")
//        alertController.view.tintColor = UIColor(hexString: "1C25B0")
//        alertController.addAction(action)
//        DispatchQueue.main.async {
//            self.present(alertController, animated: true, completion: nil)
//        }
//
//    }
    
    
//    func alertWithCancel(message: String, title: String = "ALERT",otherActionTitle:String = "OK",completion:(()->())? = nil) {
//        let alertController = UIAlertController(title: title , message: message, preferredStyle: .alert)
//
//
//
//        let myString  = title
//                 var myMutableString = NSMutableAttributedString()
//        myMutableString = NSMutableAttributedString(string: myString as String, attributes: [NSAttributedString.Key.font:UIFont(name: "SF-Pro-Text-Regular", size: 18.0)!])
//        myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range: NSRange(location:0,length:myString.count))
//                 alertController.setValue(myMutableString, forKey: "attributedTitle")
//
//                 // Change Message With Color and Font
//
//                 let message  = message
//                 var messageMutableString = NSMutableAttributedString()
//        messageMutableString = NSMutableAttributedString(string: message as String, attributes: [NSAttributedString.Key.font:UIFont(name: "SF-Pro-Text-Regular", size: 14.0)!])
//        messageMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range: NSRange(location:0,length:message.count))
//                 alertController.setValue(messageMutableString, forKey: "attributedMessage")
//
//
//                 // Action.
//        let action = UIAlertAction(title: otherActionTitle, style: UIAlertAction.Style.default){ (handler) in
//            completion?()
//        }
//
//        let cancelAction = UIAlertAction(title: "CANCEL", style: UIAlertAction.Style.default){ (handler) in
//            alertController.dismiss(animated: true, completion: nil)
//        }
//        //action.setValue(AppColors.themeColor, forKey: "titleTextColor")
//        alertController.view.tintColor = UIColor(hexString: "1C25B0")
//        alertController.addAction(cancelAction)
//        alertController.addAction(action)
//
//        DispatchQueue.main.async {
//            self.present(alertController, animated: true, completion: nil)
//        }
//
//    }
}

extension UIImage {
    
    func alpha(_ value:CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: CGPoint.zero, blendMode: .normal, alpha: value)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}


extension UIButton{
    
    
    func addTextSpacing(spacing: CGFloat){
        let attributedString = NSMutableAttributedString(string: (self.titleLabel?.text!)!)
        attributedString.addAttribute(NSAttributedString.Key.kern, value: spacing, range: NSRange(location: 0, length: (self.titleLabel?.text!.count)!))
        self.setAttributedTitle(attributedString, for: .normal)
    }
    
    
    func underline() {
        guard let text = self.titleLabel?.text else { return }
        
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: text.count))
        
        self.setAttributedTitle(attributedString, for: .normal)
    }
    
    
    
}


extension UIToolbar {
    
    func ToolbarPiker(mySelect : Selector , myCancel :Selector) -> UIToolbar {
        
        let toolBar = UIToolbar()
        
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.blue
        toolBar.sizeToFit()
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: mySelect)
        cancelButton.tag = 1
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: myCancel)
        doneButton.tag = 2
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([ cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        return toolBar
    }
    
}

extension UITabBar {
    
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        if(UIScreen.main.bounds.height == 812) {
            sizeThatFits.height = (UIScreen.main.bounds.height*11.5)/100 // adjust your size here
        }
        else {
            sizeThatFits.height = (UIScreen.main.bounds.height*9.5)/100 // adjust your size here
        }
        
        
        return sizeThatFits
    }
}

extension UIView {
    

         func blink() {
             self.alpha = 0.2
             UIView.animate(withDuration: 1, delay: 0.0, options: [.curveLinear, .repeat, .autoreverse], animations: {self.alpha = 1.0}, completion: nil)
         }
    


    func addMistCornerRadius(corners : UIRectCorner =  [ .topRight , .topLeft]) {
    
    let rectShape = CAShapeLayer()
       rectShape.bounds = self.frame
       rectShape.position = self.center
       rectShape.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: 22, height: 22)).cgPath
        self.layer.mask = rectShape
    
    }
  // OUTPUT 2
    func dropShadow2() {
        layer.shadowColor = UIColor.darkGray.cgColor
               layer.shadowOffset = CGSize(width: 2, height: 2)
               layer.masksToBounds = false
           
               layer.shadowOpacity = 0.1
               layer.shadowRadius = 5
               layer.shadowPath = UIBezierPath(rect: bounds).cgPath
               layer.rasterizationScale = UIScreen.main.scale
               layer.shouldRasterize = true

     }
    
    
    func dropShadowTop() {
        layer.masksToBounds = false
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.5
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 0 , height: 2)
        layer.shadowPath = UIBezierPath(rect: CGRect(x: 0,
                                                     y: bounds.minY - layer.shadowRadius,
                                                     width: bounds.width,
                                                     height: layer.shadowRadius)).cgPath

    }
}


protocol XIBLocalizable {
    var xibLocKey: String? { get set }
}

protocol Localizable {
    var localized: String { get }
}




//extension UIColor {
//    convenience init(hexString: String, alpha: CGFloat = 1.0) {
//        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
//        let scanner = Scanner(string: hexString)
//        if (hexString.hasPrefix("#")) {
//            scanner.scanLocation = 1
//        }
//        var color: UInt32 = 0
//        scanner.scanHexInt32(&color)
//        let mask = 0x000000FF
//        let r = Int(color >> 16) & mask
//        let g = Int(color >> 8) & mask
//        let b = Int(color) & mask
//        let red   = CGFloat(r) / 255.0
//        let green = CGFloat(g) / 255.0
//        let blue  = CGFloat(b) / 255.0
//        self.init(red:red, green:green, blue:blue, alpha:alpha)
//    }
//    func toHexString() -> String {
//        var r:CGFloat = 0
//        var g:CGFloat = 0
//        var b:CGFloat = 0
//        var a:CGFloat = 0
//        getRed(&r, green: &g, blue: &b, alpha: &a)
//        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
//        return String(format:"#%06x", rgb)
//    }
//}
internal protocol StoryboardIdentifiable {
    
    static var storyboardIdentifier: String { get }
}

extension StoryboardIdentifiable where Self: UIViewController {
    
    static var storyboardIdentifier: String {
        return String(describing: Self.self)
    }
}

extension UIViewController: StoryboardIdentifiable {
    
}

extension UIStoryboard {
    
    enum Storyboard: String {
        case mainStoryBoard = "Main"
        case homeStoryboard = "HomeNewStoryboard"
        case subscriptionStoryboard = "Subscription"
        case Survey = "Survey"

        var filename: String {
            return rawValue.description
        }
    }
    
    // MARK: - Convenience Initializers
    
    convenience init(storyboard: Storyboard, bundle: Bundle? = nil) {
        self.init(name: storyboard.filename, bundle: bundle)
    }
    
    // MARK: - View Controller Instantiation from Generics
    
    func instantiateViewController<T: UIViewController>() -> T {
        guard let viewController = self.instantiateViewController(withIdentifier: T.storyboardIdentifier) as? T else {
            fatalError("Couldn't instantiate view controller with identifier \(T.storyboardIdentifier) ")
        }
        return viewController
    }
}

extension UIViewController {
    func openViewController<T: UIViewController>(controller: T.Type, storyBoard: UIStoryboard.Storyboard, handler: @escaping (T) -> Void) {
        let storyBoard = UIStoryboard(storyboard: storyBoard)
        let vc: T = storyBoard.instantiateViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        handler(vc)
    }
}



extension UITableView {
    func reloadDataInMainQueue() {
        DispatchQueue.main.async {
            self.reloadData()
        }
    }
    
    func setShadowTV(color: UIColor, offset: CGSize, opacity: Float) {
        let shadowPath = UIBezierPath(rect: bounds)
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowOpacity = opacity
        layer.shadowPath = shadowPath.cgPath
    }
    
    func setCornerRadiusTV(value: CGFloat) {
        layer.masksToBounds = true
        layer.cornerRadius = value
    }
    
    func setBorderTV(color: UIColor, size: CGFloat) {
        layer.borderWidth = size
        layer.borderColor = color.cgColor
    }
}

extension UICollectionView {
    func reloadDataInMainQueue() {
        DispatchQueue.main.async {
            self.reloadData()
        }
    }
    
    func setShadowCV(color: UIColor, offset: CGSize, opacity: Float) {
        let shadowPath = UIBezierPath(rect: self.bounds)
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowOpacity = opacity
        layer.shadowPath = shadowPath.cgPath
    }
    
    func setCornerRadiusCV(value: CGFloat) {
        layer.masksToBounds = true
        layer.cornerRadius = value
    }
    
    func setBorderCV(color: UIColor, size: CGFloat) {
        layer.borderWidth = size
        layer.borderColor = color.cgColor
    }
}

extension UIView {
    func setShadow(color: UIColor, offset: CGSize, opacity: Float) {
        let shadowPath = UIBezierPath(rect: self.bounds)
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowOpacity = opacity
        layer.shadowPath = shadowPath.cgPath
    }
    
    func setCornerRadius(value: CGFloat) {
        layer.masksToBounds = true
        layer.cornerRadius = value
    }
    
    func setBorder(color: UIColor, size: CGFloat) {
        layer.borderWidth = size
        layer.borderColor = color.cgColor
    }
    
    func setDashedBorderView(color: UIColor) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let yourViewBorder = CAShapeLayer()
            yourViewBorder.strokeColor = color.cgColor
            yourViewBorder.lineDashPattern = [2, 2]
            yourViewBorder.frame = self.bounds
            yourViewBorder.fillColor = nil
            yourViewBorder.path = UIBezierPath(rect: self.bounds).cgPath
            self.layer.addSublayer(yourViewBorder)
        }
    }
}

extension UIButton {
    func setShadowButton(color: UIColor, offset: CGSize, opacity: Float) {
        let shadowPath = UIBezierPath(rect: bounds)
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowOpacity = opacity
        layer.shadowPath = shadowPath.cgPath
    }
    
    func setCornerRadiusButton(value: CGFloat) {
        layer.masksToBounds = true
        layer.cornerRadius = value
    }
    
    func setBorderButton(color: UIColor, size: CGFloat) {
        layer.borderWidth = size
        layer.borderColor = color.cgColor
    }
    
    func setDashedBorderButton(color: UIColor) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let yourViewBorder = CAShapeLayer()
            yourViewBorder.strokeColor = color.cgColor
            yourViewBorder.lineDashPattern = [2, 2]
            yourViewBorder.frame = self.bounds
            yourViewBorder.fillColor = nil
            yourViewBorder.path = UIBezierPath(rect: self.bounds).cgPath
            self.layer.addSublayer(yourViewBorder)
        }
    }
}

extension UIImageView {
    func dropShadow() {
        self.layer.masksToBounds = false
             self.layer.shadowColor = UIColor.black.cgColor
             self.layer.shadowOpacity = 0.8
             self.layer.shadowOffset = CGSize(width: -1, height: 1)
             self.layer.shadowRadius = 2
            // self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
             self.layer.shouldRasterize = true
             self.layer.cornerRadius = 60.0
             self.layer.rasterizationScale = UIScreen.main.scale
    }
    func setShadowImageView(color: UIColor, offset: CGSize, opacity: Float) {
        let shadowPath = UIBezierPath(rect: self.bounds)
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowOpacity = opacity
        layer.shadowPath = shadowPath.cgPath
    }
    
    func setCornerRadiusImageView(value: CGFloat) {
        layer.masksToBounds = true
        layer.cornerRadius = value
    }
    
    func setBorderImageView(color: UIColor, size: CGFloat) {
        layer.borderWidth = size
        layer.borderColor = color.cgColor
    }
    
    func setDashedBorderImageView(color: UIColor) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let yourViewBorder = CAShapeLayer()
            yourViewBorder.strokeColor = color.cgColor
            yourViewBorder.lineDashPattern = [2, 2]
            yourViewBorder.frame = self.bounds
            yourViewBorder.fillColor = nil
            yourViewBorder.path = UIBezierPath(rect: self.bounds).cgPath
            self.layer.addSublayer(yourViewBorder)
        }
    }
}

extension UITextField {
    func setShadowTextField(color: UIColor, offset: CGSize, opacity: Float) {
        let shadowPath = UIBezierPath(rect: self.bounds)
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowOpacity = opacity
        layer.shadowPath = shadowPath.cgPath
    }
    
    func setCornerRadiusTextField(value: CGFloat) {
        layer.masksToBounds = true
        layer.cornerRadius = value
    }
    
    func setBorderTextField(color: UIColor, size: CGFloat) {
        layer.borderWidth = size
        layer.borderColor = color.cgColor
    }
    
    func setDashedBorderTextField(color: UIColor) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let yourViewBorder = CAShapeLayer()
            yourViewBorder.strokeColor = color.cgColor
            yourViewBorder.lineDashPattern = [2, 2]
            yourViewBorder.frame = self.bounds
            yourViewBorder.fillColor = nil
            yourViewBorder.path = UIBezierPath(rect: self.bounds).cgPath
            self.layer.addSublayer(yourViewBorder)
        }
    }
}
extension UITapGestureRecognizer {
    
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)
        
        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)
        
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y)
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
    
}

//extension Range where Bound == String.Index {
//    var nsRange:NSRange {
//        return NSRange(location: self.lowerBound.encodedOffset,
//                       length: self.upperBound.encodedOffset -
//                        self.lowerBound.encodedOffset)
//    }
//}
extension Bundle {
    
    class var applicationVersionNumber: String {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            return version
        }
        return "Version Number Not Available"
    }
    
    class var applicationBuildNumber: String {
        if let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            return build
        }
        return "Build Number Not Available"
    }
    
}

extension UIButton {
    
    func pulsate() {
        
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.6
        pulse.fromValue = 0.95
        pulse.toValue = 1.0
        pulse.autoreverses = true
        pulse.repeatCount = 1
        pulse.initialVelocity = 0.5
        pulse.damping = 1.0
        
        layer.add(pulse, forKey: "pulse")
    }
  
      func flash() {
        
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 0.5
        flash.fromValue = 1
        flash.toValue = 0.1
        flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        flash.autoreverses = true
        flash.repeatCount = 1
        
        
      
        
        layer.add(flash, forKey: nil)
    }
      func provideVisualFeedback(_ sender:UIButton!)
    {
        sender.backgroundColor = UIColor(red: 142/255, green: 145/255, blue: 14/2557, alpha: 1).withAlphaComponent(0.5)
        sender.alpha = 0
        UIView .animate(withDuration: 0.5, animations: {
            sender.alpha = 1
        }, completion: { completed in
            if completed {
                sender.backgroundColor = UIColor.clear
            }
        })
    }
  
    func shake() {
        
        let shake = CABasicAnimation(keyPath: "position")
        shake.duration = 0.1
        shake.repeatCount = 2
        shake.autoreverses = true
        
        let fromPoint = CGPoint(x: center.x - 5, y: center.y)
        let fromValue = NSValue(cgPoint: fromPoint)
        
        let toPoint = CGPoint(x: center.x + 5, y: center.y)
        let toValue = NSValue(cgPoint: toPoint)
        
        shake.fromValue = fromValue
        shake.toValue = toValue
        
        layer.add(shake, forKey: "position")
    }
}


// Example of using the extension on button press
extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
    var releaseVersionNumberPretty: String {
        return "v\(releaseVersionNumber ?? "1.0.0")"
    }

}

extension Date {
    func getTimeDifferenceWithCurrent(isTime:Bool = false) -> String {
        let time = Int(self.timeIntervalSince(Date()))
        if time < 0 {
            return "Expired"
        }else if time > 86400 {
            if isTime {
                return self.getStringFrom(date: self, withFormat: "dd-MMM-yyyy, hh:mm a")
            } else {
                return self.getStringFrom(date: self, withFormat: "dd-MMM-yyyy")
            }
        }else {
            return "\(time / 3600)h \((time % 3600) / 60)m \((time % 3600) % 60)s"
        }
    }
    
    func getTimeInterval() -> Int {
        return Int(self.timeIntervalSince(Date()))
    }
    
    func getTimeStamp() -> Int {
        return Int(self.timeIntervalSince1970)
    }
    
    // Convert UTC (or GMT) to local time
    func toLocalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
    // Convert local time to UTC (or GMT)
    func toGlobalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = -TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    

    
    func getStringFrom(date:Date, withFormat format:String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    static func getDateFrom(strDate:String, withFormat format:String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: strDate)
    }
    
    //MARK:- Date Foramatter
    func dateStringWithFormat(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from:self)
    }
    
    //MARK:- Calculate Age
    var age: Int {
        return Calendar.current.dateComponents([.year], from: self, to: Date()).year!
    }
    
    func nearestHour() -> Date? {
        var components = NSCalendar.current.dateComponents([.minute], from: self)
        let minute = components.minute ?? 0
        components.minute = minute >= 30 ? 60 - minute : -minute
        return Calendar.current.date(byAdding: components, to: self)
    }
    
    var yesterday: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var tomorrow: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return tomorrow.month != month
    }
}
extension UIImageView {
   
}

import Foundation
import UIKit

@IBDesignable
class DesignableUIView : UIView {
    
    @IBInspectable public var borderColor: UIColor = UIColor.clear {
        didSet{
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    //For border Width
    @IBInspectable public var borderWidth: CGFloat = 0.0 {
        didSet{
            self.layer.borderWidth = borderWidth
        }
    }
    
 
    
    @IBInspectable public var shadowOpacity: CGFloat = 0.0 {
        didSet{
            self.layer.shadowOpacity = Float(shadowOpacity)
        }
    }
    
    @IBInspectable public var shadowColor: UIColor = UIColor.clear {
        didSet{
            self.layer.shadowColor = shadowColor.cgColor
        }
    }
    
    @IBInspectable public var shadowRadius: CGFloat = 0.0 {
        didSet{
            self.layer.shadowRadius = shadowRadius
        }
    }
    
    @IBInspectable public var shadowOffsetY: CGFloat = 0.0 {
        didSet{
            self.layer.shadowOffset.height = shadowOffsetY
        }
    }
}
