//
//  RoomDisableViewModel.swift
//  ZanyaFirst
//
//  Created by 박승찬 on 2023/08/01.
//

import Foundation

class RoomDisableViewModel: ObservableObject {
    
    @Published var room: Room
    
    var hour: Int = 0
    var min: Int = 0
    var afterNoon: Bool = false
    var timeComponenets = DateComponents()
    
    init(room: Room){
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
