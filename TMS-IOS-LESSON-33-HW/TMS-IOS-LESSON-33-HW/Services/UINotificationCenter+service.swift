import Foundation
import UserNotifications


class UINotificationCenterService {
    static let shared = UINotificationCenterService()
    
    private var notificationCenter = UNUserNotificationCenter.current()
    
    private let identifier = "loginNotification"
    
    let dayTimeInterval: TimeInterval = 60 * 60 * 24 // 1 day in seconds
    
    private init() {}
    
    func checkPermission(successCompletion: @escaping (() -> Void)) {
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                successCompletion()
            } else if let error {
                print(error.localizedDescription)
            }
        }
    }

    func addNotification() {
        let content = UNMutableNotificationContent()
        content.title = String(localized: "Notification.title")
        content.subtitle = String(localized: "Notification.subTitle")
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: dayTimeInterval, repeats: false)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        notificationCenter.add(request)
    }
    
    func removePreviousNotifications() {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
    }
}
