//
//  Tabbar1Coordinator.swift
//  CoordinatorCore
//
//  Created by LONGPHAN on 30/6/25.
//

import Foundation
import CoordinatorKit

enum Tabbar1PendingAction {
    case presentStep2
}

class Tabbar1Coordinator: BaseRouterCoordinator {
    override func start() {
        let vc = Tabbar1ViewController()
        vc.delegate = self
        
        perform(vc, from: self) { [weak self] in
            guard let self = self  else { return }
            self.parentCoordinator?.childDidFinish(self)
        }
    }
}

extension Tabbar1Coordinator: Tabbar1ViewControllerDelegate {
    func didPresentStep2() {
        let step2 = Step2Coordinator(router: router,
                                     presentationStyle: .present(.overFullScreen), context: StepContext(message: "Context from Tabbar1Coordinator"))
        step2.parentCoordinator = self
        children.append(step2)
        step2.start()
    }
    
    func didLogout() {
        if let evenHandler = self.findAncestor(ofType: AppLogoutDelegate.self) {
            evenHandler.didLogout()
        } else {
            print("⚠️ [Coordinator] No AppLogoutDelegate found in chain")
        }
    }
}
