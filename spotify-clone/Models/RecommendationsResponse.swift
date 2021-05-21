//
//  RecommendationsResponse.swift
//  spotify-clone
//
//  Created by Walid Rafei on 5/19/21.
//

import Foundation

struct RecommendationsResponse: Codable {
    let tracks: [AudioTrack]
}
