//
//  File.swift
//  ZanyaFirst
//
//  Created by Kimjaekyeong on 2023/07/18.
//

import Foundation
import CloudKit

//MARK: -PROFILE
struct Profile: Hashable {
    var UID: String
    var name: String
    var imageKey: String?
    var record: CKRecord? //CKRecord(recordType : "Profile")
}


//MARK: -PROFILE DUMMY
let dummyProfile0 = Profile(UID: "UID = 0", name: "Liv", imageKey: "setProfileCheese", record: CKRecord(recordType: "Profile"))
let dummyProfile1 = Profile(UID: "UID = 1", name: "Binu", imageKey: "setProfileSham", record: CKRecord(recordType: "Profile"))
let dummyProfile2 = Profile(UID: "UID = 2", name: "Don", imageKey: "setProfileBlack", record: CKRecord(recordType: "Profile"))
let dummyProfile3 = Profile(UID: "UID = 3", name: "Ddan", imageKey: whiteCat, record: CKRecord(recordType: "Profile"))
let dummyProfile4 = Profile(UID: "UID = 4", name: "Sean", imageKey: greyCat, record: CKRecord(recordType: "Profile"))
let dummyProfile5 = Profile(UID: "UID = 5", name: "Baron", imageKey: gentleCat, record: CKRecord(recordType: "Profile"))


let dummyProfiles = [dummyProfile0, dummyProfile1, dummyProfile2]

//MARK: -ROOM
struct Room: Hashable {
    let name: String
    var UIDs: [String]
    let record: CKRecord? //CKRecord(recordType : "Room")
    let time: Date
    
    // var inOnTime: Bool //TODO: - 알람 시간 넣어줘야하는데
}

let dummyRoom = Room(name: "일어날래, 나랑 살래?", UIDs: [dummyProfile0.UID, dummyProfile1.UID, dummyProfile2.UID], record: CKRecord(recordType: "Room"), time: Date.now)

//MARK: -ROOM DUMMY
//MARK: -ROOMS DUMMY

let dummyRoom0 = Room(name: "일어날래 나랑살래", UIDs: ["UID = 0","UID = 1","UID = 2","UID = 3","UID = 4","UID = 5"], record: CKRecord(recordType : "Room"), time: Date())

//let dummyRoom1 = Room(name: "멍멍멍", UIDs: ["UID = 0","UID = 1","UID = 2"], record: CKRecord(recordType : "Room"))
//let dummyRoom2 = Room(name: "야옹야옹", UIDs: ["UID = 3","UID = 4","UID = 5"], record: CKRecord(recordType : "Room"))
//
//
//let dummyRoomViewModels = [RoomViewModel(allUsers: [dummyProfile0,dummyProfile1,dummyProfile2,dummyProfile3,dummyProfile4,dummyProfile5], users: [dummyProfile0,dummyProfile1,dummyProfile2,dummyProfile3,dummyProfile4,dummyProfile5], roomInfo: Room(name: "고마하고 일나라", UIDs: ["UID = 0","UID = 1","UID = 2"], record: CKRecord(recordType: "Room"))),
//                           RoomViewModel(allUsers: [dummyProfile0,dummyProfile1,dummyProfile2,dummyProfile3,dummyProfile4,dummyProfile5], users: [dummyProfile0,dummyProfile2,dummyProfile4,dummyProfile1], roomInfo: Room(name: "멍멍멍", UIDs: ["UID = 0","UID = 1","UID = 2"], record: CKRecord(recordType : "Room"))),
//                           RoomViewModel(allUsers: [dummyProfile0,dummyProfile1,dummyProfile2,dummyProfile3,dummyProfile4,dummyProfile5], users: [dummyProfile1,dummyProfile4,dummyProfile5], roomInfo: Room(name: "야옹야옹", UIDs: ["UID = 3","UID = 4","UID = 5"], record: CKRecord(recordType : "Room")))
//]
//
let dummyRoomCellViewModel = RoomCellViewModel(isOnTime: true, room: dummyRoom0)

//MARK: -NyangSound
struct NyangSound: Hashable {
    let roomRecord: String
    let messsage: String
    let soundType: String
    let whoSend: String
    let imageKey: String
}

