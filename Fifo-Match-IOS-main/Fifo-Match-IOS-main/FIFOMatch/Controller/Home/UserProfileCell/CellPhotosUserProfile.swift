//
//  CellPhotosUserProfile.swift
//  FiFoMatch
//
//  Created by Aryan Tak on 28/02/22.
//

import UIKit
import ImageSlideshow

class CellPhotosUserProfile: UICollectionViewCell {

  @IBOutlet weak var userImgView: ImageSlideshow!
  @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var viewLockImg: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
