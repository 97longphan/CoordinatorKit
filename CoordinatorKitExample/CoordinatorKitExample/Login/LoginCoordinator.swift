//
//  LoginCoordinator.swift
//  CoordinatorCore
//
//  Created by LONGPHAN on 30/6/25.
//

import Foundation
import CoordinatorKit
protocol LoginCoordinatorDelegate: AnyObject {
    func didLoggedIn()
}

class LoginCoordinator: BaseRouterCoordinator {
    
    weak var delegate: LoginCoordinatorDelegate?
    
    override func start() {
        let vc = LoginViewController()
        vc.delegate = self
        
        perform(vc, from: self)
    }
}

extension LoginCoordinator: LoginViewControllerDelegate {
    func didLoggedIn() {
        delegate?.didLoggedIn()
    }
}


