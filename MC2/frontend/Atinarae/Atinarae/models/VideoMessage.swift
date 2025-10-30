//
//  Message.swift
//  Atinarae
//
//  Created by HyunwooPark on 2023/05/02.
//
import Foundation

struct VideoMessage: Equatable{
    let messageId: Int
    let sender: User
    let receiver: User
    let createdDate: Date
    let unlockedDate: Date
    let edittingCount: Int
    let title: String
    let category: String
    let videoSrc: String
    let isCompleted: Bool
    let hideAtSender: Bool
    let hideAtReceiver: Bool
    
    init(messageId: Int, sender: User, receiver: User, createdDate: Date, unlockedDate: Date, edittingCount: Int, title: String, category: String, videoSrc: String, isCompleted: Bool, hideAtSender: Bool, hideAtReceiver: Bool) {
        self.messageId = messageId
        self.sender = sender
        self.receiver = receiver
        self.createdDate = createdDate
        self.unlockedDate = unlockedDate
        self.edittingCount = edittingCount
        self.title = title
        self.category = category
        self.videoSrc = videoSrc
        self.isCompleted = isCompleted
        self.hideAtSender = hideAtSender
        self.hideAtReceiver = hideAtReceiver
    }
}
