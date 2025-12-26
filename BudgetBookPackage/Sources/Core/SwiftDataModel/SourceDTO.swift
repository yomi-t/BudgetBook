import Foundation
import SwiftData

@Model
public final class SourceDTO {
    public var id: UUID
    public var name: String
    public var createdAt: Date

    public init(name: String) {
        self.id = UUID()
        self.name = name
        self.createdAt = Date()
    }
    
    public init(_ account: Account) {
        self.id = account.id
        self.name = account.name
        self.createdAt = account.createdAt
    }
}
