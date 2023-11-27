//
// Copyright (c) Vatsal Manot
//

import CorePersistence
import Merge
import Swallow
import SwiftUIZ

public struct LTAccount: Codable, Hashable, InterfaceModel {
    public typealias ID = _TypeAssociatedID<Self, UUID>
    
    @LogicalParent var store: LTAccountsStore
    
    public let id: ID
    public let accountType: LTAccountType
    @_UnsafelySerialized
    public var credential: (any LTAccountCredential)?
    public var accountDescription: String?
    
    public init(accountType: LTAccountType) {
        self.id = .init()
        self.accountType = accountType
    }
}
 
public struct LTAccountType: Codable, ExpressibleByStringLiteral, Hashable, Sendable {
    public var rawValue: String
    
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
    
    public init(from decoder: Decoder) throws {
        try self.init(rawValue: String(from: decoder))
    }
    
    public func encode(to encoder: Encoder) throws {
        try rawValue.encode(to: encoder)
    }
    
    public init(stringLiteral value: StringLiteralType) {
        self.init(rawValue: .init(stringLiteral: value))
    }
}

// MARK: - Conformances

extension LTAccount: PersistentIdentifierConvertible {
    public var persistentID: ID {
        id
    }
}
