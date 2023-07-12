//
//  LabelExtension.swift
//  FIFOMatch
//
//  Created by Harendra Singh Rathore on 01/04/22.
//

import Foundation
import UIKit

//extension UILabel {
//  
//  var isTruncated: Bool {
//
//          guard let labelText = text else {
//              return false
//          }
//
//          let labelTextSize = (labelText as NSString).boundingRect(
//              with: CGSize(width: frame.size.width, height: .greatestFiniteMagnitude),
//              options: .usesLineFragmentOrigin,
//              attributes: [.font: font],
//              context: nil).size
//
//          return labelTextSize.height > bounds.size.height
//      }
//}

extension Date {
    static var currentTimeStamp: Int64{
        return Int64(Date().timeIntervalSince1970 * 1000)
    }
}
