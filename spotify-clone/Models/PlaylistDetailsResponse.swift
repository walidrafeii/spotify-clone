//
//  PlaylistDetailsResponse.swift
//  spotify-clone
//
//  Created by Walid Rafei on 5/19/21.
//

import Foundation

struct playlistDetailsResponse: Codable {
    let description: String
    let external_urls: [String: String]
    let id: String
    let images: [ApIImage]
    let name: String
    let tracks: PlaylistTracksResponse
}

struct PlaylistTracksResponse: Codable {
    let items: [PlaylistItem]
}

struct PlaylistItem: Codable {
    let track: AudioTrack
}
