//
//  Step1Coordinator.swift
//  CoordinatorKitExample
//
//  Created by LONGPHAN on 30/6/25.
//

import Foundation
import UIKit
import CoordinatorKit

struct StepContext {
    var message: String?
}

class Step1Coordinator: BaseRouterContextCoordinator<StepContext> {
    override func start() {
        let vc = Step1ViewController()
        vc.delegate = self
        vc.context = context
        
        perform(vc, from: self) { [weak self] in
            guard let self = self  else { return }
            self.parentCoordinator?.childDidFinish(self)
        }
    }
}

extension Step1Coordinator: Step1ViewControllerDelegate {
    func onPushToStep2() {
        let step2 = Step2Coordinator(router: router,
                                     presentationStyle: .push,
                                     context: context)
        step2.parentCoordinator = self
        children.append(step2)
        step2.start()
    }
    
    func onPresentToStep2() {
        let step2 = Step2Coordinator(router: router, presentationStyle: .present(.formSheet), context: context)
        step2.parentCoordinator = self
        children.append(step2)
        step2.start()
    }
}
