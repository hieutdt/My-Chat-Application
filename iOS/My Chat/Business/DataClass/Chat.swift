//
//  Chat.swift
//  My Chat
//
//  Created by Trần Đình Tôn Hiếu on 1/7/20.
//  Copyright © 2020 Trần Đình Tôn Hiếu. All rights reserved.
//

import Foundation
import UIKit

class Chat : NSObject  {
    public var chatId:String?
    public var name:String?
    public var lastMessenger:String?
    public var messState:String?
    public var friendIsOnline:Bool?
    public var ts:Int64
    public var avatarUrl:String?
    
    init(chatId:String!, name:String!, lastMessenger lastMess:String!, messState:String!, friendIsOnline:Bool!, ts:Int64, avatarUrl:String!) {
        self.chatId = chatId
        self.name = name
        self.lastMessenger = lastMess
        self.messState = messState
        self.friendIsOnline = friendIsOnline
        self.ts = ts
        self.avatarUrl = avatarUrl
    }
    
    public func toDictionary() -> Dictionary<String,Any> {
        let dict = ["chatId":self.chatId!, "name":self.name!, "lastMessenger":self.lastMessenger!, "messState":self.messState!, "friendIsOnline":self.friendIsOnline!, "ts":ts, "avatarUrl":self.avatarUrl] as [String : Any]
        return dict
    }
}
