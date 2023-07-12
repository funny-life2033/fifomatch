
//
//  ChatManager.swift
//  SportsJunki
//
//  Created by octal on 03/05/19.
//  Copyright © 2019 Admin octal. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ChatManager: NSObject {
  
  var user : String?
  var userimage : String?
  var LoginUser = NSMutableArray()
  
  override init(){
    
    user = String(userID)
    userimage = profileImage
  }
  
  func getUserLListFromFIR(userId: String, child: String, completion: @escaping (_ result: NSDictionary) -> Void)
  {
    
    var dictonary: NSDictionary?
    Constants.refs.databaseUsers.child(userId).child(child).observe(.value) { (snapshoot) in
      
      if(snapshoot.exists()){
        
        dictonary = snapshoot.value as? NSDictionary
        completion(dictonary ?? [:])
      }
    }
    
    
  }
  
  func chatList(completion: @escaping (_ result: NSDictionary) -> Void){
    
    Constants.refs.databaseChats.observe(.value) { (snapshot) in
      if(snapshot.exists()){
        var arrRooms : NSDictionary = [:]
        
        arrRooms = (snapshot.value as? NSDictionary)!
        
        
        completion(arrRooms )
      }
    }
  }
  
  
  func filterWithTime(userRooms: NSArray, child: String, completion: @escaping (_ result: NSMutableArray) -> Void)  {
    
    Constants.refs.databaseChats.queryOrdered(byChild: "last_user_message_details/time") .observe(.value) { (snapshoot) in
      if(snapshoot.exists()){
        let arrRooms : NSMutableArray = []
        
        for snap in snapshoot.children{
          
          if ((userRooms).contains((snap as! DataSnapshot).key)) {
            for newsnap in (snap as! DataSnapshot).children{
              var room : ChatRoom!
              if (((newsnap as! DataSnapshot).key) == "last_user_message_details"){
                
                room = ChatRoom().initwithDictonary(dictValues: ((snap as! DataSnapshot).value as! NSDictionary),id:(snap as! DataSnapshot).key)
                
                arrRooms.add(room as ChatRoom)
                
              }
            }
          }
        }
        completion(arrRooms)
      }
    }
  }
  
  func roomDetails(room: String, completion: @escaping (_ result: ChatRoom) -> Void){
    
    if appdelegate.window?.visibleViewController()?.className ?? "" == "ChatDetailVC"
    {
      Constants.refs.databaseChats.child(room).observe(.value) { (DataSnapshot) in
        if(DataSnapshot.exists()){
          if appdelegate.window?.visibleViewController()?.className ?? "" == "ChatDetailVC"
          {
            var chatroom : ChatRoom = ChatRoom()
            chatroom = ChatRoom().initwithDictonary(dictValues: (DataSnapshot.value as! NSDictionary),id: DataSnapshot .key)
            completion(chatroom)
          }
        }
      }
    }
    
  }
  func roomList(user: String, child: String, completion: @escaping (_ result: NSArray) -> Void){
    
    Constants.refs.databaseUsers.child(user).child(child).observe(.value) { (snapshot) in
      
      var arrRooms : NSArray = []
      if(snapshot.exists()){
        
        arrRooms = (snapshot.value as? NSArray)!
        
      }
      completion(arrRooms)
      
    }
  }
  
  func sendMessage(data: String, type: MessageType, room: String, rooms: ChatRoom, count: Int, completion: @escaping (_ sent:Bool) -> Void) {
    
    let base64Data: Data? = data.data(using: .utf8)
    
    let base64Str = base64Data!.base64EncodedString(options: [])
    
    let userId = UserDefault.shared.getUserId() ?? 0
    let userName = UserDefault.shared.getUserName()
    
    let data = ["sender_id" : "\(userId)",
                "message" : type == MessageType.MediaMessage ? "" : base64Str,
                "time" : ServerValue.timestamp() as NSDictionary,
                "messages_type" : "text",
                "media" : type == MessageType.MediaMessage ? base64Str : "",
                "sender_name" : userName,
                "sender_image" : profileImage
                
    ] as [String : Any]
    
    // let FirstUser = toRoomUser.firstObject as! RoomUser
    // let secondUser = toRoomUser[1] as! RoomUser
    
    let latestMessage1 = ["id": "\(userId)",
                          "image": profileImage,
                          "name": userName,
                          "message": base64Str,
                          "time":ServerValue.timestamp() as NSDictionary,
                          "messages_type": "text"
                          
    ] as [String : Any]
    
    if  rooms.arrCount != nil {
      let ids = rooms.arrCount.allKeys
      for key in ids {
        if key as? String != String("user_\(userId)"){
          
          
          guard let keys = key as? String else {
            return
          }
          
          Constants.refs.databaseChats.child(room).child("unread_messages_count").updateChildValues([keys: count])
          Constants.refs.databaseChats.child(room).child("unread_messages_count").updateChildValues(["user_\(userId)": 0])
        }
      }
      
    }
    Constants.refs.databaseChats.child(room).updateChildValues(["last_user_message_details" : latestMessage1])
    
    Constants.refs.databasemessages.child(room ).childByAutoId() .setValue(data) { (error, DatabaseReference) in
      if((error == nil)) {
        completion(true)
      }else{
        completion(false)
      }
    }
    
  }
  
  
  func sendMessageViaImage(data: String, type: MessageType, room: String, count: Int, rooms: ChatRoom, completion: @escaping (_ sent: Bool) -> Void) {
    
    let userId = UserDefault.shared.getUserId() ?? 0
    
    let base64Data: Data? = data.data(using: .utf8)
    let base64Str = base64Data!.base64EncodedString(options: [])
    let data = ["sender_id" : userId ,
                "message" : type == MessageType.MediaMessage ? "" : base64Str,
                "time" : ServerValue.timestamp() as NSDictionary,
                "messages_type" : "image",
                "media" : type == MessageType.MediaMessage ? base64Str : "",
                "sender_name" : fullName,
                "sender_image" : profileImage] as [String : Any]
    
    
    
    let latestMessage1 = ["id": userId,
                          "image": profileImage,
                          "name": fullName,
                          "message": base64Str ,
                          "time":ServerValue.timestamp() as NSDictionary,
                          "messages_type": "image"] as [String : Any]
    
    
    if  rooms.arrCount != nil {
      let ids = rooms.arrCount.allKeys
      for key in ids {
        if key as? String != String("user_\(userId)"){
          
          //                    Constants.refs.databaseChats.child(room).child("unread_messages_count").child(key).updateChildValues([4])
          
          guard let keys = key as? String else {
            return
          }
          
          Constants.refs.databaseChats.child(room).child("unread_messages_count").updateChildValues([keys: count])
          Constants.refs.databaseChats.child(room).child("unread_messages_count").updateChildValues(["user_\(userId)": 0])
          
        }
      }
    }

    Constants.refs.databaseChats.child(room).updateChildValues(["last_user_message_details" : latestMessage1])
    
    Constants.refs.databasemessages.child(room ).childByAutoId() .setValue(data) { (error, DatabaseReference) in
      if((error == nil)) {
        completion(true)
      }else{
        completion(false)
      }
    }
    
  }
  
  func stopObserver(room:String) {
    
    Constants.refs.databasemessages .child(room) .removeAllObservers()
    
  }
  
  func previousMsg(room: String, completion: @escaping (_ arr: Array<Message>,_ sent: Bool) -> Void) {
    Constants.refs.databasemessages.child(room).queryOrdered(byChild: "time") .observeSingleEvent(of: .value, with: { (snapshoot) in
      
      var arr : Array<Message> = []
      if snapshoot.exists() {
        for snap in snapshoot.children {
          let message = Message().intdatawithsnapshot(snapshot: snap as! DataSnapshot)
          
          arr.append(message)
        }
        
        completion(arr,true)
      }
      else{
        completion(arr,false)
      }
      
    })
    
  }
  
  func newMessage(room:String,completion: @escaping (_ msg:Message,_ sent:Bool) -> Void) {
    Constants.refs.databasemessages.child(room).queryOrdered(byChild: "time") .observe(.childAdded) { (snapshoot) in
      
      if snapshoot.exists() {
        let message = Message().intdatawithsnapshot(snapshot: snapshoot)
        completion(message,true)
      }
      else{
        completion(Message(),false)
      }
      
    }
    
  }
  
  
  func getUserTimestamp(userId: String, completion: @escaping (_ result: NSDictionary) -> Void)
  {
    
    var dictonary: NSDictionary?
    Constants.refs.databaseUsers.child(userId).observe(.value) { (snapshoot) in
      
      if(snapshoot.exists()){
        
        dictonary = snapshoot.value as? NSDictionary
        completion(dictonary ?? [:])
      }
    }
    
    
  }
  
}
