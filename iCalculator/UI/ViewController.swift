
//  Copyright © 2020 Sergiu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private weak var display: UILabel!
    
    private var userIsInTheMiddleOfTyping = false
    
    //    private var brain = CalculatorBrain()
    
    var displayValue: Double {
        get {
            return Double(display.text!) ?? 0.0
        }
        set {
            display.text = formatter.string(from: NSNumber(floatLiteral: newValue))
        }
    }
    
    @IBAction private func touchDigit(_ sender: UIButton) {
        guard let digit = sender.currentTitle else { return }
        
        //MARK:- Solution: 1
        //        if userIsInTheMiddleOfTyping {
        //            let textCurrentlyInDisplay = display.text!
        //            if (digit != ".") || !(textCurrentlyInDisplay.contains(".")) {
        //                display.text = textCurrentlyInDisplay + digit
        //            }
        //        } else {
        //            display.text = digit
        //            userIsInTheMiddleOfTyping = true
        //        }
        //
        
        
        //MARK:- Solution: 2
        if userIsInTheMiddleOfTyping {
            guard let textCurrentlyInDisplay = display.text else { return }
            
            if (digit == "." && display.text!.range(of: ".") != nil) {
                return
            } else {
                display.text = textCurrentlyInDisplay + digit
            }
            
        } else {
            if digit == "0" {
                return
            } else if digit == "." {
                display.text = "0" + digit
            } else {
                display.text = digit
            }
            userIsInTheMiddleOfTyping = true
        }
    }
    
    
    
    private var brain = CalculatorBrain()
    
    @IBAction private func performOperaion(_ sender: UIButton) {
        
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }
        if let mathOperation = sender.currentTitle {
            brain.performOperation(mathOperation)
            userIsInTheMiddleOfTyping = false
        }
        if let result = brain.result {
            displayValue = result
        }
    }
    
    
    @IBAction func cleanDisplayLabel(_ sender: Any) {
        displayValue = 0
        userIsInTheMiddleOfTyping = false
        brain.clear()
    }
}


