//
//  User.swift
//  My Chat
//
//  Created by Trần Đình Tôn Hiếu on 1/14/20.
//  Copyright © 2020 Trần Đình Tôn Hiếu. All rights reserved.
//

import Foundation
import UIKit

class User : NSObject {
    public var id:String?
    public var name:String?
    public var state:String?
    public var avatarUrl:String?
    public var friendList:Array<String?>?
    
    override init() {
        self.id = StringHelper.shared.genRandomString(length: 20)
        self.name = ""
        self.state = "Offline"
        self.avatarUrl = ""
        self.friendList = Array()
    }
    
    public init(id:String!, name:String!, state:String!, avatarUrl:String!, friendList:Array<String?>!) {
        self.id = id
        self.name = name
        self.state = state
        self.avatarUrl = avatarUrl
        self.friendList = friendList
    }
    
    public func getDictionary() -> Dictionary<String, Any> {
        let dic = ["id":self.id!, "name":self.name!, "state":self.state!, "avatarUrl":self.avatarUrl!, "friendList":self.friendList!] as [String : Any]
        return dic as Dictionary<String, Any>
    }
}
