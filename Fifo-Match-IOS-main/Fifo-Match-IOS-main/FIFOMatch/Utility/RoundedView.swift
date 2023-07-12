//
//  RoundedView.swift
//  FIFOMatch
//
//  Created by Diwakar Tak on 03/02/22.
//

import Foundation
import UIKit
@IBDesignable
class RoundUIView: UIView {

    @IBInspectable var borderColor: UIColor = UIColor.white {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }

    @IBInspectable var borderWidth: CGFloat = 2.0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
}


