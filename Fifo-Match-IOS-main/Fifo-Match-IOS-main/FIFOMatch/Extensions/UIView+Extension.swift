//
//  UIView+Extension.swift
//  FIFOMatch
//
//  Created by Subhash Sharma on 02/03/22.
//

import Foundation
import UIKit

extension UIView {
  func roundCorners(corners: UIRectCorner, radius: CGFloat) {
    let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
    let mask = CAShapeLayer()
    mask.path = path.cgPath
    layer.mask = mask
  }
}


extension Notification.Name {
  static let updateProfile = Notification.Name("updateProfile")
  static let refreshHome = Notification.Name("refreshHome")
  static let updateSurvey = Notification.Name("updateSurvey")
}

extension Date {
  func timeAgoDisplay() -> String {
    let calendar = Calendar.current
    let minuteAgo = calendar.date(byAdding: .minute, value: -1, to: Date())!
    let hourAgo = calendar.date(byAdding: .hour, value: -1, to: Date())!
    let dayAgo = calendar.date(byAdding: .day, value: -1, to: Date())!
    //let weekAgo = calendar.date(byAdding: .day, value: -7, to: Date())!
    
    
    let sameDay = Calendar.current.isDate(Date() , equalTo: self, toGranularity: .day)
    if sameDay {
      
      if minuteAgo < self {
        return "now"
      } else if hourAgo < self {
        let diff = Calendar.current.dateComponents([.minute], from: self, to: Date()).minute ?? 0
        return "\(diff) min ago"
      } else if dayAgo < self {
        return "hrs"
      }
      
    }
  
    if Calendar.current.isDayInCurrentWeek(date: self) ?? false {
      return "week"
    }
    
    return "date"
  }
}

extension Calendar {
    func isDayInCurrentWeek(date: Date) -> Bool? {
        let currentComponents = Calendar.current.dateComponents([.weekOfYear], from: Date())
        let dateComponents = Calendar.current.dateComponents([.weekOfYear], from: date)
        guard let currentWeekOfYear = currentComponents.weekOfYear, let dateWeekOfYear = dateComponents.weekOfYear else { return nil }
        return currentWeekOfYear == dateWeekOfYear
    }
}
