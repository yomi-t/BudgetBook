import Foundation

public struct ExpenseGraphModel: Identifiable, Equatable, Sendable {
    public var id: String
    public var yearMonth: String
    public var amount: Int

    public init(id: String = UUID().uuidString, yearMonth: String, amount: Int) {
        self.id = id
        self.yearMonth = yearMonth
        self.amount = amount
    }
}

public extension Array<ExpenseGraphModel> {
    func sortByMonth() -> [ExpenseGraphModel] {
        self.sorted { $0.yearMonth < $1.yearMonth }
    }

    func rangeAmount() -> ClosedRange<Int> {
        let maxValue = (self.map { $0.amount }.max() ?? 0) + 10000
        return 0...maxValue
    }
}
