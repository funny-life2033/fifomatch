//
//  ViewRound.swift
//  Sardik
//
//  Created by Subhash Sharma on 04/11/20.
//  Copyright © 2020 Subhash Sharma. All rights reserved.
//

import Foundation
import UIKit
@IBDesignable class ViewRound: UIView {

@IBInspectable var cornerRadius: CGFloat = 0.0
@IBInspectable var borderColor: UIColor = UIColor.black
@IBInspectable var borderWidth: CGFloat = 0.0
private var customBackgroundColor = UIColor.white
override var backgroundColor: UIColor?{
    didSet {
        customBackgroundColor = backgroundColor!
        super.backgroundColor = UIColor.clear
    }
}

func setup() {
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOffset = CGSize.zero
    layer.shadowRadius = 1.0
    layer.shadowOpacity = 0.3
    super.backgroundColor = UIColor.clear
}

override init(frame: CGRect) {
    super.init(frame: frame)
    self.setup()
}

required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.setup()
}

override func draw(_ rect: CGRect) {
    customBackgroundColor.setFill()
    UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius ?? 0).fill()

    let borderRect = bounds.insetBy(dx: borderWidth/2, dy: borderWidth/2)
    let borderPath = UIBezierPath(roundedRect: borderRect, cornerRadius: cornerRadius - borderWidth/2)
    borderColor.setStroke()
    borderPath.lineWidth = borderWidth
    borderPath.stroke()

    // whatever else you need drawn
}
}
