//
//  Chat.swift
//  My Chat
//
//  Created by Trần Đình Tôn Hiếu on 1/7/20.
//  Copyright © 2020 Trần Đình Tôn Hiếu. All rights reserved.
//

import Foundation

class Chat {
    public var name:String?
    public var lastMessenger:String?
    public var messState:String?
    public var friendIsOnline:Bool?
    
    init(name:String!, lastMessenger lastMess:String!, messState:String!, friendIsOnline:Bool!) {
        self.name = name
        self.lastMessenger = lastMess
        self.messState = messState
        self.friendIsOnline = friendIsOnline
    }
}
