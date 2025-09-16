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
    private var viewModel: Step1ViewModel!
    
    override func start() {
        let viewModel = Step1ViewModel()
        viewModel.context = context
        viewModel.delegate = self
        self.viewModel = viewModel
        let vc = Step1ViewController(viewModel: viewModel)
        
        
        perform(vc, from: self) { [weak self] in
            guard let self = self  else { return }
            self.parentCoordinator?.childDidFinish(self)
        }
    }
}

extension Step1Coordinator: Step1ViewModelDelegate {
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
    
    func pushToContext() {
        let contextStep = StepContextCoordinator(router: router, presentationStyle: .push, context: SpecialContext(id: 1, mgs: ""))
        contextStep.parentCoordinator = self
        children.append(contextStep)
        contextStep.start()
    }
}

extension Step1Coordinator: FinishStepContextDelegate {
    func didFinishFlow(contextChanged: SpecialContext) {
        router.popToCoordinator(coordinator: self, isAnimated: true, completion: { [weak self] in
            print("context changed: \(contextChanged)")
            self?.viewModel.printStepContextAfter()
        })
    }
}

