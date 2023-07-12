//
//  CustomProtocol.swift
//  FIFOMatch
//
//  Created by Harendra Singh Rathore on 14/04/22.
//

import Foundation
import ImageSlideshow

protocol FilterDelegate: AnyObject {
  
  func fifoFilter(value: String)
  func relationshipFilter(id: Int)
  func occupationFilter(id: Int)
  func heightFilter(height: String, heightType: String)
  func bodyTypeFilter(value: String)
  func ageFilter(minAge: String, maxAge: String)
}

protocol ApplyFilterDelegate: AnyObject {
  
  func applyFilter(params: [String: Any])
}

protocol OpenImageDelegate: AnyObject {
  
  func openProfile(imgView: ImageSlideshow)
}
