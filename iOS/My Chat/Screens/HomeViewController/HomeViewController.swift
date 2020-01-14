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
    private var chatList:Array<Chat>?
    private var rowList:Array<ChatTableRow>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view!.backgroundColor = .white
        
        currentUser = ProfileBusiness.shared.getCurrentUser()
        
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
        
        let firstChat = Chat(name: "Trương Hiền Minh", lastMessenger: "Cái dkm m điên à :)", messState: "STATE_SEEN", friendIsOnline: true)
        let secondChat = Chat(name: "Lộc Võ", lastMessenger: "Đkm Lộc óc chó vl", messState: "STATE_SENT", friendIsOnline: true)
        let thirdChat = Chat(name: "Anh Dũng Phạm Văn", lastMessenger: "Ê Hiếu bài này làm sao?", messState: "STATE_SEEN", friendIsOnline: false)
        
        chatList = Array()
        chatList?.append(firstChat)
        chatList?.append(secondChat)
        chatList?.append(thirdChat)
        
        rowList = Array()
        
        chatTable.reloadData()
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
}

extension HomeViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init()
        cell.heightAnchor.constraint(equalToConstant: 90).isActive = true
        cell.contentMode = .center
        
        let tableRowView = ChatTableRow()
        tableRowView.setUpViewWith(name: chatList?[indexPath.row].name, lastMess: chatList?[indexPath.row].lastMessenger, messState: chatList?[indexPath.row].messState)
        rowList!.append(tableRowView)
        
        cell.contentMode = .scaleAspectFill
        cell.addSubview(tableRowView)
        LayoutHelper.shared.fitToParent(view: tableRowView)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}
