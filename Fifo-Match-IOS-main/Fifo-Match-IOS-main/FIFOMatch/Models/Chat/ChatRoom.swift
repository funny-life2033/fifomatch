//
//  ChatRoom.swift
//  SportsJunki
//
//  Created by octal on 10/05/19.
//  Copyright © 2019 Admin octal. All rights reserved.
//

import UIKit
import Firebase

enum ChatType : String{
    case person = "P"
    case group = "G"
}

class ChatRoom: NSObject {
    var ID : String?
    var isUnread : String?
    var isActive : Bool!
    var lastActiveTime : Double!
    var device_token : String?
    var type : ChatType!
    var gmcount : String?
    var name : String?
    var messageLast:Message!
    var lastmsgTyp:MessageType!
    var arrCount : NSDictionary!
    var imgurl : String = ""
    
    
    var group_member : NSMutableArray = []
    var group_id: String?
    
    //var storage : StorageReference!
    
    func initwithDictonary(dictValues:NSDictionary,id: String) -> ChatRoom {
        
       // type = ChatType(rawValue: dic.value(forKey: "type") as? String ?? "")
         ID = id
       //  isUnread = dic.value(forKey: "is_unread") as? String ?? ""
        //isActive = dic.value(forKey: "is_active") as? Bool
       // lastActiveTime = dic.value(forKey: "last_active_time") as? Double
       // device_token = dic.value(forKey: "device_token") as? String ?? ""
        //gmcount = dic.value(forKey: "gmcount")  as? String ?? ""
        
        group_id =  dictValues.value(forKey: "group_id") as? String
        
        let  dict = dictValues["group_member"] as? NSArray
        if dict?.count ?? 0 > 0
        {
            //let tempIndex =  dict!.indexOfObjectIdentical(to: NSNull.init())

            let FinalData = dict!.filter({$0 as! NSObject != NSNull.init()})
            
            for i in 0..<FinalData.count {
               
                let item = FinalData[i] as! NSDictionary
                let user = RoomUser().initwithDictonary(dic:item)
                group_member.add(user)
            }
        }
        else
        {
            let  dictNew = dictValues["group_member"] as? NSDictionary ?? [:]
            for key in dictNew.allKeys {
                let item = dictNew[key as? String ?? ""] as! NSDictionary
                let user = RoomUser().initwithDictonary(dic:item)
                group_member.add(user)

            }
        }
//        for key in dict.allKeys {
//            let item = dict[key as? String ?? ""] as! NSDictionary
//            let user = RoomUser().initwithDictonary(dic:item)
//            group_member.add(user)
//
//
//        }
        
        
      //  group_member.removeObject(identicalTo: NSNull.init())
       // let tempIndex =  group_member.indexOfObjectIdentical(to: NSNull.init())
        
       // group_member.removeObject(at: tempIndex)
        
        //Gadbad hai 
        let  dictUnread = dictValues["unread_messages_count"] as? NSArray
        
        if dictUnread?.count ?? 0 > 0
        {
            //let tempIndex =  dict!.indexOfObjectIdentical(to: NSNull.init())

            let FinalData = dictUnread!.filter({$0 as! NSObject != NSNull.init()})
           
            if FinalData.count > 0
            {
                arrCount = FinalData[0] as? NSDictionary
            }
            
        }
        else
        {
            arrCount = dictValues.value(forKey: "unread_messages_count") as? NSDictionary
        }
        
        
//        if dictValues.value(forKey: "unread_messages_count") != nil{
//            arrCount = dictValues.value(forKey: "unread_messages_count") as? NSDictionary
//        }
        
        if (dictValues.value(forKey: "last_user_message_details") != nil) {
          
            let info = dictValues.value(forKey: "last_user_message_details") as! NSDictionary
           
            if info.count > 0 {
                lastmsgTyp = MessageType(rawValue: info.value(forKey: "messages_type") as? String ?? "")
                name = info.value(forKey: "name") as? String ?? ""
            
                //storage = Storage.storage()
               // let storageref = storage.reference()
                
                imgurl = info.value(forKey: "image") as? String ?? ""
                
//               storage = Storage.storage().reference().child(("room_images") + "/" + (info.value(forKey: "roomImage") as? String ?? ""))
//
//                if (type == ChatType.group){
//                    let string = info.value(forKey: "roomImage") as? String ?? ""
//                    if string.contains("https:"){
//                        imgurl = info.value(forKey: "roomImage") as? String ?? ""
//                    }
//                }
//
                
                 messageLast = Message()
               
                    if (info.value(forKey: "message") != nil){
                        if let decodedData = Data(base64Encoded:info.value(forKey: "message") as? String ?? ""),
                            let decodedString = String(data: decodedData, encoding: .utf8) {
                            messageLast.text = decodedString
                        }
                    }
                    
                
//                else{
//                    if (info.value(forKey: "message") != nil){
//                        if let decodedData = Data(base64Encoded:info.value(forKey: "message") as? String ?? ""),
//                            let decodedString = String(data: decodedData, encoding: .utf8) {
//                            messageLast.media = decodedString
//                        }
//                    }
//                }
                
                messageLast.text = messageLast.text?.count == 0 ? "" : messageLast.text ?? ""
                messageLast.timeStamp = info.value(forKey: "time") as? Double
                messageLast.senderID = info.value(forKey: "senderId") as? String ?? ""
                messageLast.senderName = info.value(forKey:  "senderName" ) as? String ?? ""
                messageLast.mtype = info.value(forKey: "messages_type") as? String ?? ""
                
            }
        }
        
//        if dic.value(forKey: "room_sessions") != nil{
//            for key in (dic.value(forKey: "room_sessions") as! NSDictionary).allKeys
//            {
//                let dict = (dic.value(forKey: "room_sessions") as! NSDictionary)[key as? String ?? ""] as! NSDictionary
//                let roomSession = RoomSession()
//                roomSession.StartTime = dict.value(forKey: "start") as? Double
//                roomSession.ID = key as? String ?? ""
//                ARRroomsession.add(roomSession)
//            }
//        }
   
        return self
    }
    
  
}

