////
////  File.swift
////  ZanyaFirst
////
////  Created by Kimjaekyeong on 2023/07/18.
////
//
////MARK: - 셋 이미지랑 셋 네임이랑 디자인단에서 합쳐지면서 얘는 셋 프로필에 병합되었음 // 고로 안쓰고 있지만 걍 냅둠
//import Foundation
//import CloudKit
//
//class SetImageViewModel: ObservableObject {
//    
////    var profile: Profile = dummyProfile0
//    @Published var catNameNum: Int = 0
//
//    @Published var goToMainView: Bool = false
//
//    init() {
//        fetchUID()
//    }
//
//    // MARK: - Update
//    private func updateItem(profile: Profile) {
//        fetchUID()
//        self.profile.imageKey = catNameNum
//        if let record = profile.record{
//            record["ImageKey"] = catNameNum
//            saveItem(record: record)
//            print("업데이트")
//        }
//    }
//
//    private func saveItem(record: CKRecord) {
//        CKContainer.default().publicCloudDatabase.save(record) { returnedRecord, returnedError in
//            print("Record: \(returnedRecord)")
//            print("Error: \(returnedError)")
//
//        }
//    }
//
//    func fetchUID() {
//        CKContainer.default().fetchUserRecordID { [weak self] returnedID, returnedError in
//            if let id = returnedID {
//                let predicate = NSPredicate(format: "uid = %@", argumentArray: ["\(id.recordName)"])
//                let query = CKQuery(recordType: "Profile", predicate: predicate)
//                let queryOperation = CKQueryOperation(query: query)
//
//                queryOperation.recordMatchedBlock = {  (returnedRecordID, returnedResult) in
//                    switch returnedResult {
//                    case .success(let record):
//                        guard let name = record["name"] as? String else { return }
//
//                        DispatchQueue.main.async {
//                            self?.profile = Profile(UID: id.recordName, name: name, imageKey: nil, record: record)
//                        }
//                    case .failure(let error):
//                        print("Error recordMatchedBlock: \(error)")
//                    }
//                }
//
//                queryOperation.queryResultBlock = { returnedResult in
//                    print("Returned result: \(returnedResult)")
//
//
//                }
//
//                CKContainer.default().publicCloudDatabase.add(queryOperation)
//            }
//        }
//
//    }
//
//    func clickedCatBtn(_ cat: Int) {
//        catNameNum = cat
//    }
//
//    func completeButtonPressed() {
//        guard !ProfileImageArray[catNameNum].isEmpty else { return }
//        updateItem(profile: profile)
//        goToMainView = true
//
//    }
//}
//
