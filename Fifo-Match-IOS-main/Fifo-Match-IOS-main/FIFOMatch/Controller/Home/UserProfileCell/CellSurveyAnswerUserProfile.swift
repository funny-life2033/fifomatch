//
//  CellSurveyAnswerUserProfile.swift
//  FiFoMatch
//
//  Created by Aryan Tak on 28/02/22.
//

import UIKit

class CellSurveyAnswerUserProfile: UICollectionViewCell {
  
  @IBOutlet weak var qualitieFirstBtn: UIButton!
  @IBOutlet weak var qualitieSecondBtn: UIButton!
  @IBOutlet weak var qualitieThiredBtn: UIButton!
  @IBOutlet weak var qualitieFourthBtn: UIButton!
  
  @IBOutlet weak var appreciateBtnOne: UIButton!
  @IBOutlet weak var appreciateBtnTwo: UIButton!
  @IBOutlet weak var appreciateBtnThree: UIButton!
  @IBOutlet weak var appreciateBtnFour: UIButton!
  
  @IBOutlet weak var personalityTypeBtn: UIButton!
  @IBOutlet weak var kidsBtn: UIButton!
  @IBOutlet weak var kidsInFutureBtn: UIButton!
  @IBOutlet weak var notAvailableView: UIView!
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
