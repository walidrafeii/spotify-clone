//
//  AllCategoriesResponse.swift
//  spotify-clone
//
//  Created by Walid Rafei on 5/20/21.
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
    let icons: [ApIImage]
}
