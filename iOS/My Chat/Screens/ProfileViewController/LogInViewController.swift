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

class LogInViewController : UIViewController {
    
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var loginView: UIView!
    @IBOutlet var signUpFacebookButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loginButton = FBLoginButton(frame: loginView.bounds, permissions: [.publicProfile])
        loginButton.center = loginView.center
        loginView.addSubview(loginButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
        if ProfileBusiness.shared.hasLoggedInUser() {
            self.navigationController?.popViewController(animated: false)
            self.navigationController?.pushViewController(TabBarController(), animated: false)
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

        case .failed(let error):
            alertController = UIAlertController(
                title: "Login fail.",
                message: "User login failed with error \(error)",
                preferredStyle: .alert
            )
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))

        case .success(let grantedPermissions, _, _):
            alertController = UIAlertController(
                title: "Login Success",
                message: "Login success with \(grantedPermissions)",
                preferredStyle: .alert
            )
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {(UIAlertAction)->Void in
                self.navigationController?.popViewController(animated: false)
                self.navigationController?.pushViewController(TabBarController(), animated: false)
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

