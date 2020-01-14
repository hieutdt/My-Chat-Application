//
//  TabBarController.swift
//  My Chat
//
//  Created by Trần Đình Tôn Hiếu on 11/17/19.
//  Copyright © 2019 Trần Đình Tôn Hiếu. All rights reserved.
//

import Foundation
import UIKit
import MaterialComponents

class TabBarController: UITabBarController, MDCBottomNavigationBarDelegate {
    let bottomBar = MDCBottomNavigationBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the view
        let homeVC = HomeViewController()
        homeVC.title = "Home"
        let friendVC = FriendViewController()
        friendVC.title = "Friend list"
        
        self.viewControllers = [homeVC, friendVC]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
        if !ProfileBusiness.shared.hasLoggedInUser() {
            self.navigationController?.popViewController(animated: false)
            self.navigationController?.pushViewController(LogInViewController(), animated: false)
        }
    }
    
    init() {
        super.init(nibName:nil, bundle:nil)
        commonBottomNavigationBarInit()
    }
    
    required init?(coder aCoder: NSCoder) {
        super.init(coder:aCoder)
        commonBottomNavigationBarInit()
    }
    
    func commonBottomNavigationBarInit() {
        view.backgroundColor = .lightGray
        view.addSubview(bottomBar)
        
        bottomBar.backgroundColor = .white
        bottomBar.tintColor = .black
        bottomBar.alignment = .centered
        bottomBar.titleVisibility = .always
        
        var chatIcon = UIImage.init(named: "chat_icon")
        var friendIcon = UIImage.init(named: "friend_icon")
        
        chatIcon = PhotoHelper.shared.resizeImage(image: chatIcon!, size: CGSize.init(width: 35, height: 35))
        friendIcon = PhotoHelper.shared.resizeImage(image: friendIcon!, size: CGSize.init(width: 32, height: 32))
        
        let homeBarItem = UITabBarItem(title: "Chat", image: chatIcon!, tag: 0)
        let friendHomeBarItem = UITabBarItem(title: "Danh bạ", image: friendIcon!, tag: 1)
        
        bottomBar.items = [homeBarItem, friendHomeBarItem]
        bottomBar.selectedItem = homeBarItem
        bottomBar.delegate = self
    }
    
    func bottomNavigationBar(_ bottomNavigationBar: MDCBottomNavigationBar, didSelect item: UITabBarItem) {
        self.selectedIndex = item.tag
        
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        layoutBottomNavigationBar()
    }
    
    #if swift(>=3.2)
    @available(iOS 11, *)
    override func viewSafeAreaInsetsDidChange() {
       super.viewSafeAreaInsetsDidChange()
       layoutBottomNavigationBar()
    }
    #endif
    
    func layoutBottomNavigationBar() {
        let size = bottomBar.sizeThatFits(view.bounds.size)
        let bottomNavBarFrame = CGRect(x: 0, y: view.bounds.height - size.height, width: size.width, height: size.height)
        
        bottomBar.frame = bottomNavBarFrame
    }
}
