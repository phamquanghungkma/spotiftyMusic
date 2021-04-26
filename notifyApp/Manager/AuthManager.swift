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
  
        let base = "https://accounts.spotify.com/authorize"
        let string = "\(base)?response_type=code&client_id=\(Constants.clientID)&scope=\(Constants.scopes)&redirect_uri=\(Constants.redirectURI)&show_dialog=TRUE"
        return URL(string: string)
    }
    
    var isSignedIn: Bool {
        return accessToken != nil
    }
    
    private var accessToken: String? {
        return UserDefaults.standard.string(forKey: KeyString.accessToken)
            
    }
    
    private var refreshToken: String? {
        return UserDefaults.standard.string(forKey: KeyString.refeshToken)
    }
    
    private var tokenExpirationDate: Date? {
        return UserDefaults.standard.object(forKey: KeyString.expirationDate) as? Date
    }
    
    private var shouldRefreshToken: Bool {
        guard let expirationDate = tokenExpirationDate else {
            return false
        }
        let currentDate = Date()
        let fiveMinutes: TimeInterval = 300
        
        return currentDate.addingTimeInterval(fiveMinutes) >= expirationDate
    }
    public func exchangeCodeForToken(code: String, completion: @escaping ((Bool) -> Void) ) {
        // Get Token
        guard let url = URL(string: Constants.tokenAPIURL) else {
            return
        }
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value:"authorization_code"),
            URLQueryItem(name: "code", value:code),
            URLQueryItem(name: "redirect_uri", value:Constants.redirectURI)
                                 
        ]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = components.query?.data(using:.utf8)
        request.setValue("application/x-www-form-urlencoded ", forHTTPHeaderField: "Content-Type")

        let basicToken = Constants.clientID + ":" + Constants.clientSecret
        let data = basicToken.data(using:.utf8)
        guard let base64String = data?.base64EncodedString() else {
            print("failure to get base 64")
            completion(false)
            return
        }
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        
        let task =  URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data , error == nil else {
                completion(false)
                return
            }
        do {
         
            let result  = try JSONDecoder().decode(AuthResponse.self, from: data)
            self.cacheToken(result: result)
            completion(true)
            
            
        } catch {
            print(error.localizedDescription)
            completion(true)
        }
        
        }
        task.resume()
        
    }
    
    public func refreshIfNeed(completion: @escaping (Bool) -> Void) {
//        guard shouldRefreshToken else {
//            completion(true)
//            return
//        }
        guard let refreshToken = self.refreshToken else {
            return
        }
        // Get Token
        guard let url = URL(string: Constants.tokenAPIURL) else {
            return
        }
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value:KeyString.refeshToken),
            URLQueryItem(name: KeyString.refeshToken, value: refreshToken)
                                 
        ]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = components.query?.data(using:.utf8)
        request.setValue("application/x-www-form-urlencoded ", forHTTPHeaderField: "Content-Type")

        let basicToken = Constants.clientID + ":" + Constants.clientSecret
        let data = basicToken.data(using:.utf8)
        guard let base64String = data?.base64EncodedString() else {
            print("failure to get base 64")
            completion(false)
            return
        }
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        
        let task =  URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data , error == nil else {
                completion(false)
                return
            }
        do {
         
            let result  = try JSONDecoder().decode(AuthResponse.self, from: data)
            print("Sucessfully refreshed")
            self.cacheToken(result: result)
            completion(true)
            
            
        } catch {
            print(error.localizedDescription)
            completion(true)
        }
        
        }
        task.resume()
        
    }
    
    private func cacheToken(result: AuthResponse) {
        UserDefaults.standard.setValue(result.access_token, forKey: KeyString.accessToken)
        
        if let refresh_token = result.refresh_token {
            UserDefaults.standard.setValue(refresh_token, forKey: KeyString.refeshToken)
        }
        UserDefaults.standard.setValue(Date().addingTimeInterval(TimeInterval(result.expires_in)), forKey: KeyString.expirationDate)
        
    }
    
    
}
struct Constants {
    static let clientID = "e41b0971ff5f42679d57d7cba32aa5e9"
    static let clientSecret = "13c67f8b80564b13b4795986ad0f33d8"
    static let tokenAPIURL = "https://accounts.spotify.com/api/token"
    static let redirectURI = "https://github.com/phamquanghungkma"
    static let scopes = "user-read-private%20playlist-modify-public%20playlist-read-private%20playlist-modify-private%20user-follow-read%20user-library-modify%20user-library-read%20user-read-email"
}

struct KeyString {
     static let  accessToken = "access_token"
     static let  refeshToken = "refresh_token"
     static let expirationDate = "expirationDate"
    
}
