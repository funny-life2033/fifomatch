//
//  Network.swift
//  FIFOMatch
//
//  Created by Harendra Singh Rathore on 25/03/22.
//

import Foundation
import Alamofire
import UIKit

struct Network {
  
  static let shared = Network()
  
  //MARK: Get Api Request
  func getRequest<T: Decodable>(requestUrl: URL, resultType: T.Type, completionHandler: @escaping(_ result: T?,_ error: String?) -> Void) {
    
    
    guard Common.isConnectedToNetwork() else {
      completionHandler(nil, Messages.INTERNET_ERROR.rawValue)
      return
    }
    
    var request = URLRequest(url: requestUrl)
    request.httpMethod = "GET"
    
    let token = UserDefault.shared.getSessionId()
    if token != "" {
      request.addValue(token, forHTTPHeaderField: "Authorization")
    }
      
    AF.request(request).response { response in
      
      switch response.result {
      case .success:
        if let json = response.data {
          
          let decoder = JSONDecoder()
          
          do {
            
            let result = try decoder.decode(T.self, from: json)
            completionHandler(result, nil)
          }
          catch let error {
            
            debugPrint("error occured while decoding = \(error)")
            completionHandler(nil, error.localizedDescription)
            
          }
        }
      case .failure(let error):
        print("error")
        completionHandler(nil, error.localizedDescription)
      }
    }
  }
  
  //MARK: - Post Multipart Api Request
  func postRequest<T: Decodable>(images: [String: UIImage?] = [:], requestUrl: URL, resultType: T.Type, parameters: [String: Any],completionHandler: @escaping(_ result: T?,_ error: String?) -> Void) {
    
    guard Common.isConnectedToNetwork() else {
      completionHandler(nil, Messages.INTERNET_ERROR.rawValue)
      return
    }
    
    debugPrint("request Url =\(requestUrl.absoluteString), parameters = \(parameters)")
    
    let token = UserDefault.shared.getSessionId()
    var header:HTTPHeaders? = nil
    
    if token != "" {
      header = ["Authorization": token]
    }
    
    AF.upload(multipartFormData: { multipartFormData in
      
      for (key, values) in images {
        
        if let image = values {
          let timeStamp = Int(Date().timeIntervalSince1970)
          if let imageData =  image.jpegData(compressionQuality: 0.50) {
            multipartFormData.append(imageData, withName: key, fileName: "\(timeStamp).jpeg", mimeType: "image/jpg")
          }
        }
      }
      
//      if image != nil {
//
//        let timeStamp = Int(Date().timeIntervalSince1970)
//        if let imageData =  image?.jpegData(compressionQuality: 0.50) {
//          multipartFormData.append(imageData, withName: "image", fileName: "\(timeStamp)", mimeType: "image/jpg")
//        }
//
//      }
      
      for (key, values) in parameters {
        if let data = "\(values)".data(using: .utf8) {
          multipartFormData.append(data, withName: key)
        }
        
      }
      
    }, to: requestUrl, headers: header).response { response in
      
      switch response.result {
      case .success(let responseData):
        
        if let data = responseData {
          
          let decoder = JSONDecoder()
          
          do {
            let result = try decoder.decode(resultType.self, from: data)
            completionHandler(result, nil)
          } catch let error {
            
            debugPrint("error occured while decoding = \(error.localizedDescription)")
            completionHandler(nil, error.localizedDescription)
          }
        }
      case .failure(let error):
        
        debugPrint("error occured from server = \(error.localizedDescription)")
        completionHandler(nil, error.localizedDescription)
      }
    }
    
  }
  
