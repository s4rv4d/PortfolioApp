//
//  Bundle-Decodable.swift
//  PortfolioApp
//
//  Created by Sarvad Shetty on 12/01/2021.
//

// swiftlint:disable trailing_whitespace

import Foundation

extension Bundle {
    func decode<T: Decodable>(
        _ type: T.Type,
        from file: String,
        dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate,
        keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys
    ) -> T {
        
        /// find file
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) from bundle")
        }
        
        /// get data
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle")
        }
        
        /// decoder
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = dateDecodingStrategy
        decoder.keyDecodingStrategy = keyDecodingStrategy
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch DecodingError.keyNotFound(let key, let context) {
            // swiftlint:disable:next line_length
            fatalError("failed to decode \(file) from bundle due to missing key \(key.stringValue) - \(context.debugDescription)")
        } catch DecodingError.typeMismatch(_, let context) {
            fatalError("failed to decode \(file) from bundle due to type mismatch - \(context.debugDescription)")
        } catch DecodingError.valueNotFound(let type, let context) {
            // swiftlint:disable:next line_length
            fatalError("failed to decode \(file) from bundle due to missing \(type) value - \(context.debugDescription)")
        } catch DecodingError.dataCorrupted(_) {
            fatalError("failed to decode \(file) from bundle because it appears to be invalid JSON")
        } catch {
            fatalError("failed to decode \(file) from bundle - \(error.localizedDescription)")
        }
    }
}
