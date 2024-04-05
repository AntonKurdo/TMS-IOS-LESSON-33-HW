import Foundation

class AuthService {
    static let shared = AuthService()
    
    private init() {}
    
    private let keychain = KeychainService.shared
    @UserDefaultsWrapper<Bool>(key: "isLogin", default: false) var isLogin
    
    func signIn(login: String, password: String, completion: (() -> ())){
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
    
    func logout(completion: (() -> ())?) {
        isLogin = false
        KeychainService.shared.removeValue(for: "password")
        KeychainService.shared.removeValue(for: "token")
        KeychainService.shared.removeValue(for: "loginDate")
        UINotificationCenterService.shared.removePreviousNotifications()
        completion?()
    }
    
    func checkToken(success: (() -> ()), fail: (() -> ())) {
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

