//
//  Friend.swift
//  Atinarae
//
//  Created by HyunwooPark on 2023/05/06.
//

import Foundation

struct Friend: Equatable, Hashable {
    var userId: Int?
    var nickname: String
    var planetImage: String
    var videos: [VideoMessage]
    
    static func == (lhs: Friend, rhs: Friend) -> Bool {
        return lhs.userId == rhs.userId &&
            lhs.nickname == rhs.nickname &&
            lhs.planetImage == rhs.planetImage &&
            lhs.videos == rhs.videos
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(userId)
        hasher.combine(nickname)
        hasher.combine(planetImage)
//        hasher.combine(videos)
    }
    
    init(userId: Int? = nil, nickname: String, planetImage: String, videos: [VideoMessage]) {
        self.userId = userId
        self.nickname = nickname
        self.planetImage = planetImage
        self.videos = videos
    }
}

