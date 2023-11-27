//
// Copyright (c) Vatsal Manot
//

import CorePersistence
import Foundation
import Swallow

public protocol LTAccountTypeDescription {
    var icon: Image? { get }
    var title: String { get }
    
    var accountType: LTAccountType { get }
    var credentialType: any LTAccountCredential.Type { get }
}

// MARK: - Implemented Conformances

extension _AllCasesOf<LTAccountTypeDescription> {
    public struct OpenAI: LTAccountTypeDescription, _StaticInstance {
        public var accountType: LTAccountType {
            LTAccountType(rawValue: "ai.preternatural.OpenAI")
        }
        
        public var credentialType: any LTAccountCredential.Type {
            _AllCasesOf<LTAccountCredential>.APIKey.self
        }
        
        public var icon: Image? {
            Image("logo/GPT-3", bundle: .module)
        }
        
        public var title: String {
            "OpenAI"
        }
        
        public var serverURL: URL = URL(string: "https://api.openai.com")!
        
        public init() {
            
        }
    }
    
    public struct Anthropic: LTAccountTypeDescription, _StaticInstance {
        public var accountType: LTAccountType {
            LTAccountType(rawValue: "ai.preternatural.Anthropic")
        }
        
        public var credentialType: any LTAccountCredential.Type {
            _AllCasesOf<LTAccountCredential>.APIKey.self
        }
        
        public var icon: Image? {
            Image("logo/Anthropic", bundle: .module)
        }
        
        public var title: String {
            "Anthropic"
        }

        public var serverURL: URL = URL(string: "https://api.anthropic.com")!
        
        public init() {
            
        }
    }
}
