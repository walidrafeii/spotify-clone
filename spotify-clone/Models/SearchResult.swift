//
//  SearchResult.swift
//  spotify-clone
//
//  Created by Walid Rafei on 5/20/21.
//

import Foundation

enum SearchResult {
    case artist(model: Artist)
    case album(model: Album)
    case playlist(model: Playlist)
    case track(model: AudioTrack)
}