  //MARK: - Post Multipart Api Request
  func postRequestMulitpleImages<T: Decodable>(images: [ProfileImage], requestUrl: URL, resultType: T.Type ,completionHandler: @escaping(_ result: T?,_ error: String?) -> Void) {
    
    guard Common.isConnectedToNetwork() else {
      completionHandler(nil, Messages.INTERNET_ERROR.rawValue)
      return
    }
    
    debugPrint("request Url =\(requestUrl.absoluteString)")
    
    let token = UserDefault.shared.getSessionId()
    var header:HTTPHeaders? = nil
    
    if token != "" {
      header = ["Authorization": token]
    }
    
    AF.upload(multipartFormData: { multipartFormData in
      
      for index in 0..<images.count {
        
        let image = images[index].image
        let key = "images[\(index)]"
        
        let timeStamp = Int(Date().timeIntervalSince1970)
        if let imageData =  image.jpegData(compressionQuality: 0.50) {
          multipartFormData.append(imageData, withName: key, fileName: "\(timeStamp).jpeg", mimeType: "image/jpg")
        }
        
      }
      
    }, to: requestUrl, headers: header).response { response in
      
      switch response.result {
      case .success(let responseData):
        
        if let data = responseData {
          
          let decoder = JSONDecoder()
          
          do {
            let result = try decoder.decode(resultType.self, from: data)
            completionHandler(result, nil)
          } catch let error {
            
            debugPrint("error occured while decoding = \(error.localizedDescription)")
            completionHandler(nil, error.localizedDescription)
          }
        }
      case .failure(let error):
        
        debugPrint("error occured from server = \(error.localizedDescription)")
        completionHandler(nil, error.localizedDescription)
      }
    }
    
  }
  

  //MARK: Get HTML Response
  func getHtmlData(requestUrl: URL, completionHandler: @escaping(_ result: String?,_ message: String?) -> Void) {

    guard Common.isConnectedToNetwork() else {
      completionHandler(nil, Messages.INTERNET_ERROR.rawValue)
      return
    }
    
    var request = URLRequest(url: requestUrl)
    request.httpMethod = "GET"

    let token = UserDefault.shared.getSessionId()
    if token != "" {
      request.addValue(token, forHTTPHeaderField: "Authorization")
    }

    AF.request(request).responseString { response in

      switch response.result {
      case .success(let html):
        completionHandler(html, nil)

      case .failure(let error):

        debugPrint("error occured from server = \(error.localizedDescription)")
        completionHandler(nil, error.localizedDescription)
      }
    }
  }
  
  
  //MARK: Get Api Request
  func getParamtersRequest<T: Decodable>(requestUrl: URL, resultType: T.Type, parameters: [String: Any] = [:], completionHandler: @escaping(_ result: T?,_ error: String?) -> Void) {
    
    debugPrint("request Url =\(requestUrl.absoluteString), parameters = \(parameters)")
    
    guard Common.isConnectedToNetwork() else {
      completionHandler(nil, Messages.INTERNET_ERROR.rawValue)
      return
    }
  
    
    var headers: HTTPHeaders = [:]
    let token = UserDefault.shared.getSessionId()
    if token != "" {
      headers["Authorization"] = token
    }
    

    AF.request(requestUrl, method: .get, parameters: parameters, headers: headers).response { response in
      
      switch response.result {
      case .success:
        if let json = response.data {
          
          let decoder = JSONDecoder()
          
          do {
            
            let result = try decoder.decode(T.self, from: json)
            completionHandler(result, nil)
          }
          catch let error {
            
            debugPrint("error occured while decoding = \(error)")
            completionHandler(nil, error.localizedDescription)
            
          }
        }
      case .failure(let error):
        print("error")
        completionHandler(nil, error.localizedDescription)
      }
    }
  }
  
  //MARK: - GET RECEIPT SUBSCRIPTION DETAILS
  public func getPurchasedSubscriptions(url: String, method : HTTPMethod, param : Parameters , completion: @escaping (_ success: Bool,_ message: String,_ value: [String:Any]?) -> Void){
    
//    debugPrint("URL = \(url)")
//    debugPrint("params = \(param)")
    
    AF.request(url, method: method, parameters: param, encoding: JSONEncoding.default).response { response in
      
      switch response.result {
      case .success:
        if let json = response.data {
          
          do {
            let jsonData = try JSONSerialization.jsonObject(with: json, options: []) as? [String: Any]
            completion(true, "", jsonData)
          } catch let error{
            debugPrint( "error = \(error.localizedDescription)")
            completion(false, "\(error.localizedDescription)", nil)
          }
        }
      case .failure(let error):
        print("error")
        completion(false, error.localizedDescription, nil)
      }
      
    }
  }
  
}
