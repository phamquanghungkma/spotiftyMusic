//
//  AllCategoriesResponse.swift
//  notifyApp
//
//  Created by Tofu-imac on 9/10/21.
//

import Foundation

struct AllCategoriesResponse: Codable {
    let categories: Categories
}

struct Categories: Codable {
    let items: [Category]
}

struct Category: Codable {
    let id: String
    let name: String
    let icons: [APIImage
    ]
}
