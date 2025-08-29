//
//  Coordinator.swift
//  CoordinatorKitExample
//
//  Created by LONGPHAN on 27/6/25.
//

import Foundation
import UIKit

public protocol Coordinator: AnyObject {
    var parentCoordinator: Coordinator? { get set }
    var children: [Coordinator] { get set }
    
    func start()
    func childDidFinish(_ child: Coordinator)
}

extension Coordinator {
    public func childDidFinish(_ child: Coordinator) {
        print("🧹 [Coordinator] Removed child: \(type(of: child))")
        children.removeAll { $0 === child }
    }
}

extension Coordinator {
    public func printCoordinatorTree(level: Int = 0) {
        let indent = String(repeating: "  ", count: level)
        
        if let routerCoordinator = self as? RouterCoordinator {
            let routerType = type(of: routerCoordinator.router)
            
            let styleDescription: String
            switch routerCoordinator.presentationStyle {
            case .push:
                styleDescription = "push"
            case .present(let modalStyle):
                styleDescription = "modal(\(modalStyle))"
            }
            
            print("\(indent)📍 \(type(of: self)) 📦 Router: \(routerType) [\(styleDescription)]")
        } else {
            print("\(indent)📍 \(type(of: self))")
        }
        
        for child in children {
            child.printCoordinatorTree(level: level + 1)
        }
    }
}
