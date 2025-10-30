//
//  File.swift
//  ZanyaFirst
//
//  Created by Kimjaekyeong on 2023/07/19.
//

import Foundation

struct TimeModel: Equatable, Comparable, Identifiable {
    
    static func < (lhs: TimeModel, rhs: TimeModel) -> Bool {
       (lhs.hours < rhs.hours) || (lhs.hours == rhs.hours && lhs.minute < rhs.minute)
    }
    
    let id = UUID()
    let hours: Int
    let minute: Int
}
