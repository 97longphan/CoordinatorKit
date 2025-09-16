//
//  StepContextViewController.swift
//  CoordinatorKitExample
//
//  Created by LONGPHAN on 15/9/25.
//

import CoordinatorKit

protocol StepContextViewControllerDelegate: AnyObject {
    func onFinish()
}

class StepContextViewController: BaseViewControllerCoordinator {
    weak var delegate: StepContextViewControllerDelegate?
    private let viewModel: StepContextViewModel
    
    init(viewModel: StepContextViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func finishAction(_ sender: Any) {
        delegate?.onFinish()
    }
    
}
