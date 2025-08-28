//
//  AppCoordinator.swift
//  CoordinatorKitExampleExample
//
//  Created by LONGPHAN on 25/8/25.
//

import Foundation
import CoordinatorKit

enum AppRoute: FlowRoute {
    case login
    case tabbar
}

final class MyAppFlowFactory: FlowFactory {
    typealias Route = AppRoute
    
    weak var loginCoordinatorDelegate: LoginCoordinatorDelegate?
    
    func make(_ route: AppRoute, parent: Coordinator?) -> (UIViewController, Coordinator) {
        switch route {
        case .login:
            let nav = UINavigationController()
            let router = Router(navigationController: nav)
            let coordinator = LoginCoordinator(router: router)
            coordinator.delegate = loginCoordinatorDelegate
            return (nav, coordinator)
        case .tabbar:
            let tabbar = UITabBarController()
            let coordinator = TabbarCoordinator(tabBarController: tabbar)
            coordinator.parentCoordinator = parent
            return (tabbar, coordinator)
        }
    }
    
}

protocol AppLogoutDelegate: AnyObject {
    func didLogout()
}

final class MyAppCoordinator: BaseAppCoordinator<MyAppFlowFactory> {
    private let session: SessionManaging
    
    init(window: UIWindow,
         factory: MyAppFlowFactory,
         session: SessionManaging = SessionManager.shared) {
        self.session = session
        super.init(window: window, factory: factory)
        factory.loginCoordinatorDelegate = self
    }
    
    override func initialRoute() -> BaseAppCoordinator<MyAppFlowFactory>.Route {
        return session.isLoggedIn ? .tabbar : .login
    }
}

extension MyAppCoordinator: LoginCoordinatorDelegate {
    func didLoggedIn() {
        session.login()
        navigate(to: .tabbar)
    }
}

extension MyAppCoordinator: AppLogoutDelegate {
    func didLogout() {
        session.logout()
        navigate(to: .login)
    }
}
