import Foundation
import SwiftData

@Model
public final class BalanceDTO {
    @Attribute(.unique)
    public var id: String
    public var account: String
    public var year: Int
    public var month: Int
    public var amount: Int

    public init(account: String, year: Int, month: Int, amount: Int) {
        self.id = UUID().uuidString
        self.account = account
        self.year = year
        self.month = month
        self.amount = amount
    }
    
    public init(_ balance: Balance) {
        self.id = balance.id
        self.account = balance.account
        self.year = balance.year
        self.month = balance.month
        self.amount = balance.amount
    }
}
