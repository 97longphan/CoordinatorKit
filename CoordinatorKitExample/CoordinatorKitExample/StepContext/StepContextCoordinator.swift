//
//  StepContextCoordinator.swift
//  CoordinatorKitExample
//
//  Created by LONGPHAN on 15/9/25.
//

import Foundation
import CoordinatorKit
protocol FinishStepContextDelegate: AnyObject {
    func didFinishFlow(contextChanged: SpecialContext)
}

struct SpecialContext {
    var id: Int
    var mgs: String
}

class StepContextCoordinator: BaseRouterContextCoordinator<SpecialContext> {
    override func start() {
        let viewModel = StepContextViewModel()
        let vc = StepContextViewController(viewModel: viewModel)
        vc.delegate = self
        
        perform(vc, from: self) { [weak self] in
            guard let self = self  else { return }
            self.parentCoordinator?.childDidFinish(self)
        }
    }
}

extension StepContextCoordinator: StepContextViewControllerDelegate {
    func onFinish() {
        if let eventHandler = self.findAncestor(ofType: FinishStepContextDelegate.self) {
            let context = SpecialContext(id: context.id + 1, mgs: "\(context.mgs)afterchange")
            eventHandler.didFinishFlow(contextChanged: context)
        }
    }
}
