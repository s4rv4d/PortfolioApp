//
//  Binding-onChange.swift
//  PortfolioApp
//
//  Created by Sarvad Shetty on 21/12/2020.
//

import SwiftUI

extension Binding {
    
    /// onChange extension function for property wrapper
    func onChange(_ handler: @escaping () -> Void) -> Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                self.wrappedValue = newValue
                /// after newValue is assigned, call handler function
                handler()
            }
        )
    }
}
