import Foundation

public struct LeftMoneyItem {
    public let id: String
    public let title: String
    public let amount: Int
    
    public init(id: String, title: String, amount: Int) {
        self.id = id
        self.title = title
        self.amount = amount
    }
}
