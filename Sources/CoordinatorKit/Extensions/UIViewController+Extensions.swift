//
//  UIViewController+Extensions.swift
//  CoordinatorKitExample
//
//  Created by LONGPHAN on 2/7/25.
//

import UIKit

extension UIViewController: Drawable {
    public var viewController: UIViewController? { self }
    public var canDelegate: Bool { true }
}
