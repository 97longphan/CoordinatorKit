//
//  BaseRouterCoordinator.swift
//  CoordinatorCore
//
//  Created by LONGPHAN on 2/7/25.
//

import Foundation
open class BaseRouterCoordinator: RouterCoordinator {
    /// Coordinator cha (nếu có) – dùng để giao tiếp ngược hoặc remove child khi hoàn tất
    weak public var parentCoordinator: Coordinator?

    /// Danh sách các coordinator con đang active
    public var children: [Coordinator] = []

    /// Router gốc hiện tại dùng để điều hướng (push/present) trong luồng này
    public var router: RouterProtocol

    /// Kiểu điều hướng mặc định của coordinator này: `.push` hoặc `.present`
    public let presentationStyle: RouterPresentationStyle
    
    /// mặc định ban đầu = router
    /// set giá trị cho nó trước khi router được gắn router mới
    /// trong trường hợp present với router mới
    public var parentRouter: RouterProtocol

    public init(router: RouterProtocol, presentationStyle: RouterPresentationStyle = .push) {
        self.router = router
        self.presentationStyle = presentationStyle
        self.parentRouter = router
    }

    open func start() {
        fatalError("Subclasses must override `start()`")
    }
    
    deinit {
        print("❌ [Deinit] \(type(of: self)) deallocated (🧹 Coordinator cleaned up)")
    }
}
