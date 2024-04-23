import Foundation
import SwiftyKeychainKit

class KeychainService {
    
    static let shared = KeychainService()
    
    private init() {}
    
    private let keychain = Keychain()
    
    private let service = "anton.kurdo.TMS-IOS-LESSON-33-HW"
    
    let queue = DispatchQueue(label: "keychain")
    
    func set(_ value: String, for key: String) {
        queue.sync {
            do {
                let accessTokenKey = KeychainKey<String>.genericPassword(key: key, service: service)
                
                try keychain.set(value, for: accessTokenKey)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func update(_ value: String, for key: String) {
        queue.sync {
            do {
                let accessTokenKey = KeychainKey<String>.genericPassword(key: key, service: service)
                
                try keychain.set(value, for: accessTokenKey)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func getValue(for key: String) -> String? {
        var value: String? = nil
        queue.sync {
            do {
                let accessTokenKey = KeychainKey<String>.genericPassword(key: key, service: service)
                
                value = try keychain.get(accessTokenKey)
            } catch {
                print(error.localizedDescription)
            }
        }
        return value
    }
    
    func removeValue(for key: String) {
        queue.sync {
            do {
                let accessTokenKey = KeychainKey<String>.genericPassword(key: key, service: service)
                
                try keychain.remove(accessTokenKey)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func clean() {
        queue.sync {
            do {
                try keychain.removeAll()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}


