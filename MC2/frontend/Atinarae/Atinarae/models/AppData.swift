//
//  AppData.swift
//  Atinarae
//
//  Created by HyunwooPark on 2023/05/06.
//

import SwiftUI

class AppData: ObservableObject {
    @Published var isLoggedIn = false
    @Published var user =
    User(
        userId: 1,
        nickname: "hypark",
        mail: "hypark@example.com",
        phone: "010-0000-0000",
        profile: "assetsPath",
        categories: [
            "생일",
            "기념일",
            "기타 등등",
            "custom"
        ],
        friends: [
            Friend(
                nickname: "모아나",
                planetImage:"moana1",
                videos: []
            ),
            Friend(
                nickname: "생",
                planetImage:"moana2",
                videos: []
            ),
            Friend(
                nickname: "축",
                planetImage:"moana3",
                videos: []
            ),
            Friend(
                nickname: "쨈",
                planetImage:"쨈",
                videos: []
            ),
            Friend(
                nickname: "돈",
                planetImage:"돈",
                videos: []
            ),
            Friend(
                nickname: "머스크",
                planetImage:"머스크",
                videos: []
            ),
            Friend(
                nickname: "제이미",
                planetImage:"제이미",
                videos: []
            ),
            Friend(
                nickname: "우디",
                planetImage:"우디",
                videos: []
            )
        ]
    )
    
}
