//
//  FriendViewController.swift
//  My Chat
//
//  Created by Trần Đình Tôn Hiếu on 11/17/19.
//  Copyright © 2019 Trần Đình Tôn Hiếu. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase

class FriendViewController : UIViewController {
    @IBOutlet weak var addFriendButton: UIButton!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view!.backgroundColor = .white
        
        self.setRoundedView(view: avatarImageView!)
        self.setRoundedView(view: addFriendButton!)
        
        self.createRoundedButton(button: addFriendButton!, image: UIImage(named: "addFriend_icon")!)
        
        ChatBusiness.shared.createNewChatBoxListener = self
        
        PhotoHelper.shared.asyncLoadingPhoto(url: ProfileBusiness.shared.getCurrentUser().avatarUrl, imageView: avatarImageView)
    }
    
    func setRoundedView(view:UIView) {
        view.layer.cornerRadius = view.frame.width / 2
    }
    
    func createRoundedButton(button:UIButton, image:UIImage) {
        let icon = PhotoHelper.shared.resizeImage(image: image, size: CGSize.init(width: 20, height: 20))
        button.setImage(icon, for: UIControl.State.normal)
        button.tintColor = .black
        button.backgroundColor = UIColor.init(displayP3Red: 229/255, green: 231/255, blue: 233/255, alpha: 1)
    }
    
    @IBAction func addFriendButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Thêm cuộc hội thoại mới", message: "Tạo một cuộc hội thoại mới với bạn bè của mình", preferredStyle: .alert)
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Nhập ID của bạn bè:"
        })
        alert.addAction(UIAlertAction(title: "Huỷ", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Xác nhận", style: .default, handler: {(alertAction)->Void in
            if let id = alert.textFields?.first?.text {
                let ref = Database.database().reference()
                ref.child("users").child(id).observe(.value, with: {(snapshot) in
                    let dict = snapshot.value as? NSDictionary
                    if (dict) != nil {
                        let friendListArray = dict?["friendList"] as? Array<String?>
                        let name = dict?["name"] as? String
                        let avatarUrl = dict?["avatarUrl"] as? String
                        let state = dict?["state"] as? String
                        
                        let friend = User(id: id, name: name, state: state, avatarUrl: avatarUrl, friendList: friendListArray)
                        
                        ChatBusiness.shared.createNewChatBox(friend: friend, user: ProfileBusiness.shared.getCurrentUser())
                    } else {
                        self.showMessageDialog(title: "Thất bại", mess: "ID người dùng không tồn tại!")
                    }
                })
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func avatarButtonTapped(_ sender: Any) {
        
    }
    
    func showMessageDialog(title:String!, mess:String!) {
        let alert = UIAlertController(title: title, message: mess, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
 

extension FriendViewController : CreateNewChatBoxListener {
    func createNewChatBoxDidStart() {
        
    }
    
    func createNewChatBoxDidEnd(state: String!) {
        self.showMessageDialog(title: state, mess: "")
    }
}
