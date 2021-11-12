//
//  RecommendationsResponse.swift
//  notifyApp
//
//  Created by Tofu-imac on 8/5/21.
//

import Foundation

struct RecommendationsResponse: Codable {
    let tracks: [AudioTrack]
}

struct AudioTrack: Codable {
    let album: Album?
    let artists: [Artist]
    let available_markets: [String]
    let disc_number: Int
    let duration_ms: Int
    let explicit: Bool
    let external_urls: [String: String]
    let id: String
    let name: String
}


