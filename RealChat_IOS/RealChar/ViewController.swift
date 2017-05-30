//
//  ViewController.swift
//  RealChat
//


import UIKit
import Foundation
import RealmSwift

import Firebase
import FirebaseCore
import FirebaseDatabase



class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let ref = FIRDatabase.database().reference()
    

    @IBOutlet weak var chatList: UITableView!
    
    @IBOutlet weak var inputText: UITextField!
    
    
    @IBAction func sendBt(_ sender: Any) {
        //Chat.sharedManager.addMessagesToChat(message_from: self.myNickmane, message_text: self.inputText.text!)
    }
    
    var currentChatName:String = ""
    var myNickmane = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.chatList.delegate = self
        self.chatList.dataSource = self
        
        self.chatList.estimatedRowHeight = 100.0
        self.chatList.rowHeight = UITableViewAutomaticDimension
        
        Chat.sharedManager.currentChatName = self.currentChatName
        
        self.inputText.becomeFirstResponder()
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.updateList), name: Notification.Name("UpdateChatMessagesFromCurrentChatRoom"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        //  Chat.sharedManager.updateChatMessagesFromCurrentChatRoom()
        
        
        self.chatList.backgroundColor = UIColor.clear
        
        if(self.myNickmane.isEmpty) {
            let alert = UIAlertController(title: "Enter you Nick name", message: "", preferredStyle: .alert)
            
            alert.addTextField { (textField) in}
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                let textField = alert?.textFields?.first
                self.myNickmane = (textField?.text)!
            }))
            
            self.present(alert, animated: true, completion: nil)
            return
        }
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("UpdateChatMessagesFromCurrentChatRoom"), object: nil)
    }
    
    
    func keyboardWillShow(notification: NSNotification)  {
        if let userInfo = notification.userInfo {
            if let keyboardHeight = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.height {
                print("keyboardHeight",keyboardHeight)
                self.chatList.contentOffset = CGPoint(x:0,y:keyboardHeight)
                UIView.animate(withDuration: 0.25, animations: { () -> Void in
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
    
    
    func updateList() {
        DispatchQueue.main.async {
            self.chatList.reloadData()
            
            let numberOfRows = self.chatList.numberOfRows(inSection: 0)
            let indexPath = IndexPath(row: numberOfRows-1 , section: 0)
            self.chatList.scrollToRow(at: indexPath,
                                      at: UITableViewScrollPosition.middle, animated: true)
        }
    }
    
    
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "messages_cell", for: indexPath)
        return cell
        
    }
    
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    
}

