//
//  CKDeeplinkManager.swift
//
//
//  Created by LONGPHAN on 3/9/25.
//

import Foundation

public protocol CKDeeplinkHandlerDelegate: AnyObject {
    func handleDeeplink(component: CKDeeplinkPluginComponent, plugin: CKDeepLinkPlugin)
}

public final class CKDeeplinkManager {
    public static let shared = CKDeeplinkManager()
    
    weak var delegate: CKDeeplinkHandlerDelegate?
    private var plugins: [CKDeepLinkPlugin] = []
    
    private init() {}
    
    // MARK: - Setup
    
    public func setup(delegate: CKDeeplinkHandlerDelegate, plugins: [CKDeepLinkPlugin]) {
        self.delegate = delegate
        self.plugins.append(contentsOf: plugins)
    }
    
    // MARK: - Deeplink handling
    
    public func handle(url: URL, context: [String: Any] = [:]) {
        let component = CKDeeplinkPluginComponent(url: url, context: context)
        
        guard let plugin = plugins.first(where: { $0.isApplicable(component: component) }) else {
            print("❌ No plugin matched deeplink: \(url.absoluteString)")
            return
        }
        
        print("✅ Plugin matched: \(type(of: plugin))")
        delegate?.handleDeeplink(component: component, plugin: plugin)
    }
}

