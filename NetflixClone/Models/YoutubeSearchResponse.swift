//
//  YoutubeSearchResponse.swift
//  NetflixClone
//
//  Created by Alex on 25/11/2022.
//

import Foundation

struct YoutubeSearchResponse: Codable {
    let items: [VideoElement]
}

struct VideoElement: Codable {
    let id: IdVideoElement
}

struct IdVideoElement: Codable {
    let videoId: String
}
