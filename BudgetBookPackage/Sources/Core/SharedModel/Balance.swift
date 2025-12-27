import Foundation

public struct Balance: Sendable, Equatable {
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

    public init(id: String, account: String, year: Int, month: Int, amount: Int) {
        self.id = id
        self.account = account
        self.year = year
        self.month = month
        self.amount = amount
    }
    
    public init(dto: BalanceDTO) {
        self.id = dto.id
        self.account = dto.account
        self.year = dto.year
        self.month = dto.month
        self.amount = dto.amount
    }
    
    public func displayMonth() -> String {
        let monthStr = String(format: "%02d", month)
        let yearStr = String(format: "%02d", year % 100)
        return "\(yearStr)/\(monthStr)"
    }
}

public extension Array<Balance> {
    func convertToGraphData() -> [BalanceGraphModel] {
        var data: [BalanceGraphModel] = []
        for item in self {
            if let sameMonthIndex = data.firstIndex(where: { $0.yearMonth == item.displayMonth() }) {
                data[sameMonthIndex].amount += item.amount
            } else {
                data.append(.init(item))
            }
        }
        return data.sortByMonth()
    }
}
