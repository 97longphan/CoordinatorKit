//
//  Step2Coordinator.swift
//  CoordinatorKitExample
//
//  Created by LONGPHAN on 30/6/25.
//

import Foundation
import CoordinatorKit

class Step2Coordinator: BaseRouterContextCoordinator<StepContext> {
    override func start() {
        let vc = Step2ViewController()
        vc.context = context
        vc.delegate = self
        
        perform(vc, from: self) { [weak self] in
            guard let self = self  else { return }
            self.parentCoordinator?.childDidFinish(self)
        }
    }
}

extension Step2Coordinator: Step2ViewControllerDelegate {
    func pushToStep3() {
        let step3 = Step3Coordinator(router: router,
                                     presentationStyle: .push,
                                     context: context)
        step3.parentCoordinator = self
        children.append(step3)
        step3.start()
    }
    
    func popToStep1() {
        router.pop(isAnimated: true)
    }
    
    func dismiss() {
        parentRouter.dismiss(coordinator: self, isAnimated: true) {
            
        }
    }
    
    
}

extension Step2Coordinator: FinishFlowPushDelegate {
    func didFinishFlow() {
        print("long dev parent Step1Coordinator\(self)")
        if presentationStyle.isUsingPresent {
            parentRouter.dismiss(coordinator: self, isAnimated: true) { [weak self] in
                self?.printCoordinatorTree()
            }
        } else {
            router.popToRootCoordinator(isAnimated: true)
        }
    }
}
