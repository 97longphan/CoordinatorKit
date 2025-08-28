//
//  AppDelegate.swift
//  CoordinatorKitExampleExample
//
//  Created by LONGPHAN on 25/8/25.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var appCoordinator: MyAppCoordinator?
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        
        let coordinator = MyAppCoordinator(window: window, factory: MyAppFlowFactory())
        self.appCoordinator = coordinator
        coordinator.start()
        
        return true
    }
}


