import UIKit
import CoordinatorKit



class Step1ViewController: BaseViewControllerCoordinator {
    private let viewModel: Step1ViewModel
    
    init(viewModel: Step1ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Step1ViewController"
    }
    
    @IBAction func pushStep2Action(_ sender: Any) {
        viewModel.delegate?.onPushToStep2()
    }
    
    @IBAction func pushToContext(_ sender: Any) {
        viewModel.delegate?.pushToContext()
    }
    
    @IBAction func presentStep2Action(_ sender: Any) {
        viewModel.delegate?.onPresentToStep2()
    }
}
