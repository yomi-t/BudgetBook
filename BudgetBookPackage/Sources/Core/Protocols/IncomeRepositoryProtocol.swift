import SwiftData

@MainActor
public protocol IncomeRepositoryProtocol {
    func add(_ income: Income) async
    func fetchAllIncomes() async -> [Income]
}
