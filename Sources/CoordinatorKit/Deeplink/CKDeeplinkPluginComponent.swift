//
//  CKDeeplinkPluginComponent.swift
//
//
//  Created by LONGPHAN on 3/9/25.
//

import Foundation

public protocol CKDeepLinkPlugin {
    var path: String { get }
    func isApplicable(component: CKDeeplinkPluginComponent) -> Bool
    func buildCoordinator(component: CKDeeplinkPluginComponent, router: RouterProtocol) -> Coordinator?
}

public extension CKDeepLinkPlugin {
    func isApplicable(component: CKDeeplinkPluginComponent) -> Bool {
        let host = component.url.host?.lowercased()
        let cleanPath = component.url.path
            .trimmingCharacters(in: CharacterSet(charactersIn: "/"))
            .lowercased()
        
        return host == path.lowercased() || cleanPath == path.lowercased()
    }
}

public struct CKDeeplinkPluginComponent {
    public let url: URL
    public let context: [String: Any]
    
    init(url: URL, context: [String: Any] = [:]) {
        self.url = url
        self.context = context
    }
}

extension URL {
    var queryParameters: [String: String]? {
        URLComponents(url: self, resolvingAgainstBaseURL: false)?
            .queryItems?
            .reduce(into: [:]) { $0[$1.name] = $1.value }
    }
}
