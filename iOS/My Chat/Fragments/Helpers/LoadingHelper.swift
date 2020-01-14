//
//  LoadingHelper.swift
//  My Chat
//
//  Created by Trần Đình Tôn Hiếu on 1/14/20.
//  Copyright © 2020 Trần Đình Tôn Hiếu. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class LoadingHelper: NSObject {
    static let shared = LoadingHelper()
    private var loadingView = NVActivityIndicatorView(frame: .zero)
    
    private override init() {
        loadingView = NVActivityIndicatorView(frame: .zero)
        super.init()
    }
    
    public func showLoadingEffect(viewController:UIViewController!) {
        self.loadingView = NVActivityIndicatorView(frame: CGRect(x: viewController.view.center.x, y: viewController.view.center.y, width: 100, height: 100), type: .circleStrokeSpin, color: .blue, padding: 0)
        viewController.view.addSubview(loadingView)
        loadingView.center = viewController.view.center
        loadingView.startAnimating()
    }
    
    public func hideLoadingEffect() {
        loadingView.stopAnimating()
    }
}
