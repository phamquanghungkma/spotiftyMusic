//
//  FeaturedPlaylistsResponse.swift
//  notifyApp
//
//  Created by Tofu-imac on 8/4/21.
//

import Foundation

struct FeaturedPlaylistsReponse: Codable {
    let playlists: PlaylistResponse
}

struct PlaylistResponse: Codable {
    let items: [Playlist]
}

struct CategoryPlaylistResponse: Codable {
    let playlists: PlaylistResponse
}



struct Playlist: Codable {
    let description: String
    let external_urls: [String: String]
    let id: String
    let images: [APIImage]
    let name: String
    let owner: User
}

struct User: Codable {
    let display_name: String
    let external_urls: [String: String]
    let id: String
}
