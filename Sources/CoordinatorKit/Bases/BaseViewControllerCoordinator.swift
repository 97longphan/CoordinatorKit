//
//  BaseViewControllerCoordinator.swift
//  CoordinatorKitExample
//
//  Created by LONGPHAN on 2/7/25.
//

import UIKit

open class BaseViewControllerCoordinator: UIViewController {
    var onPop: (() -> Void)?
    
    public override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        guard parent == nil else { return }
        onPop?()
    }
    
    deinit {
        print("❌ [Deinit] \(type(of: self)) deallocated (🧼 ViewController cleaned up)")
    }
}
