//
//  File.swift
//  ZanyaFirst
//
//  Created by Kimjaekyeong on 2023/07/18.
//

import Foundation

enum Sounds: String, CaseIterable, Codable {
    case catcat = "catcat.mp3"
    case dogdog = "dogdog.mp3"
    case pigpig = "pigpig.mp3"
}


let SoundsList: [Sounds] = [
    .catcat,
    .dogdog,
    .pigpig
]


//MARK: - '_' 얘네 전부 띄어쓰기로 바꾸기 귀찮아서 만드는 익스텐션/ 지금은 필요 없음

//extension String {
//    var formatSoundName: String {
//        var result = String(describing: self)
//            .replacingOccurrences(of: "_", with: " ")
//            .capitalized
//
//        let periodIndex = result.firstIndex(of: ".")
//
//        if let periodIndex: Index = periodIndex {
//            result.removeSubrange(periodIndex...)
//        }
//
//        return result
//    }
//}
