//
//  LoginViewController.swift
//  CoordinatorCore
//
//  Created by LONGPHAN on 30/6/25.
//

import UIKit
import CoordinatorKit

protocol LoginViewControllerDelegate: AnyObject {
    func didLoggedIn()
}
class LoginViewController: BaseViewControllerCoordinator {
    weak var delegate: LoginViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func loggedinAction(_ sender: Any) {
        delegate?.didLoggedIn()
    }
}
