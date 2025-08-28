//
//  Coordinator+Extensions.swift
//  CoordinatorKitExample
//
//  Created by LONGPHAN on 30/6/25.
//

import Foundation
extension Coordinator {
    public func findAncestor<T>(ofType type: T.Type) -> T? {
        var current = self.parentCoordinator
        while current != nil {
            if let match = current as? T {
                return match
            }
            current = current?.parentCoordinator
        }
        return nil
    }
}
