//
//  LogInViewController.swift
//  My Chat
//
//  Created by Trần Đình Tôn Hiếu on 11/17/19.
//  Copyright © 2019 Trần Đình Tôn Hiếu. All rights reserved.
//

import Foundation
import UIKit
import FacebookLogin
import Firebase
import FirebaseDatabase

class LogInViewController : UIViewController {
    
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var loginView: UIView!
    @IBOutlet var signUpFacebookButton: UIButton!
    private var whiteView:UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ProfileBusiness.shared.fetchFacebookDataListener = self
        
        let loginButton = FBLoginButton(frame: loginView.bounds, permissions: [.publicProfile])
        loginButton.center = loginView.center
        loginView.addSubview(loginButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
        if ProfileBusiness.shared.hasLoggedInUser() {
            whiteView = UIView(frame: self.view.bounds)
            whiteView?.backgroundColor = .white
            self.view.addSubview(whiteView!)
            
            ProfileBusiness.shared.fetchFacebookData()
        }
    }
    
    @IBAction func logInButtonTapped(_ sender: Any) {
        self.loginWithReadPermissions()
    }
    
    func loginManagerDidComplete(_ result: LoginResult) {
        let alertController: UIAlertController
        switch result {
        case .cancelled:
            alertController = UIAlertController(
                title: "Login Cancelled", message: "User cancelled login.",
                preferredStyle: .alert
            )
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))

        case .failed( _):
            alertController = UIAlertController(
                title: "Đăng nhập thất bại",
                message: "",
                preferredStyle: .alert
            )
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))

        case .success( _, _, _):
            alertController = UIAlertController(
                title: "Đăng nhập thành công",
                message: "",
                preferredStyle: .alert
            )
            
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {(UIAlertAction)->Void in
                ProfileBusiness.shared.fetchFacebookData()
            }))
        }
        self.present(alertController, animated: true, completion: nil)
    }

    @IBAction private func loginWithReadPermissions() {
        let loginManager = LoginManager()
        loginManager.logIn(
            permissions: [.publicProfile, .userFriends],
            viewController: self
        ) { result in
            self.loginManagerDidComplete(result)
        }
    }
}

extension LogInViewController : FetchFacebookDataListener {
    func fetchFacebookDataDidStart() {
        
    }
    
    func fetchFacebookDataDidEnd(name: String!, avatarUrl: String!) {
        ProfileBusiness.shared.createCurrentUser(id: AccessToken.current?.userID, name: name, state: "Online", avatarUrl: avatarUrl, friendList: Array())
        
        let user = ProfileBusiness.shared.getCurrentUser()
        let userDictionary = user.getDictionary()
        
        var ref:DatabaseReference!
        ref = Database.database().reference()
        
        ref?.child("users").child(user.id!).observe(.value, with: {(snapshot) in
            // Data handle in Firebase
            let dict = snapshot.value as? NSDictionary
            if (dict) != nil {
                let friendListArray = dict?["friendList"] as? Array<String?>
                user.friendList = friendListArray
                ProfileBusiness.shared.setCurrentUser(user: user)
            } else {
                ref?.child("users").child(user.id!).setValue(userDictionary)
            }
            
            // Remove white view
            if self.whiteView != nil{
                self.whiteView?.removeFromSuperview()
            }
            
            // Move to TabBarViewController
            self.navigationController?.popViewController(animated: false)
            self.navigationController?.pushViewController(TabBarController(), animated: false)
            
            // Remove observer
            ref?.removeAllObservers()
        })
    }
}
