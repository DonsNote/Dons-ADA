//
//  SetProfileViewModel.swift
//  ZanyaFirst
//
//  Created by BAE on 2023/07/19.
//

import Foundation
import CloudKit

class SplashViewModel: ObservableObject {
    
    @Published var name: String = ""
    
    @Published var permissionStatus: Bool = false
    @Published var isSignedInToiCloud: Bool = false
    @Published var error: String = ""
    @Published var userName: String = ""
    @Published var roomName: String = ""
    
    @Published var rooms: [Room] = []

    
    var profile = Profile(UID: "", name: "",imageKey: "", record: nil)

    @Published var goToMainView: Bool = false
    
    init() {
        getiCloudStatus()
        requestPermission()
        fetchiCloudUserRecordID()
        
        fetchUID()
        fetchItem()
        
        print("SplashViewModel: Profile -> \(profile)")
    }
    
    func fetchUID() {
        CKContainer.default().fetchUserRecordID { [weak self] returnedID, returnedError in
            if let id = returnedID {
                let predicate = NSPredicate(format: "uid = %@", argumentArray: ["\(id.recordName)"])
                let query = CKQuery(recordType: "Profile", predicate: predicate)
                let queryOperation = CKQueryOperation(query: query)
                
                queryOperation.recordMatchedBlock = {  (returnedRecordID, returnedResult) in
                    switch returnedResult {
                    case .success(let record):
                        guard let uid = record["uid"] as? String else { return }
                        guard let imageKey = record["ImageKey"] as? String else { return }
                        guard let name = record["name"] as? String else { return }
                        
                        print("user exist")
                        print(uid)
                        
                        self?.profile.UID = uid
                        self?.profile.name = name
                        self?.profile.imageKey = imageKey
                        self?.profile.record = record
                        
                        self?.haveProfile()
                    case .failure(let error):
                        print("Error recordMatchedBlock: \(error)")
                    }
                }// queryOperation.recordMatchedBlock
                
                queryOperation.queryResultBlock = { returnedResult in
                    print("Returned result splash1: \(returnedResult)")
                    DispatchQueue.main.async { }
                }// queryOperation.queryResultBlock
                //                print("queryOperation : \(queryOperation.query!)")
                // Profile이 있는지만 확인하기 위함으로, 아래 line은 불필요함.
                CKContainer.default().publicCloudDatabase.add(queryOperation)
            }// if let id = returnedID
        }
    }
    
    func fetchItem() {
        CKContainer.default().fetchUserRecordID { [weak self] returnedID, returnedError in
            if let id = returnedID {
                let predicate = NSPredicate(value: true)
                let query = CKQuery(recordType: "Room", predicate: predicate)
                //query.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]    // 쿼리 받아올때 정렬해주는 방법, 쿼리 자체를 정렬해줘요!
                                
                let queryOperation = CKQueryOperation(query: query)
                
                //                queryOperation.resultsLimit = 2 //쿼리를 최대 2개만 가져오게 하는 방법이에요!
                // 설정하지 않는다면 기본 100개의 쿼리만 반환 돼요!
                
                var returnedItems: [Room] = []
                
                queryOperation.recordMatchedBlock = { (returnedRecordID, returnedResult) in
                    switch returnedResult {
                    case .success(let record):
                        guard let name = record["name"] as? String else { return }
                        guard let uids = record["uids"] as? [String] else { return }
                        guard let time = record["time"] as? Date else { return }
//                        if uids.contains(id.recordName){
//                            returnedItems.append(Room(name: name, UIDs: uids, record: record))
//                        }
                        returnedItems.append(Room(name: name, UIDs: uids, record: record, time: time))
//                        print(uids)
                        
                    case .failure(let error):
                        print("Error recordMatchedBlock: \(error)")
                    }
                }
//                print(returnedItems)
                
                queryOperation.queryResultBlock = { [weak self] returnedResult in
                    print("Returned result: \(returnedResult)")
                    DispatchQueue.main.async {
                        self?.rooms = returnedItems
                    }
                    
                }
                CKContainer.default().publicCloudDatabase.add(queryOperation)
            }
        }
    }
    
    
    // MARK: - User의 iCloud계정 가져오기
    // 고유의 iCloud 계정이 데이터 베이스에 저장돼요.
    private func getiCloudStatus() {
        CKContainer.default().accountStatus{ [weak self] returnedStatus, returnedError in   //비동기 코드를 사용하고 있기 때문에 weak self 사용
            DispatchQueue.main.async {
                switch returnedStatus {
                case .available:
                    self?.isSignedInToiCloud = true
                case .noAccount:
                    self?.error = CloudKitError.iCloudAccountNotFound.rawValue
                case .couldNotDetermine:
                    self?.error = CloudKitError.iCloudAccountNotDetermined.rawValue
                case .restricted:
                    self?.error = CloudKitError.iCloudAccountRestricted.rawValue
                default:
                    self?.error = CloudKitError.iCloudAccountUnknown.rawValue
                }
            }
        }
    }// getiCloudStatus
    
