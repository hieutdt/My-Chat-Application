//
//  HeaderLabel.swift
//  My Chat
//
//  Created by Trần Đình Tôn Hiếu on 11/17/19.
//  Copyright © 2019 Trần Đình Tôn Hiếu. All rights reserved.
//

import Foundation
import UIKit

class HeaderLabel : UILabel {
    
    required init?(coder aCoder: NSCoder) {
        super.init(coder:aCoder)!
        self.commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        self.commonInit()
    }
    
    func commonInit() {
        self.font = UIFont.init(name: "", size: 15)
        self.textColor = UIColor.black
    }
}
