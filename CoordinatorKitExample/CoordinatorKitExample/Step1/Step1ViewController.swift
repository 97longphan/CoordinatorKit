import UIKit
import CoordinatorKit

protocol Step1ViewControllerDelegate: AnyObject {
    func onPushToStep2()
    func onPresentToStep2()
}

class Step1ViewController: BaseViewControllerCoordinator {
    weak var delegate: Step1ViewControllerDelegate?
    var context: StepContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Step1ViewController"
        print("📱 [VC] \(type(of: self)) loaded with context message \(String(describing: context?.message))")
    }
    
    @IBAction func pushStep2Action(_ sender: Any) {
        delegate?.onPushToStep2()
    }
    
    @IBAction func presentStep2Action(_ sender: Any) {
        delegate?.onPresentToStep2()
    }
}
