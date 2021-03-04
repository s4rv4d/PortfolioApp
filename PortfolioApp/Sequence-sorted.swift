//
//  Sequence-sorted.swift
//  PortfolioApp
//
//  Created by Sarvad Shetty on 11/01/2021.
//

// swiftlint:disable trailing_whitespace

import Foundation

extension Sequence {
    
    /// for uncomparable values
    /// mentioning throw doesnt necessarily mean we have to pass throw it can "CONTAIN A THROW  OR NOT"
    /// rethrow basically says, if it receives a throw, the main function also becomes a throw and vice versa
    func sorted<Value>(
        by keyPath: KeyPath<Element, Value>,
        using areInIncreasingOrder: (Value, Value) throws -> Bool
    ) rethrows -> [Element] {
        try self.sorted {
            try areInIncreasingOrder($0[keyPath: keyPath], $1[keyPath: keyPath])
        }
    }
    
    /// ex: keypath: Item.creationDat value: 12/10/1999 which is comparable
    /// this is for comparable values
    func sorted<Value: Comparable>(by keyPath: KeyPath<Element, Value>) -> [Element] {
        /// over here we arent passing do catch as we are not passing throwing func
        /// `<` is a function which (Value, Value) as input
        self.sorted(by: keyPath, using: <)
    }
    
    /// partial keyPath solution
    func sorted(by keyPath: PartialKeyPath<Element>) -> [Element] {
        guard let keyPathString = keyPath._kvcKeyPathString else { return Array(self) }
        let sortDescriptor = NSSortDescriptor(key: keyPathString, ascending: true)
        return self.sorted(by: sortDescriptor)
    }
    
    /// sorting using NSSortDescriptor
    func sorted(by sortDescriptor: NSSortDescriptor) -> [Element] {
        self.sorted {
            sortDescriptor.compare($0, to: $1) == .orderedAscending
        }
    }
    
    func sorted(by sortDescriptors: [NSSortDescriptor]) -> [Element] {
        self.sorted {
            for descriptor in sortDescriptors {
                switch descriptor.compare($0, to: $1) {
                case .orderedAscending:
                    return true
                case .orderedDescending:
                    return false
                case .orderedSame:
                    continue
                }
            }
            
            return false
        }
    }
}
