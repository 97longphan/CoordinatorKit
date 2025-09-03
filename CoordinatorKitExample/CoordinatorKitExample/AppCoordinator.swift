//
//  AppCoordinator.swift
//  CoordinatorKitExampleExample
//
//  Created by LONGPHAN on 25/8/25.
//

import Foundation
import CoordinatorKit
typealias PendingDeeplink = (component: CKDeeplinkPluginComponent, plugin: CKDeepLinkPlugin)

enum AppRoute: FlowRoute {
    case login
    case tabbar
}

final class MyAppFlowFactory: FlowFactory {
    typealias Route = AppRoute
    
    weak var loginCoordinatorDelegate: LoginCoordinatorDelegate?
    weak var tabbarCoordinatorDelegate: TabbarCoordinatorDelegate?
    
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
            coordinator.delegate = tabbarCoordinatorDelegate
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
    private var pendingDeeplink: PendingDeeplink?
    
    init(window: UIWindow,
         factory: MyAppFlowFactory,
         session: SessionManaging = SessionManager.shared) {
        self.session = session
        super.init(window: window, factory: factory)
        factory.loginCoordinatorDelegate = self
        factory.tabbarCoordinatorDelegate = self
    }
    
    override func initialRoute() -> BaseAppCoordinator<MyAppFlowFactory>.Route {
        return session.isLoggedIn ? .tabbar : .login
    }
    
    private func performDeepLink(component: CKDeeplinkPluginComponent, plugin: CKDeepLinkPlugin, router: RouterProtocol) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            guard let self = self, let coordinator = plugin.buildCoordinator(component: component, router: router) else { return }
            
            coordinator.parentCoordinator = self
            children.append(coordinator)
            coordinator.start()
        }
    }
}

extension MyAppCoordinator: LoginCoordinatorDelegate {
    func didLoggedIn() {
        session.login()
        navigate(to: .tabbar)
        if let deeplink = pendingDeeplink {
            handleDeeplink(component: deeplink.component, plugin: deeplink.plugin)
            pendingDeeplink = nil
        }
    }
}

extension MyAppCoordinator: TabbarCoordinatorDelegate {}

extension MyAppCoordinator: AppLogoutDelegate {
    func didLogout() {
        session.logout()
        navigate(to: .login)
    }
}


extension MyAppCoordinator: CKDeeplinkHandlerDelegate {
    func handleDeeplink(component: CoordinatorKit.CKDeeplinkPluginComponent, plugin: CoordinatorKit.CKDeepLinkPlugin) {
        if session.isLoggedIn, let router = deepestVisibleRouterCoordinator?.router {
            performDeepLink(component: component, plugin: plugin, router: router)
        } else {
            print("🔒 Chưa đăng nhập, lưu deeplink để xử lý sau")
            pendingDeeplink = (component, plugin)
        }
    }
}
