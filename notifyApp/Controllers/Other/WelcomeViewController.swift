//
//  WelcomeViewController.swift
//  notifyApp
//
//  Created by Tofu-imac on 3/6/21.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    private let signInButton: UIButton = {
       let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("Sign In With Spotify ", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Spotify"
        view.backgroundColor = .green
        view.addSubview(signInButton)
        print("frame", view.frame.origin.x)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        signInButton.frame = CGRect(x:20,
                                    y:view.height - 50 - view.safeAreaInsets.bottom , // view.safeAreaInsets.bottom khoangr area o ben duoi bottom
                                    width: view.width - 40,
                                    height: 50)
        
    }
    @objc func didTapSignIn() {
        
        let vc = AuthViewController()
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.completionHandler = { [weak self] success in
            DispatchQueue.main.async {
                self?.handleSignIn(success: success)
            }
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    private func handleSignIn(success: Bool) {
        // Login user in or yell at them for error
    }

   

}
