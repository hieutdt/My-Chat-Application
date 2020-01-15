//
//  ProfileViewController.swift
//  My Chat
//
//  Created by Trần Đình Tôn Hiếu on 11/17/19.
//  Copyright © 2019 Trần Đình Tôn Hiếu. All rights reserved.
//

import Foundation
import UIKit

class ProfileViewController : UIViewController {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width/2
        PhotoHelper.shared.asyncLoadingPhoto(url: ProfileBusiness.shared.getCurrentUser().avatarUrl, imageView: avatarImageView!)
        
        nameLabel.text = ProfileBusiness.shared.getCurrentUser().name
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func logOutButtonTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "Xác nhận đăng xuất", message: "Bạn có muốn đăng xuất không?", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Có", style: .default, handler: {(UIAlertAction)->Void in
            ProfileBusiness.shared.logOut()
            self.navigationController?.popViewController(animated: false)
        }))
        alertController.addAction(UIAlertAction(title: "Không", style: .cancel, handler: nil))
        
        self.present(alertController, animated: true, completion:nil)
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
