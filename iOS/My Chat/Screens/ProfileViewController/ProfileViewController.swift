//
//  ProfileViewController.swift
//  My Chat
//
//  Created by Trần Đình Tôn Hiếu on 11/17/19.
//  Copyright © 2019 Trần Đình Tôn Hiếu. All rights reserved.
//

import Foundation
import UIKit

class ProfileViewController : UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func doSomething(_ array:Array<Any>) {
        for (i, ele) in array.enumerated() {
            print("Phan tu thu \(i) la: \(ele)")
        }
    }
    
    func requestApi(_ urlString:String?) {
        guard let url = URL(string: urlString!) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            if (error != nil) {
                print("Error = \(String(describing: error))")
                return
            } else {
                do {
                    let dataRespond = data
                    let jsonRespond = try JSONSerialization.jsonObject(with: dataRespond!, options: [])
                    print("Json respond: \(jsonRespond)")
                    print("Data respond: \(String(describing: dataRespond))")
                } catch let parsingError {
                    print("Error", parsingError)
                }
            }
        }
        task.resume()
    }
    
    @IBAction func logOutButtonTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "Xác nhận đăng xuất", message: "Bạn có muốn đăng xuất không?", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Có", style: .default, handler: {(UIAlertAction)->Void in
            ProfileBusiness.shared.logOut()
            self.navigationController?.popViewController(animated: false)
        }))
        alertController.addAction(UIAlertAction(title: "Không", style: .cancel, handler: nil))
        
        self.present(alertController, animated: true, completion:nil)
    }
}
