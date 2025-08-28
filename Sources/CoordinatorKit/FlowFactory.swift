//
//  FlowFactory.swift
//  CoordinatorKitExample
//
//  Created by LONGPHAN on 1/7/25.
//

import Foundation
import UIKit

public protocol FlowRoute {}

@MainActor
public protocol FlowFactory {
    associatedtype Route: FlowRoute
    func make(_ route: Route, parent: Coordinator?) -> (UIViewController, Coordinator)
}
