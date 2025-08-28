//
//  Step3Coordinator.swift
//  CoordinatorCore
//
//  Created by LONGPHAN on 30/6/25.
//

import Foundation
import CoordinatorKit
protocol FinishFlowPushDelegate: AnyObject {
    func didFinishFlow()
}

class Step3Coordinator: BaseRouterContextCoordinator<StepContext> {
    override func start() {
        let vc = Step3ViewController()
        vc.context = context
        vc.delegate = self
        
        perform(vc, from: self) { [weak self] in
            guard let self = self  else { return }
            self.parentCoordinator?.childDidFinish(self)
        }
    }
}

extension Step3Coordinator: Step3ViewControllerDelegate {
    func didShowAlertMoveTabbar() {
        router.showAlert(title: "Title", message: "Đổi tabbar 1", actions: [
            ("Huỷ", .cancel, nil),
            ("Chuyển tab", .destructive, { [weak self] in
                guard let self = self else { return }
                if let eventHandler = self.findAncestor(ofType: TabbarDelegate.self) {
                    eventHandler.changeTabbarTo(.tab1)
                } else {
                    print("⚠️ [Coordinator] No ChangeTabbarIndexDelegate found in chain")
                }
            })
        ], from: self, animated: true)
    }
    
    func step3DidFinish() {
        if let eventHandler = self.findAncestor(ofType: FinishFlowPushDelegate.self) {
            eventHandler.didFinishFlow()
        } else {
            print("⚠️ [Coordinator] No FinishFlowCoordinatorDelegate found in chain")
        }
        
    }
}
