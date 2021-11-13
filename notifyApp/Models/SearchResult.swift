//
//  SearchResult.swift
//  notifyApp
//
//  Created by Tofu-imac on 9/29/21.
//

import Foundation

enum SearchResult {
    case artist(model: Artist)
    case album(model: Album)
    case track(model: AudioTrack)
    case playlist(model: Playlist)
}
