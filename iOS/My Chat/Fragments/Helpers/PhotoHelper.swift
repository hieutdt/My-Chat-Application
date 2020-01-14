//
//  PhotoHelper.swift
//  My Chat
//
//  Created by Trần Đình Tôn Hiếu on 1/7/20.
//  Copyright © 2020 Trần Đình Tôn Hiếu. All rights reserved.
//

import Foundation
import UIKit

class PhotoHelper : NSObject {
    static let shared = PhotoHelper()
    
    private override init() {
        super.init()
    }
    
    func resizeImage(image: UIImage, size: CGSize) -> UIImage {
        let scale = max(size.width/image.size.width, size.height/image.size.height)
        let width = image.size.width * scale
        let height = image.size.height * scale
        let imageRect = CGRect.init(x: (size.width - width)/2.0, y: (size.height - height)/2.0, width: width, height: height)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        image.draw(in: imageRect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func asyncLoadingPhoto(url:String!, imageView:UIImageView!) {
        let url = URL(string: url)
        if url == nil {
            return
        }

        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!)
            DispatchQueue.main.async {
                imageView.image = UIImage(data: data!)
            }
        }
    }
}
