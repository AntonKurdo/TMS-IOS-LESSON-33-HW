import Foundation

class AuthService {
    static let shared = AuthService()

    private let keychain = KeychainService.shared
    
    private var timer: Timer? = nil
    
    @UserDefaultsWrapper<Bool>(key: "isLogin", default: false) private var isLogin
    
    private init() {}
    
    func signIn(login: String, password: String,  completion: (() -> Void)){
        let token = UUID().uuidString
        keychain.set(login, for: "login")
        keychain.set(password, for: "password")
        keychain.set(token, for: "token")
        keychain.set(DateFormat.convertCurrentDateToISO(), for: "loginDate")
        isLogin = true
        UINotificationCenterService.shared.checkPermission() {
            UINotificationCenterService.shared.removePreviousNotifications()
            UINotificationCenterService.shared.addNotification()
    
        }
        completion()
    }
    
    func logout(completion: (() -> Void)? = nil) {
        isLogin = false
        keychain.removeValue(for: "password")
        keychain.removeValue(for: "token")
        keychain.removeValue(for: "loginDate")
        UINotificationCenterService.shared.removePreviousNotifications()
        timerInvalidate()
        completion?()
    }
    
    func scheduledLogout(completion: (() -> Void)? = nil) {
        guard let loginDate = KeychainService.shared.getValue(for: "loginDate") else {return}
        DateFormat.dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        let convertedDate = DateFormat.dateFormatter.date(from: loginDate)
    
        guard let convertedDate else { return }
      
        timer = Timer(fireAt: convertedDate.addingTimeInterval(UINotificationCenterService.shared.dayTimeInterval), interval: 0, target: self, selector: #selector(timerSelector), userInfo: CustomTimerInfo(completion: completion!) , repeats: false)
   
        RunLoop.main.add(timer!, forMode: .common)
    }
    
    func timerInvalidate() {
        timer?.invalidate()
    }
    
    @objc func timerSelector(sender: Timer) {
        guard let timerInfo = sender.userInfo as? CustomTimerInfo else { return }
        logout()
        timerInfo.completion()
    }
    
    func checkToken(success: (() -> Void), fail: (() -> Void)) {
        if isLogin {
            let loginDate = KeychainService.shared.getValue(for: "loginDate")
            if let diff = DateFormat.compareISODateWithCurrentDate(date: loginDate), diff == 0 {
                success()
            } else {
                self.logout(completion: nil)
                fail()
            }
        } else {
            fail()
        }
    }
}


class CustomTimerInfo {
    var completion: (() -> Void)
    
    init(completion: @escaping () -> Void) {
        self.completion = completion
    }
}
