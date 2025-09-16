//
//  Step1DeeplinkPlugin.swift
//  CoordinatorKitExample
//
//  Created by LONGPHAN on 15/9/25.
//

import CoordinatorKit
import UIKit

final class Step1DeeplinkPlugin: CKDeepLinkPlugin {
    let path = "step1"

    func buildCoordinator(component: CKDeeplinkPluginComponent, router: RouterProtocol) -> Coordinator? {
        Step1Coordinator(router: router, presentationStyle: .push, context: .init(message: "Data present from Step1DeeplinkPlugin"))
    }
}
