//
//  SearchResultsResponse.swift
//  notifyApp
//
//  Created by Tofu-imac on 9/29/21.
//

import Foundation

struct SearchResultsResponse: Codable {
    let albums: SearchAlbumResponse
    let artists: SearchArtistsReponse
    let playlists: SearchPlaylistResponse
    let tracks: SearchTracksResponse
}

struct SearchAlbumResponse: Codable {
    let items: [Album]
}

struct SearchArtistsReponse: Codable {
    let items: [Artist]
}

struct SearchPlaylistResponse: Codable {
    let items: [Playlist]
}

struct SearchTracksResponse: Codable {
    let items: [AudioTrack]
}
