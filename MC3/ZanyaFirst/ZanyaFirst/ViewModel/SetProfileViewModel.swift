//
//  SetProfileViewModel.swift
//  ZanyaFirst
//
//  Created by BAE on 2023/07/19.
//

import Foundation
import CloudKit
import UIKit

class SetProfileViewModel: ObservableObject {
    
    var profile: Profile = Profile(UID: "", name: "", imageKey: "", record: nil)
    
    @Published var name: String = ""
    @Published var userName: String = ""
    @Published var catName: String = "whiteCat_Profile"
    @Published var goToMainView: Bool = false
    @Published var isClickedTextField: Bool = false
    
    init() {
        fetchUID()
    }
    
    @Published var isCompleted: Bool = false
    
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
                        guard let name = record["name"] as? String else { return }
                        
                        DispatchQueue.main.async {
                            self?.profile = Profile(UID: id.recordName, name: name, imageKey: nil, record: record)
                        }
//                        self?.haveProfile()
                    case .failure(let error):
                        print("Error recordMatchedBlock: \(error)")
                    }
                }
                
                queryOperation.queryResultBlock = { returnedResult in
                    print("Returned result setProfile: \(returnedResult)")
                    DispatchQueue.main.async { }
                }
                CKContainer.default().publicCloudDatabase.add(queryOperation)
            }
        }
    }
    
    private func addName(name: String) {
        CKContainer.default().fetchUserRecordID { [weak self]returnedID, returnedError in
            if let id = returnedID {
                let profile = CKRecord(recordType: "Profile")
                
                profile["name"] = name
                profile["uid"] = id.recordName
                
                self?.saveItem(record: profile)
            }
        }
    }
    
    private func updateItem(profile: Profile) {
        fetchUID()
        self.profile.imageKey = catName
        if let record = profile.record{
            record["ImageKey"] = catName
            saveItem(record: record)
            print("업데이트")
        }
    }
    
    private func saveItem(record: CKRecord) {
        CKContainer.default().publicCloudDatabase.save(record) { [weak self] returnedRecord, returnedError in
            print("Record: \(returnedRecord)")
            print("Error: \(returnedError)")
            
            // add 후에는 텍스트필드 비워주는 코드에요
            DispatchQueue.main.async {
                self?.name = ""
            }
        }
    }
    
    func addRecord(name: String, imageKey: String){
        
        CKContainer.default().fetchUserRecordID { [weak self]returnedID, returnedError in
            if let id = returnedID {
                let profile = CKRecord(recordType: "Profile")
                
                profile["name"] = name
                profile["ImageKey"] = imageKey
                profile["uid"] = id.recordName
                
                self?.profile.UID = id.recordName
                self?.profile.name = name
                self?.profile.imageKey = imageKey
                
                self?.saveItem(record: profile)
            }
        }
    }
    
    func clickedCatBtn(_ cat: String) {
        catName = cat
    }
    
    func completeButtonPressed() {
        guard !name.isEmpty else {
            print("there's no userName")
            return
        }
        addRecord(name: self.name, imageKey: self.catName)
        isCompleted.toggle()
       // goToMainView = true
        
        DispatchQueue.main.async { [self] in
            print("viewModel name: \(name) | cat: \(self.catName)")
        }
    }
    
    func printProfile() {
        print("UID : \(profile.UID)")
        print("Name : \(profile.name)")
        print("ImageKey : \(profile.imageKey)")
    }
}

extension UIViewController {
    
    func setKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(UIViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(UIViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object:nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
          if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                  let keyboardRectangle = keyboardFrame.cgRectValue
                  let keyboardHeight = keyboardRectangle.height
              UIView.animate(withDuration: 1) {
                  self.view.window?.frame.origin.y -= keyboardHeight
              }
          }
      }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.window?.frame.origin.y != 0 {
            if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                    let keyboardRectangle = keyboardFrame.cgRectValue
                    let keyboardHeight = keyboardRectangle.height
                UIView.animate(withDuration: 1) {
                    self.view.window?.frame.origin.y += keyboardHeight
                }
            }
        }
    }
}

