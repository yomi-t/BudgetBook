import SharedModel
import SwiftData

@MainActor
public protocol BalanceRepositoryProtocol {
    func add(_ balance: Balance) async
    func fetchAllBalances() async -> [Balance]
    func fetchLatestBalances() async -> [Balance]
}
