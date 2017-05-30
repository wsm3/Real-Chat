//
//  RoomsList.swift
//  RealChat
//


import Foundation
import UIKit
import RealmSwift


class RoomsList: UITableViewController  {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(RoomsList.updateList), name: Notification.Name("UpdateRoomsList"), object: nil)
        
        
        Chat.sharedManager.updateRoomsLists()
        
        
    }
    
    func updateList() {
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  Chat.sharedManager.roomsList.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = Chat.sharedManager.roomsList[indexPath.row]
        return cell
        
    }
    
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "enter_chat_room" {
            if let indexPath = tableView.indexPathForSelectedRow {
                
                let nav = segue.destination as! UINavigationController
                let vc = nav.topViewController as! RoomController
                
                Chat.sharedManager.currentChatName = Chat.sharedManager.roomsList[indexPath.row]
                
                vc.senderId = ""
                vc.senderDisplayName = ""
            }
        }
    }
}
