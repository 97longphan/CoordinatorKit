//
//  Coordinator.swift
//  CoordinatorKitExample
//
//  Created by LONGPHAN on 27/6/25.
//

import Foundation
import UIKit

/// Protocol dành cho những Coordinator quản lý nhiều child,
/// nhưng tại một thời điểm chỉ có duy nhất một child được hiển thị (active/visible).
///
/// Ví dụ:
/// - `TabbarCoordinator` → child active là tab đang được chọn
/// - `PageCoordinator` → child active là page đang hiển thị
///
/// Các Coordinator bình thường (push flow, modal flow) KHÔNG cần implement protocol này.
/// Chỉ implement khi có khái niệm "một child đang hiển thị duy nhất".
public protocol ActiveChildCoordinator: Coordinator {
    var activeChildCoordinator: Coordinator? { get }
}

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

extension Coordinator {
    /// Lấy coordinator sâu nhất trong cây hiện tại.
    /// - Nếu coordinator hỗ trợ chứa tab (ví dụ TabbarCoordinator), sẽ đi vào tab đang được chọn.
    /// - Nếu không, đệ quy xuống coordinator con cuối cùng (children.last).
    public func findCoordinator<T: Coordinator>(as type: T.Type) -> T? {
        if let match = self as? T {
            return match
        }
        for child in children {
            if let found = child.findCoordinator(as: type) {
                return found
            }
        }
        return nil
    }
    
    /// Coordinator sâu nhất (deepest) đang hiển thị trong cây coordinator.
    ///
    /// - Nếu `self` conform `ActiveChildCoordinator` (ví dụ `TabbarCoordinator`, `PageCoordinator`),
    ///   thì tiếp tục đệ quy xuống `activeChildCoordinator`.
    /// - Nếu không, tiếp tục đệ quy xuống `children.last` (coordinator con được push/present sau cùng).
    /// - Nếu không có child phù hợp, trả về chính `self`.
    ///
    /// Dùng để xác định coordinator hiện tại đang hiển thị cuối cùng (visible nhất),
    /// bất kể đó là flow bình thường hay container coordinator như tabbar.
    public var deepestVisibleCoordinator: Coordinator {
        if let active = self as? ActiveChildCoordinator {
            return active.activeChildCoordinator?.deepestVisibleCoordinator ?? self
        } else {
            return children.last?.deepestVisibleCoordinator ?? self
        }
    }
    
    /// Trả về RouterCoordinator sâu nhất đang hiển thị.
    /// Nếu deepest không phải RouterCoordinator thì leo ngược lên cho tới khi gặp RouterCoordinator.
    public var deepestVisibleRouterCoordinator: RouterCoordinator? {
        var current: Coordinator? = deepestVisibleCoordinator
        while let coor = current {
            if let routerCoor = coor as? RouterCoordinator {
                return routerCoor
            }
            current = coor.parentCoordinator
        }
        return nil
    }
}
