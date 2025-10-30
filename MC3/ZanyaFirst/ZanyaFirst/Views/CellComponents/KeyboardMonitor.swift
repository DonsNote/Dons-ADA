//
//  KeyboardMonitor.swift
//  ZanyaFirst
//
//  Created by Kimjaekyeong on 2023/07/30.
//

import Foundation
import Combine
import UIKit

final class KeyboardMonitor : ObservableObject {
    
    enum Status {
        case show, hide
        var description : String {
            switch self {
            case .show: return "show"
            case .hide: return "hide"
            }
        }
    }
    
    var subsscriptions = Set<AnyCancellable>()
    
    @Published var updatedKeyboardStatusAction : Status = .hide
    @Published var keyboardHeight : CGFloat = 0
    @Published var isKeyboardUP : Bool = false
    
    init() {
        print("KeyboardMonitor - init() called")
        //키보드 올라갈때
        NotificationCenter.Publisher(center: NotificationCenter.default, name: UIResponder.keyboardWillShowNotification)
            .sink{ (noti : Notification) in
                print("KeyboardMonitor - keyboardWillShowNotification: noti : ", noti)
                self.updatedKeyboardStatusAction = .show
                self.isKeyboardUP = true
            }.store(in: &subsscriptions)
        //키보드 내려갈 때
        NotificationCenter.Publisher(center: NotificationCenter.default, name: UIResponder.keyboardWillHideNotification)
            .sink{ [weak self] (noti : Notification) in
                print("KeyboardMonitor - keyboardWillHideNotification: noti : ", noti)
                DispatchQueue.main.async {
                    self?.updatedKeyboardStatusAction = .hide
                    self?.keyboardHeight = 0
                    self?.isKeyboardUP = false
                }
            }.store(in: &subsscriptions)
        //키보드가 사이즈 변경할때
        NotificationCenter.Publisher(center: NotificationCenter.default, name: UIResponder.keyboardWillChangeFrameNotification)
            .sink{ [weak self] (noti : Notification) in
                print("KeyboardMonitor - keyboardDidChangeFrameNotification: noti : ", noti)
                let keyboardFrame = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
                
                print("KeyboardMonitor - keyboardDidChangeFrameNotification:  keyboardFrame.height:", keyboardFrame.height)
                
                DispatchQueue.main.async {
                    self?.keyboardHeight = keyboardFrame.height
                }
                
            }.store(in: &subsscriptions)
        
    }
}
