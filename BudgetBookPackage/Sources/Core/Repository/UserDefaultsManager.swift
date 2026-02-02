import Foundation

public struct UserDefaultsManager {
    public static func set(_ value: Int, forKey key: UserDefaultsKey) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
    
    public static func get(forKey key: UserDefaultsKey) -> Int {
        UserDefaults.standard.integer(forKey: key.rawValue)
    }
}

public enum UserDefaultsKey: String, Sendable {
    case goal
}
