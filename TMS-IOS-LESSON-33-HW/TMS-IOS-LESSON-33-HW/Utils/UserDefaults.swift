import Foundation

@propertyWrapper
public struct UserDefaultsWrapper<T> {
    private let key: String
    private let defaultValue: T!
    private let userDefaults: UserDefaults

    public var wrappedValue: T {
        get {
            let anyValue = userDefaults.value(forKey: key)
            let value: T = (anyValue as? T) ?? defaultValue
            return value
        }
        set {
            if let optional = newValue as? AnyOptional, optional.isNil {
                userDefaults.removeObject(forKey: key)

                if let defaultValue = defaultValue {
                    self.set(newValue: defaultValue)
                }
            } else {
                self.set(newValue: newValue)
            }
            userDefaults.synchronize()
        }
    }

    public var projectedValue: ActionUserDefault { self }

    public init(key: String, default defaultValue: T? = nil, userDefaults: UserDefaults = .standard) {
        self.key = key
        self.userDefaults = userDefaults
        self.defaultValue = defaultValue
    }

    private func set(newValue: T) {
        DispatchQueue.global().async {
            userDefaults.setValue(newValue, forKey: key)
        }
    }
}

extension UserDefaultsWrapper: ActionUserDefault {

    public func removeObject() {
        userDefaults.removeObject(forKey: key)

        if let defaultValue = defaultValue {
            self.set(newValue: defaultValue)
        }
    }
}

private protocol AnyOptional {
    var isNil: Bool { get }
}

extension Optional: AnyOptional {
    var isNil: Bool { self == nil }
}

public protocol ActionUserDefault {
    func removeObject()
}
