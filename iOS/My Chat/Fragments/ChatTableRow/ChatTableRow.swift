//
//  ChatTableRow.swift
//  My Chat
//
//  Created by Trần Đình Tôn Hiếu on 1/7/20.
//  Copyright © 2020 Trần Đình Tôn Hiếu. All rights reserved.
//

import Foundation
import UIKit
import MaterialComponents.MaterialRipple

class ChatTableRow : UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messLabel: UILabel!
    @IBOutlet weak var messStateImageView: UIImageView!
    
    private var rippleView: MDCRippleView?
    
    public var name:String?
    public var messenger:String?
    public var messState:String?
    public var ts:Int64?
    
    override init(frame:CGRect) {
        super.init(frame:frame)
        self.initView()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.initView()
    }
    
    private func initView() {
        Bundle.main.loadNibNamed("ChatTableRow", owner: self, options: nil)
        
        self.addSubview(contentView)
        LayoutHelper.shared.fitToParent(view: contentView)
        
        let stateIcon = UIImage.init(named: "checked")!.withTintColor(.darkGray)
        messStateImageView.image = stateIcon
        
        avatarImageView.layer.cornerRadius = avatarImageView.frame.height/2
    }
    
    public func setUpViewWith(name:String!, lastMess mess:String!, messState:String!, avatarUrl:String!) {
        nameLabel.text = name;
        messLabel.text = mess;
        if messState == "SENT_FROM_YOU" {
            messStateImageView.isHidden = false
            messStateImageView.image = UIImage.init(named: "checked")!.withTintColor(.darkGray)
        } else if messState == "SENT_FROM_FRIEND" {
            messStateImageView.isHidden = false
        } else if messState == "SEEN_FROM_YOU" {
            messStateImageView.isHidden = true
        } else if messState == "SEEN_FROM_FRIEND" {
            messStateImageView.isHidden = false
            PhotoHelper.shared.asyncLoadingPhoto(url: avatarUrl, imageView: messStateImageView)
        }
        
        PhotoHelper.shared.asyncLoadingPhoto(url: avatarUrl, imageView: avatarImageView)
    }
}
