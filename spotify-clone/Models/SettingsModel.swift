//
//  SettingsModel.swift
//  spotify-clone
//
//  Created by Walid Rafei on 5/19/21.
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
