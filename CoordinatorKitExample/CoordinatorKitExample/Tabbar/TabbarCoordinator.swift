//
//  TabbarCoordinator.swift
//  CoordinatorCore
//
//  Created by LONGPHAN on 30/6/25.
//

import Foundation
import UIKit
import CoordinatorKit
protocol TabbarCoordinatorDelegate: AnyObject {}

protocol TabbarDelegate: AnyObject {
    func changeTabbarTo(_ tabbarType: TabbarType)
}

class TabbarCoordinator: Coordinator, ActiveChildCoordinator {
    // MARK: - Properties
    
    var activeChildCoordinator: Coordinator? {
        children[safe: tabBarController.selectedIndex]
    }
    
    weak var delegate: TabbarCoordinatorDelegate?
    weak var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    
    private let tabBarController: UITabBarController
    private var tabRouters: [Int: Router] = [:]
    
    // MARK: - Init
    
    init(tabBarController: UITabBarController) {
        self.tabBarController = tabBarController
    }
    
    // MARK: - Start
    
    func start() {
        var viewControllers: [UIViewController] = []
        
        for tab in TabbarType.allCases {
            let navController = UINavigationController()
            let router = Router(navigationController: navController)
            tabRouters[tab.rawValue] = router
            
            let coordinator = tab.makeCoordinator(router: router)
            coordinator.parentCoordinator = self
            children.append(coordinator)
            coordinator.start()
            
            navController.tabBarItem = UITabBarItem(
                title: tab.title,
                image: UIImage(named: "\(tab.icon)"),
                tag: tab.rawValue
            )
            viewControllers.append(navController)
        }
        
        tabBarController.viewControllers = viewControllers
    }
}

extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

extension TabbarCoordinator: TabbarDelegate {
    func changeTabbarTo(_ tabbarType: TabbarType) {
        tabBarController.selectedIndex = tabbarType.rawValue
    }
}

