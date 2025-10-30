//
//  File.swift
//  ZanyaFirst
//
//  Created by Kimjaekyeong on 2023/07/18.
//

import Foundation
import CloudKit

class CreateRoomViewModel: ObservableObject {
    @Published var roomName: String = ""
    @Published var time = Date()
    
    private func createRoom(roomName: String, time: Date) {
        CKContainer.default().fetchUserRecordID { [weak self] returnedID, returnedError in
            if let uid = returnedID {
                let room = CKRecord(recordType: "Room")
                
                room["name"] = roomName
                room["time"] = time
                room["uids"] = [uid.recordName]
                print("생성시간 \(time)")
                self?.saveItem(record: room)
            }
        }
    }
    
    private func saveItem(record: CKRecord) {
        CKContainer.default().publicCloudDatabase.save(record) { returnedRecord, returnedError in
            print("Record: \(returnedRecord)")
            print("Error: \(returnedError)")
            
        }
    }
    
    func clickedCompleteButton() {
        guard !roomName.isEmpty else { return }
        createRoom(roomName: roomName, time: time)
        self.roomName = ""
    }
}
