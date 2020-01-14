//
//  ChatBoxViewController.swift
//  My Chat
//
//  Created by Trần Đình Tôn Hiếu on 1/7/20.
//  Copyright © 2020 Trần Đình Tôn Hiếu. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase

class ChatBoxViewController : UIViewController {
    
    public var friendId:String?
    public var currentUser:User?
    public var currentChatBox:Chat?
    public var messages:Array<Message?>?
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    
    private let blueColor = UIColor(displayP3Red: 42/255, green: 129/255, blue: 186/255, alpha: 1)
    
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var callButton: UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initUI()
        
        messages = Array()
        
        // Update avatar for Friend in chat box
        let friendRef = Database.database().reference().child("users").child(friendId!)
        friendRef.observe(.value, with: {(snapshot)->Void in
            let dict = snapshot.value as? NSDictionary
            let avatarUrl = dict!["avatarUrl"] as? String
            let name = dict!["name"] as? String
            PhotoHelper.shared.asyncLoadingPhoto(url: avatarUrl, imageView: self.avatarImageView!)
            self.nameLabel.text = name!
        })
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
        
        // Fetch all data once time
        let messRef = Database.database().reference().child("messages").child((currentChatBox?.chatId!)!)
        messRef.observeSingleEvent(of: .value, with:{(snapshot) in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let dict = snap.value as? NSDictionary
                let fromId = dict!["fromId"] as? String
                let toId = dict!["toId"] as? String
                let seen = dict!["seen"] as? Bool
                let ts = dict!["ts"] as? Int64
                let message = dict!["message"] as? String
                let id = dict!["id"] as? String
                
                let mess = Message(id:id!, from: fromId!, to: toId!, message: message!, ts: ts!, seen: seen!)
                self.messages?.append(mess)
                self.reloadData()
            }
        })
        
        // Observer for chat message
        let ref = Database.database().reference().child("messages").child((currentChatBox?.chatId!)!)
        ref.observe(.childAdded, with: {(snapshot) in
            let dict = snapshot.value as? NSDictionary
            let fromId = dict!["fromId"] as? String
            let toId = dict!["toId"] as? String
            let seen = dict!["seen"] as? Bool
            let ts = dict!["ts"] as? Int64
            let message = dict!["message"] as? String
            let id = dict!["id"] as? String
            
            let mess = Message(id:id!, from: fromId!, to: toId!, message: message!, ts: ts!, seen: seen!)
            self.messages?.append(mess)
            self.reloadData()
        })
    }
    
    func reloadData() {
        collectionView.reloadData()
    }
    
    func initUI() {
        headerView.backgroundColor = .white
        headerView.layer.masksToBounds = false
        headerView.layer.shadowRadius = 2
        headerView.layer.shadowOffset = .zero
        headerView.layer.shadowOpacity = 0.5
        
        self.setRoundedView(view: avatarImageView)
        
        let backIcon = PhotoHelper.shared.resizeImage(image: UIImage(named: "back")!.withTintColor(blueColor), size: CGSize.init(width: 20, height: 20))
        backButton.setImage(backIcon, for: UIControl.State.normal)
        backButton.tintColor = .blue
        
        let phoneIcon = PhotoHelper.shared.resizeImage(image: UIImage(named: "phone")!.withTintColor(blueColor), size: CGSize.init(width: 20, height: 20))
        callButton.setImage(phoneIcon, for: UIControl.State.normal)
        
        let sendIcon = PhotoHelper.shared.resizeImage(image: UIImage(named: "send")!.withTintColor(blueColor), size: CGSize.init(width: 30, height: 30))
        sendButton.setImage(sendIcon, for: .normal)
    }
    
    func setRoundedView(view:UIView) {
        view.layer.cornerRadius = view.frame.width / 2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendButtonTapped(_ sender: Any) {
        self.view.endEditing(true)
        let randomStr = StringHelper.shared.genRandomString(length: 20)
        let timestamp = NSDate().timeIntervalSince1970
        let message = Message(id: randomStr, from: (currentUser?.id!)!, to: friendId!, message: textField.text!, ts: Int64(timestamp), seen: false)
        
        let myRef = Database.database().reference().child("messages").child((currentChatBox?.chatId!)!)
        myRef.child(message.id!).setValue(message.getDictionary())
    }
}

extension ChatBoxViewController : UICollectionViewDelegate ,UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatMessageCell
        
        cell.messageTextView.text = messages?[indexPath.row]?.message
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.messages?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let messageText = self.messages?[indexPath.row]?.message {
            let size = CGSize(width: view.frame.width, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let estimatedFrame = NSString(string: messageText).boundingRect(with: size, options: options, attributes:[NSAttributedString.Key.font:UIFont.systemFont(ofSize: 18)], context: nil)
            
            return CGSize(width: view.frame.width, height: estimatedFrame.height + 20)
        }
        
        return CGSize(width: view.frame.width, height: 100)
    }
}

class ChatMessageCell : BaseCell {
    let messageTextView:UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.text = "Sample message"
        textView.backgroundColor = UIColor.clear
        return textView
    }()
    
    override func setUpViews() {
        super.setUpViews()
        
        backgroundColor = .lightGray
        addSubview(messageTextView)
        addConstraintWithFormat(format: "H:|[v0]|", views: messageTextView)
        addConstraintWithFormat(format: "V:|[v0]|", views: messageTextView)
    }
}
