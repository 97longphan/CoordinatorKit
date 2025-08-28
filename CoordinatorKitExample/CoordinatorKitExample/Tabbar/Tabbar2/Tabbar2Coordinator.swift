//
//  Tabbar2Coordinator.swift
//  CoordinatorCore
//
//  Created by LONGPHAN on 30/6/25.
//

import Foundation
import CoordinatorKit

class Tabbar2Coordinator: BaseRouterCoordinator {
    
    override func start() {
        let vc = Tabbar2ViewController()
        vc.delegate = self
        
        perform(vc, from: self) { [weak self] in
            guard let self = self  else { return }
            self.parentCoordinator?.childDidFinish(self)
        }
    }
    
    private func goToStep1() {
        let step1 = Step1Coordinator(router: router,
                                     presentationStyle: .push,
                                     context: StepContext(message: "Data push from Tabbar2Coordinator"))
        step1.parentCoordinator = self
        children.append(step1)
        step1.start()
    }
}

extension Tabbar2Coordinator: Tabbar2Delegate {
    func pushToStep1() {
        goToStep1()
    }
}

extension Tabbar2Coordinator: FinishFlowPushDelegate {
    func didFinishFlow() {
        router.popToRootCoordinator(isAnimated: true)
    }
}
