//
//  APICaller.swift
//  notifyApp
//
//  Created by Tofu-imac on 3/6/21.
//

import Foundation

final class APICaller {
        
    static let shared = APICaller()
    
    private init() {
        
    }
    struct Constants {
        static let baseURL = "https://api.spotify.com/v1"
    }
    
    public func getCurrentUserProfile(completion: @escaping (Result<UserProfile, Error>) -> Void) {
        createRequest(with:URL(string: Constants.baseURL + "/me"), type: .GET) {  baseRequest in
            let task = URLSession.shared.dataTask(with: baseRequest) { data, _, error in
                guard let data = data , error  == nil else {
                    completion(.failure(APIError.faileedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(UserProfile.self, from: data)
                    print(result)
                    completion(.success(result))
                } catch {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
        
    }
    
    enum HTTPMethod: String {
        case GET
        case POST
    }
    
    enum APIError: Error {
        case faileedToGetData
    }
    
    // MARK: - Private
    private func createRequest(with url: URL?,
                               type: HTTPMethod,
                               completion: @escaping (URLRequest) -> Void) {
 
        AuthManager.shared.withValidToken { token in
            guard let apiURL = url else {
                return
            }
            var request = URLRequest(url: apiURL)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpMethod = type.rawValue
            completion(request)
        }
        
    }
}
