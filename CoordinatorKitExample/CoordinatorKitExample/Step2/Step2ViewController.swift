import UIKit
import CoordinatorKit

protocol Step2ViewControllerDelegate: AnyObject {
    func pushToStep3()
    func popToStep1()
    func dismiss()
}

class Step2ViewController: BaseViewControllerCoordinator {
    weak var delegate: Step2ViewControllerDelegate?
    var context: StepContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Step2ViewController"
        print("📱 [VC] \(type(of: self)) loaded with context message \(String(describing: context?.message))")
    }
    
    @IBAction func popToStep1Action(_ sender: Any) {
        delegate?.popToStep1()
    }
    @IBAction func dismissACTION(_ sender: Any) {
        delegate?.dismiss()
    }
    
    @IBAction func pushToStep3Action(_ sender: Any) {
        delegate?.pushToStep3()
    }
}