class RoomSession: NSObject {
    var ID : String?
    var StartTime : Double!
    

    // var type : ChatTyp
    func initwithDictonary(dic:NSDictionary,Id:String) -> RoomSession {
        ID = Id
        StartTime = dic.value(forKey: "start") as? Double

        return self
    }
}



class RoomUser: NSObject {
  
    var user_id : String?
    var firebase_id: String?
    var user_name : String?
    var user_image : String?
    var is_online: Int?
    var joining_time : String?
    var is_archived : Int?
    
    // var type : ChatType
    
    func initwithDictonary(dic:NSDictionary) -> RoomUser {
        user_id = String(dic.value(forKey: "user_id") as? Int ?? 0)
        firebase_id = dic.value(forKey: "firebase_id") as? String ?? ""
        user_name = dic.value(forKey: "user_name") as? String ?? ""
        user_image = dic.value(forKey: "user_image") as? String ?? ""
        is_online = dic.value(forKey: "is_online") as? Int ?? 0
        is_archived = dic.value(forKey: "is_archived") as? Int ?? 0
        return self
    }
}


class RoomUserTemp: NSObject {
    var ID : String?
    var isAdmin : String?
    var isActive : Bool!
    var firstName : String?
    var teamname : String?
    var device_token : String?
    var lastName : String?
    var image : String?
    // var type : ChatType
    
    func initwithDictonary(dic:NSDictionary,Id:String) -> RoomUserTemp {
        ID = Id
        teamname = dic.value(forKey: "user_name") as? String ?? ""
        isAdmin = dic.value(forKey: "is_admin") as? String ?? ""
        image = dic.value(forKey: "user_image") as? String ?? ""
        return self
    }
}
