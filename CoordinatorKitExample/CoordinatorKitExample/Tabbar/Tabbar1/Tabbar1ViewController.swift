//
//  Tabbar1ViewController.swift
//  CoordinatorCore
//
//  Created by LONGPHAN on 30/6/25.
//

import UIKit
protocol Tabbar1ViewControllerDelegate: AnyObject {
    func didPresentStep2()
    func didLogout()
}

class Tabbar1ViewController: UIViewController {
    weak var delegate: Tabbar1ViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func logoutAction(_ sender: Any) {
        delegate?.didLogout()
    }
    
    @IBAction func actionPresentStep2(_ sender: Any) {
        delegate?.didPresentStep2()
    }
    
    deinit {
        print("❌ [Deinit] \(type(of: self)) deallocated (🧼 ViewController cleaned up)")
    }
}
