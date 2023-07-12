//
//  SurveyInfoCell.swift
//  FIFOMatch
//
//  Created by Harendra Singh Rathore on 12/04/22.
//

import UIKit

class SurveyInfoCell: UICollectionViewCell {
  
  @IBOutlet weak var titleLbl: UILabel!
  
  //static let pillHeight: CGFloat = 40.0
  
  override func awakeFromNib() {
      super.awakeFromNib()
      //setupView()
  }
  
  func setLabel(_ text: String?) {
      self.titleLbl.text = text
  }
}

private extension SurveyInfoCell {
  
}
