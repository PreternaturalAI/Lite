//
// Copyright (c) Vatsal Manot
//

import SwiftUIZ

public struct LTAccountForm: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\._submit) var submit
    
    public enum Intent {
        case create
        case edit
    }
    
    public let intent: Intent
    public let account: LTAccountTypeDescription
    
    @_ConstantOrStateOrBinding var credential: (any LTAccountCredential)?
    
    public init(
        _ intent: Intent,
        account: LTAccountTypeDescription,
        credential: Binding<(any LTAccountCredential)?>? = nil
    ) {
        self.intent = intent
        self.account = account
        self._credential = credential.map({ .binding($0) }) ?? .state(initialValue: nil)
    }
    
    public var body: some View {
        Group {
            _TypeCastBinding($credential.withDefaultValue(account.credentialType.empty)) { proxy in
                proxy.as(_LTAccountCredential.APIKey.self) { $binding in
                    APICredential(subject: $binding)
                }
            }
        }
        .formStyle(.grouped)
        .onSubmit(of: (any LTAccountCredential).self) { credential in
            submit(LTAccount(accountType: account.accountType, credential: credential, description: "Untitled"))
        }
        .toolbar {
            ToolbarItemGroup(placement: .cancellationAction) {
                DismissPresentationButton("Cancel") 
            }

            ToolbarItemGroup(placement: .confirmationAction) {
                DismissPresentationButton("Done") {
                    
                }
            }
        }
    }
    
    struct APICredential: View {
        @Environment(\._submit) var submit
        
        @Binding var subject: _LTAccountCredential.APIKey
        
        var body: some View {
            Form {
                TextField("Enter your API key here", text: $subject.key)
                    ._focusOnAppear()
            }
            .onSubmit {
                submit(subject)
            }
        }
    }
}
