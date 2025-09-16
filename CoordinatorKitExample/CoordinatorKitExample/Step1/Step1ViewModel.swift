//
//  Step1ViewModel.swift
//  CoordinatorKitExample
//
//  Created by LONGPHAN on 15/9/25.
//

import Foundation
protocol Step1ViewModelDelegate: AnyObject {
    func onPushToStep2()
    func onPresentToStep2()
    func pushToContext()
}

final class Step1ViewModel {
    var context: StepContext?
    weak var delegate: Step1ViewModelDelegate?
    
    func printStepContextAfter() {
        print("printStepContextAfter")
    }
    
    deinit {
        print("❌ [Deinit] Step1ViewModel deallocated")
    }
}
