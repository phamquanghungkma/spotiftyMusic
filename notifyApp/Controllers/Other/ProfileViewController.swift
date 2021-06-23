//
//  ProfileViewController.swift
//  notifyApp
//
//  Created by Tofu-imac on 3/6/21.
//

import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        APICaller.shared.getCurrentUserProfile { result in
            switch result {
            case .success(let model):
                
                break
            case .failure(let error):
                print(error.localizedDescription)
                break
            
            }
        }
        
    }
    

  
}
