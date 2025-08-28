//
//  Tabbar2ViewController.swift
//  CoordinatorCore
//
//  Created by LONGPHAN on 30/6/25.
//

import UIKit
protocol Tabbar2Delegate: AnyObject {
    func pushToStep1()
}
class Tabbar2ViewController: UIViewController {
    weak var delegate: Tabbar2Delegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func pushToStep1(_ sender: Any) {
        delegate?.pushToStep1()
    }
    
    deinit {
        print("❌ [Deinit] \(type(of: self)) deallocated (🧼 ViewController cleaned up)")
    }
}
