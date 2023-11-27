//
// Copyright (c) Vatsal Manot
//

import CorePersistence
import Swallow

public protocol LTAccountCredential: Codable, Hashable {
    
}

// MARK: - Implemented Conformances


extension _AllCasesOf<LTAccountCredential> {
    public struct APIKey: LTAccountCredential {
        public let serverURL: URL?
        public let key: String
    }
}
