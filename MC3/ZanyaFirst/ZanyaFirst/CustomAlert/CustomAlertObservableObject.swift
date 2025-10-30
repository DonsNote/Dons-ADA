//
//  CustomAlertObservableObject.swift
//  ZanyaFirst
//
//  Created by BAE on 2023/07/30.
//

import Foundation
import CloudKit

class CustomAlertObject: ObservableObject {
    @Published var isClicked = false
    @Published var roomName = ""
    @Published var room: Room?
    @Published var UID: String?
    
    func userRoomOut() {
        guard let roomInfo = self.room else { return }
        guard let userUID = self.UID else { return }
        
        var arrayOfUIDs: [String] = []
        var room = CKRecord(recordType: "Room")

        room = (roomInfo.record)!
        arrayOfUIDs.append(contentsOf: roomInfo.UIDs)
        arrayOfUIDs.remove(at: arrayOfUIDs.firstIndex(of: userUID)!)
        
        room["uids"] = arrayOfUIDs

        print("room name : \(room["name"])")
        print("room uids : \(room["uids"])")
        
        self.saveItem(record: room)
        isClicked = false
    }
    
    
    private func saveItem(record: CKRecord) {
        CKContainer.default().publicCloudDatabase.save(record) { returnedRecord, returnedError in
            print("Record: \(returnedRecord)")
            print("Error: \(returnedError)")
        }
    }
}
