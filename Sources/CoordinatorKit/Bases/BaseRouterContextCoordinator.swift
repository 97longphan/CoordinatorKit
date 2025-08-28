//
//  BaseRouterContextCoordinator.swift
//  CoordinatorKitExample
//
//  Created by LONGPHAN on 2/7/25.
//

import Foundation

open class BaseRouterContextCoordinator<Context>: BaseRouterCoordinator {
    public let context: Context

    public init(
        router: RouterProtocol,
        presentationStyle: RouterPresentationStyle,
        context: Context
    ) {
        self.context = context
        super.init(router: router, presentationStyle: presentationStyle)
    }

    open override func start() {
        fatalError("Subclasses must override start()")
    }
}
