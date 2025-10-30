

import Foundation
import UserNotifications
import UIKit

@MainActor
class LocalNotificationManager: NSObject, ObservableObject, UNUserNotificationCenterDelegate {

    let notificationCenter = UNUserNotificationCenter.current()
    @Published var isAuthorized = false

    //Store a alist of notification
    @Published var pendingAlarms: [UNNotificationRequest] = []

    //View Model for AlarmModel
    @Published var alarmViewModels: [AlarmModel] = [] {
        didSet {
            saveItem()
        }
    }

    let itemKey = "Alarm List"

    func requestAuthorization() async throws {
        try await notificationCenter
            .requestAuthorization(options: [
                .sound, .badge, .alert
            ])

        await getCurrentSetting()
    }

    func getCurrentSetting() async {
        let currentSettings = await notificationCenter.notificationSettings()

        isAuthorized = currentSettings.authorizationStatus == .authorized
    }

    func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(url) {
                Task{
                    await UIApplication.shared.open(url)
                }
            }
        }
    }

    //Save state for alarm view model
    func saveItem() {
        if let encodeData = try? JSONEncoder()
            .encode(alarmViewModels) {
            UserDefaults
                .standard
                .set(encodeData, forKey: itemKey)
        }
    }

    override init() {
        super.init()
        // TODO: Want alarm to go off when app is also active


        //Alarm view model - persistance
        guard let data = UserDefaults
            .standard
            .data(forKey: itemKey),
              let saveItems = try? JSONDecoder()
            .decode([AlarmModel].self, from: data)
        else {
            return
        }
        self.alarmViewModels = saveItems
    }

    func gwtPendingAlarm() async {
        pendingAlarms = await notificationCenter
            .pendingNotificationRequests()
    }
}
