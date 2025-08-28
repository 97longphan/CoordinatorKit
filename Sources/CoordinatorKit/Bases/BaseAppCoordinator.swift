//
//  AppCoordinatorBase.swift
//  CoordinatorKitExample
//
//  Created by LONGPHAN on 22/8/25.
//

import Foundation

open class BaseAppCoordinator<Factory: FlowFactory>: Coordinator {
    public weak var parentCoordinator: Coordinator?
    public var children: [Coordinator] = []
    
    public let window: UIWindow
    public let factory: Factory
    
    public typealias Route = Factory.Route
    
    public init(window: UIWindow, factory: Factory) {
        self.window = window
        self.factory = factory
    }
    
    open func initialRoute() -> Route { fatalError("Must override initialRoute()") }
    
    open func start() {
        navigate(to: initialRoute())
    }
    
    public func navigate(to route: Route) {
        let (root, coord) = factory.make(route, parent: self)
        coord.parentCoordinator = self
        children = [coord]
        coord.start()
        window.rootViewController = root
        window.makeKeyAndVisible()
    }
}
