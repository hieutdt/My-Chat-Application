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
    private var touchControl: UIControl?
    
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
        
        rippleView = MDCRippleView()
        rippleView?.rippleColor = .red
        self.addSubview(rippleView!)
        LayoutHelper.shared.fitToParent(view: rippleView!)
        
        touchControl = UIControl(frame: self.bounds)
        touchControl?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(touchControl!)
        touchControl?.addTarget(self, action: Selector(("touchDown")), for: .touchDown)
        touchControl?.addTarget(self, action: Selector(("touchUpInside")), for: .touchUpInside)
        touchControl?.addTarget(self, action: Selector(("touchUpOutsize")), for: .touchUpOutside)
        touchControl?.addTarget(self, action: Selector(("touchCancel")), for: .touchCancel)
        
        let stateIcon = UIImage.init(named: "checked")!.withTintColor(.darkGray)
        messStateImageView.image = stateIcon
        
        avatarImageView.image = UIImage.init(named: "avatar")
        avatarImageView.layer.cornerRadius = avatarImageView.frame.height/2
    }
    
    public func setUpViewWith(name:String!, lastMess mess:String!, messState:String!) {
        nameLabel.text = name;
        messLabel.text = mess;
        if messState == "STATE_SENT" {
            messStateImageView.isHidden = false
        } else if messState == "STATE_SEEN" {
            messStateImageView.isHidden = true
        }
    }
    
    public func beginRippleEffect() {
        rippleView?.beginRippleTouchDown(at: CGPoint(x: 0,y: 0), animated: true, completion: nil);
    }
    
    //
    @objc private func touchDown() {
        rippleView?.beginRippleTouchDown(at: .zero, animated: true, completion: nil)
    }
    
    @objc private func touchUpInside() {
        rippleView?.beginRippleTouchUp(animated: true, completion: nil)
    }
    
    private func touchUpOutsize() {
        rippleView?.beginRippleTouchUp(animated: true, completion: nil)
    }
    
    private func touchCancel() {
        rippleView?.beginRippleTouchUp(animated: true, completion: nil)
    }
}
