//
//  SettingModels.swift
//  notifyApp
//
//  Created by Tofu-imac on 6/24/21.
//

import Foundation
struct Section {
    let title: String
    let options: [Option]
}

struct Option {
    let title: String
    let handler: () -> Void
}
