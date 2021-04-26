//
//  AuthManager.swift
//  notifyApp
//
//  Created by Tofu-imac on 3/6/21.
//

import Foundation

final class AuthManager {
    static let shared = AuthManager()
    
    private init(){
        
    }
    public var signInURL: URL? {
        let scopes = "user-read-private"
        let redirectURI = "https://github.com/phamquanghungkma"
        let base = "https://accounts.spotify.com/authorize"
        let string = "\(base)?response_type=code&client_id=\(Constants.clientID)&scope=\(scopes)&redirect_uri=\(redirectURI)&show_dialog=TRUE"
        return URL(string: string)
    }
    
    var isSignedIn: Bool {
        return false
    }
    
    private var accessToken: String? {
        return nil
    }
    
    private var refreshToken: String? {
        return nil
    }
    
    private var tokenExpirationDate: Data? {
        return nil
    }
    
    private var shouldRefreshToken: Bool {
        return false
    }
    public func exchangeCodeForToken(code: String, completion: @escaping ((Bool) -> Void) ) {
        // Get Token
    }
    
    public func refreshAccessToken() {
        
    }
    
    private func cacheToken() {
        
    }
    
    
}
struct Constants {
    static var clientID = "e41b0971ff5f42679d57d7cba32aa5e9"
    static var clientSecret = "13c67f8b80564b13b4795986ad0f33d8"
}
