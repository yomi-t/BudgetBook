import Foundation

public struct Income: Sendable, Equatable, Hashable {
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
    
    public init(id: String, source: String, year: Int, month: Int, amount: Int) {
        self.id = id
        self.source = source
        self.year = year
        self.month = month
        self.amount = amount
    }
    
    public init(dto: IncomeDTO) {
        self.id = dto.id
        self.source = dto.source
        self.year = dto.year
        self.month = dto.month
        self.amount = dto.amount
    }
    
    public func yearMonth() -> String {
        "\(month)-\(year)"
    }
    
    public func displayMonth() -> String {
        let monthStr = String(format: "%02d", month)
        let yearStr = String(format: "%02d", year % 100)
        return "\(yearStr)/\(monthStr)"
    }
}

public extension Array<Income> {
    func convertToGraphData() -> [IncomeGraphModel] {
        var data: [IncomeGraphModel] = []
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
