//
//  Artist.swift
//  notifyApp
//
//  Created by Tofu-imac on 3/6/21.
//

import Foundation

struct Artist: Codable {
    let id: String
    let name: String
    let type: String
    let external_urls: [String: String]
}
