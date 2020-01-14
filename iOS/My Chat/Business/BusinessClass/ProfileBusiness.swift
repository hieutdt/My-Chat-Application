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
import FacebookCore

protocol FetchFacebookDataListener {
    func fetchFacebookDataDidStart()
    func fetchFacebookDataDidEnd(name:String!, avatarUrl:String!)
}

class ProfileBusiness: NSObject {
    static let shared = ProfileBusiness()
    public var fetchFacebookDataListener:FetchFacebookDataListener?
    private var currentUser:User?
    
    public var token:String?
    
    private override init() {
        super.init()
        currentUser = User()
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
    
    public func getCurrentUser()->User {
        return currentUser!
    }
    
    public func fetchFacebookData() {
        self.fetchFacebookDataListener?.fetchFacebookDataDidStart()
        
        let connection = GraphRequestConnection()
        connection.add(GraphRequest(graphPath: "/me", parameters: ["fields":"name, picture.type(large)"])) { httpResponse, result, error in
            if error != nil {
                NSLog(error.debugDescription)
                return
            }
            var facebookName:String?
            var facebookUrl:String?

            // Handle vars
            if let result = result as? NSDictionary,
                let name = result["name"] as? String {
                facebookName = name
            }
            
            if let result = result as? NSDictionary,
                let picture = result["picture"] as? NSDictionary,
                let data = picture["data"] as? NSDictionary,
                let url = data["url"] as? String {
                print("TON HIEU url = \(url)")
                facebookUrl = url
            }
            
            self.fetchFacebookDataListener?.fetchFacebookDataDidEnd(name:facebookName, avatarUrl: facebookUrl)
        }
        connection.start()
    }
    
    public func createCurrentUser(id:String!, name:String!, state:String!, avatarUrl:String!, friendList:Array<String?>!) {
        currentUser = User(id: id, name: name, state: state, avatarUrl: avatarUrl, friendList: friendList)
    }
    
    public func setCurrentUser(user:User!) {
        self.currentUser = user
    }
}
