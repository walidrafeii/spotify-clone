//
//  NewReleasesResponse.swift
//  spotify-clone
//
//  Created by Walid Rafei on 5/19/21.
//

import Foundation

struct NewReleasesResponse: Codable {
    let albums: AlbumResponse
}

struct AlbumResponse: Codable {
    let items: [Album]
}

struct Album: Codable {
    let album_type: String
    let available_markets: [String]
    let id: String
    var images: [ApIImage]
    let name: String
    let release_date: String
    let total_tracks: Int
    let artists: [Artist]
}