    // 계정을 가져오지 못했을 경우의 에러메시지들
    enum CloudKitError: String, LocalizedError {
        case iCloudAccountNotFound
        case iCloudAccountNotDetermined
        case iCloudAccountRestricted
        case iCloudAccountUnknown
    }
    
    // iCloud계정에서 가저온 이름을 fetch하는 함수에요!
    func fetchiCloudUserRecordID() {
        CKContainer.default().fetchUserRecordID { [weak self] returnedID, returnedError in
            if let id = returnedID{
                self?.discoveriCloudUser(id: id)
            }
        }
    }
    
    // 사용자의 이름을 가져올 수 있도록 접근 권한을 물어보는 함수에요!
    func requestPermission() {
        CKContainer.default().requestApplicationPermission([.userDiscoverability]) { [weak self] returnedStatus, returnedError in
            DispatchQueue.main.async {
                if returnedStatus == .granted{
                    self?.permissionStatus = true
                }
            }
        }
    }
    
    // iCloud계정에서 userName 가져오는 함수에요!
    func discoveriCloudUser(id: CKRecord.ID) {
        // UserID를 통해서 데이터 가져오기
        CKContainer.default().discoverUserIdentity(withUserRecordID: id) { [weak self] returnedIdentity, returnedError in
            DispatchQueue.main.async {
                if let name = returnedIdentity?.nameComponents?.givenName {
                    self?.userName = name
                }
                
                // 아래 코드를 통해서 이메일이나 전화번호등을 가져올 수도 있어요.
                //returnedIdentity?.lookupInfo?.emailAddress
            }
        }
    }
    
    func haveProfile() {
        DispatchQueue.main.async {
            self.goToMainView = true
        }
    }
    
    func addRoom(roomRecord: String) {
        var arrayOfUIDs: [String] = []
        let rooms: [Room] = self.rooms
        var room = CKRecord(recordType: "Room")
        
        for tmp in rooms {
            print("방 레코드 ~ \(tmp.record?.recordID.recordName ?? "nil")")
            if tmp.record?.recordID.recordName == roomRecord {
                room = tmp.record ?? CKRecord(recordType: "Room")
                arrayOfUIDs.append(contentsOf: tmp.UIDs)
                break
            }
        }
        arrayOfUIDs.append(self.profile.UID)
        
        room["uids"] = arrayOfUIDs

        print("room name : \(room["name"])")
        print("room uids : \(room["uids"])")
        //        print("profile uid String(describing: \(String(des)cribing: self?.profile.UID))")
        
        self.saveItem(record: room)
    }
    
    private func saveItem(record: CKRecord) {
        CKContainer.default().publicCloudDatabase.save(record) { returnedRecord, returnedError in
            print("Record: \(returnedRecord)")
            print("Error: \(returnedError)")
        }
    }
    
    func parseURL(url: URL) -> String {
        let decodedLink = url.absoluteString.removingPercentEncoding!
        let removePrefix = decodedLink.replacingOccurrences(of: "zanya-invite:://", with: "")
        let replaceUnderLineToSpace = removePrefix.replacingOccurrences(of: "_", with: " ")
        return replaceUnderLineToSpace
    }
}
