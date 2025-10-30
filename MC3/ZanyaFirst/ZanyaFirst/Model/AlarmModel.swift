//
//  AlarmModel.swift
//  ZanyaFirst
//
//  Created by Kimjaekyeong on 2023/07/19.
//

//MARK: - 알람모델인데 어디서 가져온 코드라 수정해야함

import Foundation
import SwiftUI

struct AlarmModel: Identifiable, Codable {
    var id = UUID().uuidString
    
    let title: String
    let body: String
    let repeats: Bool
    var sound: String
    var alarmEnabled: Bool
    
    var start: Date
    var end: Date
    
    //MARK: -TimeModel 필요해서 일단 닫아둠
//    var timeInterval: TimeInterval {
//        end - start
//    }
//
//    var startTime: TimeModel {
//        DateToTimeModel(date: start)
//    }
//    var endTime: TimeModel {
//        DateToTimeModel(date: end)
//    }
//
    var endDateComponents: DateComponents {
        Calendar
            .current
            .dateComponents(
                [.hour,.minute],
                from: self.end)
    }
    
    static func DefaultAlarm() -> AlarmModel {
        AlarmModel(
            title: "Activity completed.",
            body: "Have a great day!",
            repeats: false,
            sound: "Sound",
            alarmEnabled: false,
            start: Date(),
            end: addHourToDate(date: Date(), numHours: 12, numMinutes: 0))
    }
}
