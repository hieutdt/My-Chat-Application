//
//  LayoutHelper.swift
//  My Chat
//
//  Created by Trần Đình Tôn Hiếu on 1/7/20.
//  Copyright © 2020 Trần Đình Tôn Hiếu. All rights reserved.
//

import Foundation
import UIKit

class LayoutHelper : NSObject {
    static let shared = LayoutHelper()
    
    private override init() {
        super.init()
    }
    
    func fitToParent(view:UIView!) {
        if view!.superview == nil {
            return
        }
        
        view.topAnchor.constraint(equalTo: view!.superview!.topAnchor, constant: 0).isActive = true
        view.leadingAnchor.constraint(equalTo: view!.superview!.leadingAnchor, constant: 0).isActive = true
        view.trailingAnchor.constraint(equalTo: view!.superview!.trailingAnchor, constant: 0).isActive = true
        view.bottomAnchor.constraint(equalTo: view!.superview!.bottomAnchor, constant: 0).isActive = true
    }
}
