//
//  RouterCoordinator.swift
//  CoordinatorKitExample
//
//  Created by LONGPHAN on 2/7/25.
//

import UIKit

public enum RouterPresentationStyle {
    case push
    case present(UIModalPresentationStyle)
    
    public var isUsingPresent: Bool {
        if case .present = self { return true }
        return false
    }
}

public protocol RouterCoordinator: Coordinator {
    var router: RouterProtocol { get set }
    var presentationStyle: RouterPresentationStyle { get }
    var parentRouter: RouterProtocol { get set }
}

extension RouterCoordinator {
    public func perform<V: UIViewController>(
        _ viewController: V,
        isAnimated: Bool = true,
        from coordinator: Coordinator,
        onFinish: (() -> Void)? = nil
    ) {
        switch presentationStyle {
        case .present(let style):
            let nav = UINavigationController(rootViewController: viewController)
            nav.modalPresentationStyle = style
            let presentingRouter = Router(navigationController: nav)
            
            parentRouter = router
            
            router.present(drawable: nav, coordinator: coordinator, isAnimated: isAnimated, onDismiss: onFinish)
            
            router = presentingRouter
            
        case .push:
            router.push(drawable: viewController, to: coordinator, isAnimated: isAnimated, onNavigateBack: onFinish)
        }
    }
}
