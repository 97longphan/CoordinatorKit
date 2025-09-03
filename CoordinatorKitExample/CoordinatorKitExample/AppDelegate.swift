//
//  AppDelegate.swift
//  CoordinatorKitExampleExample
//
//  Created by LONGPHAN on 25/8/25.
//

import UIKit
import CoordinatorKit

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
        let plugins = createDeepLinkPlugins()
        CKDeeplinkManager.shared.setup(delegate: coordinator, plugins: plugins)
        coordinator.start()
        
        return true
    }
    
    
    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
        CKDeeplinkManager.shared.handle(url: url)
        return true
    }
    
    private func createDeepLinkPlugins() -> [CKDeepLinkPlugin] {
        return [Step1DeeplinkPlugin()]
    }
}


