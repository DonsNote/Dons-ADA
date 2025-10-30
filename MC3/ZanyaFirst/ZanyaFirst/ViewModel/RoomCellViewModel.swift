//
//  RoomCellViewModel.swift
//  ZanyaFirst
//
//  Created by BAE on 2023/07/30.
//

import Foundation

class RoomCellViewModel: ObservableObject {
    @Published var isOnTime: Bool
    @Published var title: String = ""
    @Published var userCount: Int = 0
    let preFix: String = "zanya-invite:://"
    @Published var room: Room
    
    var hour: Int = 0
    var min: Int = 0
    var afterNoon: Bool = false
    var timeComponenets = DateComponents()
    
    init(isOnTime:Bool, room: Room){
        self.isOnTime = isOnTime
        self.title = room.name
        self.userCount = room.UIDs.count
        self.room = room
        self.timeComponenets = Calendar.current.dateComponents([.hour,.minute], from: room.time)
        
        timeFormat()
    }
    
    private func timeFormat() {
        if timeComponenets.hour ?? 0 > 11 {
            afterNoon = true
        } else {
            afterNoon = false
        }
        
        if timeComponenets.hour ?? 0 > 12 {
            hour = (timeComponenets.hour ?? 0) - 12
        } else {
            hour = timeComponenets.hour ?? 0
        }
        
        min = timeComponenets.minute ?? 0
        
        print("hour: \(hour), min: \(min)")
    }
    
}
