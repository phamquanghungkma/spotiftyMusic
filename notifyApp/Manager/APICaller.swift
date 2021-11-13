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
                    completion(.success(result))
                } catch {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
        
    }
    
    public func getNewRelease(completion: @escaping ((Result<NewReleasesResponse,Error>)) ->Void) {
        createRequest(with: URL(string: Constants.baseURL + "/browse/new-releases?limit=10"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.faileedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(NewReleasesResponse.self, from: data)
                    completion(.success(result))
                }
                catch let e{
                    print("error1",e.localizedDescription)
                    completion(.failure(APIError.faileedToGetData))

                }
                
            }
            task.resume()
        }
    }
    
    public func getFeaturedPlaylists(completion: @escaping ((Result<FeaturedPlaylistsReponse,Error>) -> Void)) {
        createRequest(with: URL(string: Constants.baseURL + "/browse/featured-playlists?limit=20"), type:.GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.faileedToGetData))
                    return
                    
                }
                do {
                    let result = try JSONDecoder().decode(FeaturedPlaylistsReponse.self, from: data)
                
                    completion(.success(result))
                }
                catch let e{
                    print("error1",e.localizedDescription)
                    completion(.failure(APIError.faileedToGetData))

                }
                
            }
            task.resume()
        }
        
    }
    
    // MARK: - Albums
    public func getAlbumDetails(for album: Album, completion: @escaping (Result<AlbumDetailsResponse,Error>) -> Void) {
        createRequest(with: URL(string: Constants.baseURL + "/albums/" + album.id), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.faileedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(AlbumDetailsResponse.self, from: data)
                    completion(.success(result))
                    
                } catch {
                    print(error)
                    completion(.failure(error))
                }
                
                                
            }
            task.resume()
        }
    }
    
    // MARK: - Playlists
    
    public func getPlaylistDetails(for playlist: Playlist, completion: @escaping (Result<PlaylistDetailResponse,Error>) -> Void) {
        createRequest(with: URL(string: Constants.baseURL + "/playlists/" + playlist.id), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.faileedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(PlaylistDetailResponse.self, from: data)
                    print("results", result)
                    completion(.success(result))
                    
                } catch {
                    print(error)
                    completion(.failure(error))
                }
                
                                
            }
            task.resume()
        }
    }
    
    

    
    public func getRecommendations(genres:Set<String>,completion: @escaping ((Result<RecommendationsResponse,Error>) -> Void)) {
        let seeds = genres.joined(separator: ",")
        createRequest(with: URL(string: Constants.baseURL + "/recommendations?limit=10&seed_genres=\(seeds)"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.faileedToGetData))
                    return

                }
                do {
                    let result = try JSONDecoder().decode(RecommendationsResponse.self, from: data)

                    completion(.success(result))
                }
                catch let e{
                    print("error1",e.localizedDescription)
                    completion(.failure(APIError.faileedToGetData))

                }

            }
            task.resume()
        }
    }

    
    public func getRecommendedGenres(completion: @escaping ((Result<RecommendedGenresResponse,Error>) -> Void)) {
        createRequest(with: URL(string: Constants.baseURL + "/recommendations/available-genre-seeds"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                           guard let data = data, error == nil else {
                               completion(.failure(APIError.faileedToGetData))
                               return
           
                           }
                           do {
                            let result = try JSONDecoder().decode(RecommendedGenresResponse.self, from: data)
           
                            completion(.success(result))
                           }
                           catch let e{
                               print("error1",e.localizedDescription)
                               completion(.failure(APIError.faileedToGetData))
           
                           }
           
                       }
                       task.resume()
        }
        
    }
    
    // MARK: - Search
    public func search(with query: String, completion: @escaping (Result<[SearchResult],Error>) -> Void) {
        createRequest(with: URL(string: Constants.baseURL + "/search?limit=10&type=album,artist,playlist,track&q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"), type: .GET) { request in
            
            print(request.url?.absoluteString ?? "none")
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                
                guard let data = data, error == nil else {
                    completion(.failure(APIError.faileedToGetData))
                    return
                }
                
                do {
                    
                    let json = try JSONDecoder().decode(SearchResultsResponse.self, from: data)
                    var searchResults: [SearchResult] = []
                    searchResults.append(contentsOf: json.tracks.items.compactMap({ .track(model: $0) }))
                    searchResults.append(contentsOf: json.albums.items.compactMap({ .album(model: $0) }))
                    searchResults.append(contentsOf: json.artists.items.compactMap({ .artist(model: $0) }))
                    searchResults.append(contentsOf: json.playlists.items.compactMap({ .playlist(model: $0)}))
                    
                    completion(.success(searchResults))
                } catch {
                    print(error)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    
    // MARK: - Category
    public func getCategories(completion: @escaping(Result<[Category],Error>) -> Void) {
        createRequest(with: URL(string: Constants.baseURL + "/browse/categories?limit=50"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) {data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.faileedToGetData))
                    return
                }
                
                do {
                    let json = try JSONDecoder().decode(AllCategoriesResponse.self, from: data)
                    
                    print(json.categories.items)
                    completion(.success(json.categories.items))
                    
                } catch {
                    completion(.failure(error))
                }
                
            }
            task.resume()
        }
    }
    
    public func getCategoryPlaylists(category: Category ,completion: @escaping(Result<[Playlist],Error>) -> Void) {
        createRequest(with: URL(string: Constants.baseURL + "/browse/categories/\(category.id)/playlists?limit=50"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) {data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.faileedToGetData))
                    return
                }
                
                do {
                    let json = try JSONDecoder().decode(FeaturedPlaylistsReponse.self, from: data)
                    let playlist = json.playlists.items
                    
                    print(playlist)
                    
                    completion(.success(playlist))
                    
                    
                    print("json",json)
                    
                    
                    
                } catch {
                    print("cateplay",error.localizedDescription)
                    completion(.failure(error))

                }
                
            }
            task.resume()
        }
    }
    
    
    
    
    // MARK: - Private

    enum HTTPMethod: String {
        case GET
        case POST
    }
    
    enum APIError: Error {
        case faileedToGetData
    }
    
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
