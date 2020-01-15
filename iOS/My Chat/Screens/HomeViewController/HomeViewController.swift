//
//  HomeViewController.swift
//  My Chat
//
//  Created by Trần Đình Tôn Hiếu on 11/17/19.
//  Copyright © 2019 Trần Đình Tôn Hiếu. All rights reserved.
//

import Foundation
import SwiftUI

class HomeViewController: UIViewController {
    
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var searchIcon: UIImageView!
    @IBOutlet weak var searchBoxView: UIView!
    @IBOutlet weak var chatTable: UITableView!
    
    private var currentUser:User?
    private var chatList:Array<Chat?>?
    private var rowList:Array<UITableViewCell>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view!.backgroundColor = .white
        
        currentUser = ProfileBusiness.shared.getCurrentUser()
        
        ChatBusiness.shared.fetchListOfChatBoxListener = self
        
        chatTable.delegate = self
        chatTable.dataSource = self
        chatTable.separatorStyle = .none
        chatTable.tableFooterView = UIView(frame: .zero)
        
        self.setRoundedView(view: cameraButton!)
        self.setRoundedView(view: editButton!)
        self.setRoundedView(view: avatarImageView!)
        
        self.createRoundedButton(button: cameraButton, image: UIImage.init(named: "camera_icon")!)
        self.createRoundedButton(button: editButton, image: UIImage.init(named: "edit_icon")!)
        
        let searchIconImage = UIImage.init(named: "search")?.withTintColor(.darkGray)
        self.searchIcon.image = searchIconImage!
        
        self.searchBoxView.layer.cornerRadius = 25
        self.searchBoxView.backgroundColor = UIColor.init(displayP3Red: 229/255, green: 231/255, blue: 233/255, alpha: 1)
        
        PhotoHelper.shared.asyncLoadingPhoto(url: currentUser?.avatarUrl, imageView: avatarImageView!)
        
        chatList = Array()
        rowList = Array()
        
        self.rowList?.removeAll()
        chatTable.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ChatBusiness.shared.fetchListOfChatBox(user: currentUser)
    }
    
    // MARK: Init Views
    func setRoundedView(view:UIView) {
        view.layer.cornerRadius = view.frame.width / 2
    }
    
    func createRoundedButton(button:UIButton, image:UIImage) {
        let icon = PhotoHelper.shared.resizeImage(image: image, size: CGSize.init(width: 20, height: 20))
        button.setImage(icon, for: UIControl.State.normal)
        button.tintColor = .black
        button.backgroundColor = UIColor.init(displayP3Red: 229/255, green: 231/255, blue: 233/255, alpha: 1)
    }
    
    @IBAction func avatarImageViewTapped(_ sender: Any) {
        self.navigationController?.pushViewController(ProfileViewController(), animated: true)
    }
    
    func reloadData() {
        self.chatTable.reloadData()
    }
}

extension HomeViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: "")
        cell.heightAnchor.constraint(equalToConstant: 90).isActive = true
        cell.contentMode = .center
        
        let tableRowView = ChatTableRow()
        tableRowView.setUpViewWith(name: chatList?[indexPath.row]?.name, lastMess: chatList?[indexPath.row]?.lastMessenger, messState: chatList?[indexPath.row]?.messState, avatarUrl: chatList?[indexPath.row]?.avatarUrl)
        rowList!.append(cell)
        
        let button = UIButton(frame: cell.bounds)
        cell.addSubview(button)
        button.addTarget(self, action: #selector(cellTouchDownHandle(sender:)), for: .touchDown)
        
        cell.contentMode = .scaleToFill
        cell.addSubview(tableRowView)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    @objc func cellTouchDownHandle(sender:UIButton) {
        for (i,cell) in rowList!.enumerated() {
            if i < chatList!.count {
                if cell == sender.superview {
                    let vc = ChatBoxViewController()
                    vc.currentUser = ProfileBusiness.shared.getCurrentUser()
                    vc.currentChatBox = chatList?[i]
                    let ids = chatList?[i]?.chatId?.components(separatedBy: "_")
                    vc.friendId = ids![1]
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true, completion: nil)
                }
            }
        }
    }
}

extension HomeViewController : FetchListOfChatBoxListener {
    func fetchListOfChatBoxDidStart() {
        
    }
    
    func fetchListOfChatBoxDidEnd(chatList: Array<Chat?>) {
        self.chatList = chatList
        
        self.rowList?.removeAll()
        self.reloadData()
    }
}
