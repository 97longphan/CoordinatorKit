import UIKit
import CoordinatorKit

protocol Step3ViewControllerDelegate: AnyObject {
    func step3DidFinish()
    func didShowAlertMoveTabbar()
}

class Step3ViewController: BaseViewControllerCoordinator {
    weak var delegate: Step3ViewControllerDelegate?
    var context: StepContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Step3ViewController"
        print("📱 [VC] \(type(of: self)) loaded with context message \(String(describing: context?.message))")
    }

    @IBAction func showAlertMoveTabbar(_ sender: Any) {
        delegate?.didShowAlertMoveTabbar()
    }
    
    @IBAction func finishFlowAction(_ sender: Any) {
        delegate?.step3DidFinish()
    }
}
