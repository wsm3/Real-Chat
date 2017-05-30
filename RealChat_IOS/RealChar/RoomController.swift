//
//  RoomController.swift
//  RealChat
//





import UIKit
import Foundation

import JSQMessagesViewController



import Firebase
import FirebaseCore
import FirebaseDatabase
import FirebaseAuth

class RoomController: JSQMessagesViewController {
    
    lazy var outgoingBubbleImageView: JSQMessagesBubbleImage = self.setupOutgoingBubble()
    lazy var incomingBubbleImageView: JSQMessagesBubbleImage = self.setupIncomingBubble()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // No avatars
        collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero

        self.automaticallyScrollsToMostRecentMessage = true
        self.collectionView.collectionViewLayout.springinessEnabled = true
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(RoomController.updateMessages), name: Notification.Name("UpdateMessages"), object: nil)
        
        
        Chat.sharedManager.updateChatMessagesFromCurrentRoom()

        if(self.senderDisplayName.isEmpty) {
            FIRAuth.auth()?.signInAnonymously() { (user, error) in
                let uid = user!.uid
                self.senderId = uid
            }
            
            
            let alert = UIAlertController(title: "Enter you Nick name", message: "", preferredStyle: .alert)
            
            
            alert.addTextField { (textField) in}
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                let textField = alert?.textFields?.first
                self.senderDisplayName = (textField?.text)!
            }))
            
            self.present(alert, animated: true, completion: nil)
            return
        }
    }
    
    
    
    func updateMessages() {
        self.finishReceivingMessage()
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        
        print(date)
        
        let newMessageItem = [
            "senderId": senderId!,
            "senderName": senderDisplayName!,
            "text": text!,
            "timestamp" : String(Int(round(NSDate().timeIntervalSince1970))),
            ]
        
        print(newMessageItem)
        
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        
        Chat.sharedManager.addMessages(newMessageItem)
        
        self.finishSendingMessage()
    }
    
    
    
    
    private func setupOutgoingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
    }
    
    private func setupIncomingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
    }
    
    
    
    // MARK: - UICollectionViewDataSource protocol
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData!{
        return Chat.sharedManager.messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Chat.sharedManager.messages.count
    }
    
    
    
    override func  collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForCellTopLabelAt indexPath: IndexPath!) -> NSAttributedString! {
        
        let message = Chat.sharedManager.messages[indexPath.item]
        return NSAttributedString(string: message.senderDisplayName)
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellTopLabelAt indexPath: IndexPath!) -> CGFloat {
        return kJSQMessagesCollectionViewCellLabelHeightDefault
    }
    
    
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = Chat.sharedManager.messages[indexPath.item]
        if message.senderId == senderId {
            return outgoingBubbleImageView
        } else {
            //JSQSystemSoundPlayer.jsq_playMessageReceivedSound()
            return incomingBubbleImageView
        }
    }
    
    
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        
        
        return nil
    }
    

    // MARK: - UICollectionViewDelegate protocol
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
    }
}
