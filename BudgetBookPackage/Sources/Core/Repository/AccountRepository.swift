import ComposableArchitecture
import Foundation
import SwiftData

public extension DependencyValues {
    var accountRepository: AccountRepository {
        get { self[AccountRepository.self] }
        set { self[AccountRepository.self] = newValue }
    }
}

public struct AccountRepository: Sendable {
    public var fetchAll: @Sendable @DataActor () throws -> [Account]
    public var add: @Sendable @DataActor (String) throws -> Void
    public var delete: @Sendable @DataActor (Account) throws -> Void
    
    public init(database: Database) {
        self.fetchAll = {
            let context = try database.context()
            let descriptor = FetchDescriptor<AccountDTO>(sortBy: [
                .init(\.createdAt)
            ])
            let responce = try context.fetch(descriptor)
            return responce.map { Account(dto: $0) }
        }

        self.add = { name in
            let context = try database.context()
            print("Adding account with name: \(name)")
            context.insert(AccountDTO(name: name))
            try context.save()
        }
        
        self.delete = { account in
            let context = try database.context()
            let accountID = account.id
            let predicate = #Predicate<AccountDTO> { dto in
                dto.id == accountID
            }
            let descriptor = FetchDescriptor<AccountDTO>(predicate: predicate)
            if let dto = try context.fetch(descriptor).first {
                context.delete(dto)
                try context.save()
            }
        }
    }
}

extension AccountRepository: DependencyKey {
    public static let liveValue = Self(database: .liveValue)
}
