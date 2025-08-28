//
//  Array+Extensions.swift
//  CoordinatorKitExample
//
//  Created by LONGPHAN on 3/7/25.
//

import Foundation

extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
