//
// Copyright (c) Vatsal Manot
//

import SwiftUIX

public struct _SubmitModelAction {
    public let type: Any.Type
    public let action: (Any) -> Void
    
    public init() {
        self.type = Any.self
        self.action = { _ in
            assertionFailure("No submit action registered for this view.")
        }
    }
    
    public init<T>(_ action: @escaping (T) -> Void) {
        let type = T.self
        
        self.type = type
        self.action = { value in
            guard let value = value as? T else {
                assertionFailure("Expected an input of type \(type) but received \(Swift.type(of: value))")
                
                return
            }
            
            action(value)
        }
    }
    
    public func callAsFunction<T>(_ x: T) {
        action(x)
    }
}

extension EnvironmentValues {
    public var _submit: _SubmitModelAction {
        get {
            self[DefaultEnvironmentKey<_SubmitModelAction>.self] ?? .init()
        } set {
            self[DefaultEnvironmentKey<_SubmitModelAction>.self] = newValue
        }
    }
}

extension View {
    public func onSubmit<Model>(
        of model: Model.Type,
        perform action: @escaping (Model) -> Void
    ) -> some View {
        _environment(_SubmitModelAction(action))
    }
}
