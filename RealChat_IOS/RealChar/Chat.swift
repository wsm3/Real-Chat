//
//  Chat.swift
//  RealChat
//

import Foundation
import RealmSwift
import Firebase
import FirebaseCore
import FirebaseDatabase

import JSQMessagesViewController


private let _chatManager = Chat()

class Chat {
    let ref = FIRDatabase.database().reference()
    
    class var sharedManager: Chat {
        return _chatManager
    }
    
    var currentChatName = ""
    
    var roomsList = [""]
    
    var messages = [JSQMessage]()
    
    
    
    func updateRoomsLists(){
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        ref.child("rooms").observeSingleEvent(of: .value, with: { (snapshot) in
            if let snap = (snapshot.value as? NSDictionary) {
                for data in snap {
                    //                    if data.key as! String == "name" {
                    //                        self.roomsList.append(data.value as! String)
                    //                    }
                    self.roomsList.append(data.key as! String)
                }
                
                NotificationCenter.default.post(name: Notification.Name("UpdateRoomsList"), object: nil)
            }
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    
    
    
    
    func updateChatMessagesFromCurrentRoom(){
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        ref.child("rooms").child(self.currentChatName).child("messages").observe(FIRDataEventType.value, with: { (snapshot) in
            
            self.messages = [JSQMessage]()
            
            if let snap = (snapshot.value as? NSDictionary) {
                for jj in snap {
                    let value = jj.value as? NSDictionary
                    
                    if let senderId = value?["senderId"] as! String!, let senderName = value?["senderName"] as! String!, let text = value?["text"] as! String!, text.characters.count > 0 {
                        
                        if let message = JSQMessage(senderId: senderId, displayName: senderName, text: text) {
                            
                            self.messages.append(message)
                            
                            NotificationCenter.default.post(name: Notification.Name("UpdateMessages"), object: nil)
                        }
                    }
                }
                
            }
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    
    
    
    func addMessages(_ newMessage:Dictionary<String, String>) {
        let newRef = ref.child("messages").childByAutoId().key
        ref.child("rooms").child(self.currentChatName).child("messages").child(newRef).setValue(newMessage)
        
    }
    
    
    
}
