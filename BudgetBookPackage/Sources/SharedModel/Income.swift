import Foundation
import SwiftData

@Model
public final class Income {
    @Attribute(.unique)
    public var id: String
    public var source: String
    public var year: Int
    public var month: Int
    public var amount: Int

    public init(source: String, year: Int, month: Int, amount: Int) {
        self.id = UUID().uuidString
        self.source = source
        self.year = year
        self.month = month
        self.amount = amount
    }
    
    public func yearMonth() -> String {
        return "\(month)-\(year)"
    }
}
