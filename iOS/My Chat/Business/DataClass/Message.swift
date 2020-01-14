//
//  Message.swift
//  My Chat
//
//  Created by Trần Đình Tôn Hiếu on 1/14/20.
//  Copyright © 2020 Trần Đình Tôn Hiếu. All rights reserved.
//

import UIKit

class Message: NSObject {
    public var id:String?
    public var fromId:String?
    public var toId:String?
    public var ts:Int64?
    public var seen:Bool?
    public var message:String?
    
    override init() {
        id = StringHelper.shared.genRandomString(length: 20)
        fromId = ""
        toId = ""
        ts = 0
        seen = false
        message = ""
    }
    
    public init(id:String, from:String, to:String, message:String, ts:Int64, seen:Bool) {
        self.id = id
        self.fromId = from
        self.toId = to
        self.message = message
        self.ts = ts
        self.seen = seen
    }
    
    public func getDictionary() -> Dictionary<String, Any> {
        let dic = ["id":self.id!, "fromId":self.fromId!, "toId":self.toId!, "ts":self.ts!, "seen":self.seen!, "message":self.message!] as [String : Any]
        return dic as Dictionary<String, Any>
    }
}
