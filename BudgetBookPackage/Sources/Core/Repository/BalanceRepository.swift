import ComposableArchitecture
import SwiftData

public extension DependencyValues {
    var balanceRepository: BalanceRepository {
        get { self[BalanceRepository.self] }
        set { self[BalanceRepository.self] = newValue }
    }
}

public struct BalanceRepository: Sendable {
    public var fetchAll: @Sendable @DataActor () throws -> [Balance]
    public var fetchLatestBalances: @Sendable @DataActor () throws -> [Balance]
    public var add: @Sendable @DataActor (Balance) throws -> Void

    enum BalanceError: Error {
        case add
        case delete
        case save
    }
    
    public init(database: Database) {
        self.fetchAll = {
            let context = try database.context()
            let descriptor = FetchDescriptor<BalanceDTO>(sortBy: [
                .init(\.year),
                .init(\.month)
            ])
            let responce = try context.fetch(descriptor)
            return responce.map { Balance(dto: $0) }
        }
        
        self.fetchLatestBalances = {
            let context = try database.context()
            let descriptor = FetchDescriptor<BalanceDTO>(sortBy: [
                .init(\.year, order: .reverse),
                .init(\.month, order: .reverse)
            ])
            let response = try context.fetch(descriptor)
            let balance = response.map { Balance(dto: $0) }
            return BalanceRepository.selectFirstBalance(balance)
        }

        self.add = { model in
            let context = try database.context()
            context.insert(BalanceDTO(model))
            try context.save()
        }
    }
}

extension BalanceRepository: DependencyKey {
    public static let liveValue = Self(database: .liveValue)
}

extension BalanceRepository {
    private static func selectFirstBalance(_ balances: [Balance]) -> [Balance] {
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
