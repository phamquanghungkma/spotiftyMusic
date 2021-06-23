//
//  HomeViewController.swift
//  notifyApp
//
//  Created by Tofu-imac on 3/6/21.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        view.backgroundColor = .systemBackground
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .done, target: self, action: #selector(didTapSetting))
        
        
        
       

    }
    @objc func didTapSetting() {
    
        let vc = ProfileViewController()
        vc.title = "Profile"
        
        navigationController?.pushViewController(vc, animated: true)
    }

    

}
