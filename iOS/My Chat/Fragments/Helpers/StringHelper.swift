//
//  StringHelper.swift
//  My Chat
//
//  Created by Trần Đình Tôn Hiếu on 1/14/20.
//  Copyright © 2020 Trần Đình Tôn Hiếu. All rights reserved.
//

import Foundation
import UIKit

class StringHelper : NSObject {
    static let shared = StringHelper()
    
    private override init() {
        super.init()
    }
    
    public func genRandomString(length:Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
}
