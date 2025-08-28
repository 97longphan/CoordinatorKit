//
//  TabbarCoordinator.swift
//  CoordinatorCore
//
//  Created by LONGPHAN on 30/6/25.
//

import Foundation
import UIKit
import CoordinatorKit

protocol TabbarDelegate: AnyObject {
    func changeTabbarTo(_ tabbarType: TabbarType)
}

class TabbarCoordinator: Coordinator {
    // MARK: - Properties
    
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
                image: UIImage(systemName: tab.icon),
                tag: tab.rawValue
            )
            viewControllers.append(navController)
        }
        
        tabBarController.viewControllers = viewControllers
    }
}


extension TabbarCoordinator: TabbarDelegate {
    func changeTabbarTo(_ tabbarType: TabbarType) {
        tabBarController.selectedIndex = tabbarType.rawValue
    }
}

extension TabbarCoordinator {
//    var currentTabCoordinator: Coordinator? {
//        let index = tabBarController.selectedIndex
//        return children[safe: index]
//    }
}

