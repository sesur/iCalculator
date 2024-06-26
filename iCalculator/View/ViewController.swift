import UIKit
import Combine

class ViewController: UIViewController {
    
    @IBOutlet private weak var display: UILabel!
    
    private var viewModel: CalculatorViewModel!
    private var cancellables = Set<AnyCancellable>()
    
    init?(coder: NSCoder, viewModel: CalculatorViewModel) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        displayResult()
    }
    
    private func displayResult() {
        viewModel.$displayText
            .receive(on: RunLoop.main)
            .sink { [weak self] displayText in
                self?.display.text = displayText
            }
            .store(in: &cancellables)
    }
    
    @IBAction private func touchDigit(_ sender: UIButton) {
        guard let digit = sender.currentTitle else { return }
        viewModel.inputDigit(digit)
    }
    
    @IBAction private func performOperation(_ sender: UIButton) {
        guard let operation = sender.currentTitle else { return }
        viewModel.performOperation(operation)
    }
    
    @IBAction func cleanDisplayLabel(_ sender: Any) {
        viewModel.clear()
    }
}
