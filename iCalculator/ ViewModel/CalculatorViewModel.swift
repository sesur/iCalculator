//
//  CalculatorViewModel.swift
//  iCalculator
//
//  Created by Sergiu on 26.06.2024.
//  Copyright © 2024 Sergiu. All rights reserved.
//

import Foundation
import Combine

class CalculatorViewModel: ObservableObject {
    @Published private(set) var displayText: String = Constants.initialValue
    @Published private(set) var isTyping: Bool = false
    
    var brain: CalculatorBrain!
    
    func inputDigit(_ digit: String) {
        if isTyping {
            if digit == Constants.dot && displayText.contains(Constants.dot) { return }
            displayText += digit
        } else {
            displayText = digit == Constants.dot ? "0." : digit
            isTyping = true
        }
    }
    
    func performOperation(_ symbol: String) {
        if isTyping {
            brain.setOperand(Double(displayText) ?? 0)
            isTyping = false
        }
        brain.performOperation(symbol)
        if let result = brain.result {
            displayText = formatter.string(from: NSNumber(value: result)) ?? "Error"
        }
    }
    
    func clear() {
        displayText = Constants.initialValue
        isTyping = false
        brain.clear()
    }
}
