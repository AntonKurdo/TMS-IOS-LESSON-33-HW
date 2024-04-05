import Foundation
import UserNotifications


class UINotificationCenterService {
    static let shared = UINotificationCenterService()
    
    private var notificationCenter = UNUserNotificationCenter.current()
    
    private let identifier = "loginNotification"
    
    private init() {}
    
    func checkPermission(successCompletion: @escaping (() -> ())) {
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
        let timeInterval: TimeInterval = 60 * 60 * 24 // 1 day in seconds
        content.title = "Attention"
        content.subtitle = "You need to relogin"
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        notificationCenter.add(request)
    }
    
    func removePreviousNotifications() {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
    }
}
