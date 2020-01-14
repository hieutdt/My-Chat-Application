//
//  ProfileBusiness.swift
//  My Chat
//
//  Created by Trần Đình Tôn Hiếu on 1/13/20.
//  Copyright © 2020 Trần Đình Tôn Hiếu. All rights reserved.
//

import UIKit
import Firebase
import FacebookLogin

class ProfileBusiness: NSObject {
    static let shared = ProfileBusiness()
    
    public var token:String?
    
    private override init() {
        super.init()
    }
    
    public func logInWithToken() {
        
    }
    
    public func hasLoggedInUser() -> Bool {
        if AccessToken.current != nil {
            return true
        }
        return false
    }
    
    public func logOut() {
        let loginManager = LoginManager()
        loginManager.logOut()
    }
}
