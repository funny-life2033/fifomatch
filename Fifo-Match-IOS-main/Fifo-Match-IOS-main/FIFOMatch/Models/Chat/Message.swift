//
//  Message.swift
//  SportsJunki
//
//  Created by octal on 03/05/19.
//  Copyright © 2019 Admin octal. All rights reserved.
//

import UIKit
import FirebaseDatabase

class Message: NSObject {
    var ID : String = ""
    var text: String?
    var senderID : String?
    var timeStamp:Double!
    var senderName : String?
    var type: MessageType!
    var mtype: String?
    var senderImage : String?
    var media : String?
    
    func intdatawithsnapshot(snapshot:DataSnapshot) -> Message {
        
        ID = snapshot.key
        
        let value = snapshot.value as! NSDictionary
        
        text = value.value(forKey: "message") as? String ?? ""
        
        senderID = value.value(forKey: "sender_id") as? String ?? ""
        timeStamp = value.value(forKey: "time") as? Double
        senderName = value.value(forKey: "user_name") as? String ?? ""
        mtype = value.value(forKey: "messages_type") as? String ?? ""
        type =  MessageType(rawValue: value.value(forKey: "type") as? String ?? "")
        senderImage = value.value(forKey: "user_image") as? String ?? ""
        
        if ((value.value(forKey: "message")) != nil){
            
            if let decodedData = Data(base64Encoded:value.value(forKey: "message") as? String ?? ""),
               let decodedString = String(data: decodedData, encoding: .utf8) {
                text = decodedString
            }
        }
        
        if type == MessageType.MediaMessage{
            
            if let decodedData = Data(base64Encoded:value.value(forKey: "media") as? String ?? ""),
               let decodedString = String(data: decodedData, encoding: .utf8) {
                media = decodedString
            }
            
        }
        
        
        return self
    }
}
