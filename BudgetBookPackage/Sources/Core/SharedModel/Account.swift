import Foundation

public struct Account: Sendable, Hashable {
    public let id: UUID
    public let name: String
    public var createdAt: Date
    
    init(name: String) {
        self.id = UUID()
        self.name = name
        self.createdAt = Date()
    }
    
    public init(dto: AccountDTO) {
        self.id = dto.id
        self.name = dto.name
        self.createdAt = dto.createdAt
    }
}
