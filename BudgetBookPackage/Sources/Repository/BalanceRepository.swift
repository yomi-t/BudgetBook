import Protocols
import SharedModel
import SwiftData

@MainActor
public class BalanceRepository: BalanceRepositoryProtocol {
    
    private let container: ModelContainer?
    
    public static let shared = BalanceRepository()

    private init() {
        self.container = try? ModelContainer(for: Balance.self)
    }

    public func add(_ balance: Balance) async {
        container?.mainContext.insert(balance)
        try? container?.mainContext.save()
    }
    
    public func fetchAllBalances() async -> [Balance] {
        let descriptor = FetchDescriptor<Balance>(sortBy: [
            .init(\.year),
            .init(\.month)
        ])
        do {
            return try container?.mainContext.fetch(descriptor) ?? []
        } catch {
            print("Error fetching balances: \(error)")
            return []
        }
    }
    
    public func fetchLatestBalances() async -> [Balance] {
        let descriptor = FetchDescriptor<Balance>(sortBy: [
            .init(\.year, order: .reverse),
            .init(\.month, order: .reverse)
        ])
        do {
            let response = try container?.mainContext.fetch(descriptor) ?? []
            return selectFirstBalance(response)
        } catch {
            print("Error fetching latest balances: \(error)")
            return []
        }
    }
}

extension BalanceRepository {
    private func selectFirstBalance(_ balances: [Balance]) -> [Balance] {
        var latestBalances: [Balance] = []
        for balance in balances {
            if latestBalances.contains(where: { $0.account == balance.account }) {
                continue
            } else {
                latestBalances.append(balance)
            }
        }
        
        return latestBalances
    }
}
