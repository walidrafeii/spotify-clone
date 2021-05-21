//
//  Artist.swift
//  spotify-clone
//
//  Created by Walid Rafei on 5/19/21.
//

import Foundation

struct Artist: Codable {
    let id: String
    let name: String
    let type: String
    let images: [ApIImage]?
    let external_urls: [String: String]
}
