//
//  ChatBusiness.swift
//  My Chat
//
//  Created by Trần Đình Tôn Hiếu on 1/14/20.
//  Copyright © 2020 Trần Đình Tôn Hiếu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

protocol FetchListOfChatBoxListener {
    func fetchListOfChatBoxDidStart()
    func fetchListOfChatBoxDidEnd(chatList:Array<Chat?>)
}

protocol CreateNewChatBoxListener {
    func createNewChatBoxDidStart()
    func createNewChatBoxDidEnd(state:String!)
}

class ChatBusiness: NSObject {
    static let shared = ChatBusiness()
    
    public var fetchListOfChatBoxListener:FetchListOfChatBoxListener?
    public var createNewChatBoxListener:CreateNewChatBoxListener?
    
    private override init() {
        super.init()
    }
    
    public func fetchListOfChatBox(user:User!) {
        self.fetchListOfChatBoxListener?.fetchListOfChatBoxDidStart()
        
        var chatList = Array<Chat?>()
        let ref = Database.database().reference()
        ref.child("chatbox").child(user.id!).observe(.value, with: {(snapshot) in
            print("TON HIEU: \(snapshot)")
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let dict = snap.value as? NSDictionary
                let chatId = dict!["chatId"] as? String
                let name = dict!["name"] as? String
                let lastMessage = dict!["lastMessenger"] as? String
                let messState = dict!["messState"] as? String
                let friendIsOnline = dict!["friendIsOnline"] as? Bool
                let ts = dict!["ts"] as? Int64
                let avatarUrl = dict!["avatarUrl"] as? String
                
                let chatBox = Chat(chatId: chatId!, name: name!, lastMessenger: lastMessage!, messState: messState!, friendIsOnline: friendIsOnline, ts: ts!, avatarUrl: avatarUrl!)
                chatList.append(chatBox)
            }
            
            self.fetchListOfChatBoxListener?.fetchListOfChatBoxDidEnd(chatList: chatList)
            
            ref.removeAllObservers()
        })
    }
    
    public func createNewChatBox(friend:User!, user:User!) {
        self.createNewChatBoxListener?.createNewChatBoxDidStart()
        
        let ref = Database.database().reference()
        
        ref.child("chatbox").child(user.id!).child("\(user.id!)_\(friend.id!)").observe(.value, with: {(snapshot) in
            let dict = snapshot.value as? NSDictionary
            
            if dict != nil {
                self.createNewChatBoxListener?.createNewChatBoxDidEnd(state: "Cuộc hội thoại đã tồn tại")
            } else {
                let timestamp = NSDate().timeIntervalSince1970
                let chatBox = Chat(chatId: "\(user.id!)_\(friend.id!)", name: friend.name!, lastMessenger: "Hãy gửi tin nhắn chào bạn của mình nào!", messState: "SEEN", friendIsOnline: false, ts: Int64(timestamp), avatarUrl: friend.avatarUrl!)
                let chatBoxDic = chatBox.toDictionary()
                
                ref.child("chatbox").child(user.id!).child("\(user.id!)_\(friend.id!)").setValue(chatBoxDic)
                
                self.createNewChatBoxListener?.createNewChatBoxDidEnd(state: "Tạo cuộc hội thoại thành công")
            }
            
            ref.removeAllObservers()
        })
    }
}
