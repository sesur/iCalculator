import Foundation

struct CalculatorBrain {
    private var accumulator: Double?
    private var descriptionAccumulator: String?
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    var result: Double? {
        return accumulator
    }
    
    var resultIsPending: Bool {
        return pendingBinaryOperation != nil
    }
    
    private enum Operations {
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double, Double) -> Double)
        case equal
    }
    
    private var operations: [String: Operations] = [
        "π": .constant(.pi),
        "e": .constant(M_E),
        "±": .unaryOperation({ -$0 }),
        "√": .unaryOperation(sqrt),
        "cos": .unaryOperation(cos),
        "sin": .unaryOperation(sin),
        "×": .binaryOperation({ $0 * $1 }),
        "÷": .binaryOperation({ $0 / $1 }),
        "+": .binaryOperation({ $0 + $1 }),
        "−": .binaryOperation({ $0 - $1 }),
        "=": .equal
    ]
    
    mutating func setOperand(_ operand: Double) {
        accumulator = operand
        if let value = accumulator {
            descriptionAccumulator = formatter.string(from: NSNumber(value: value)) ?? ""
        }
    }
    
    mutating func performOperation(_ symbol: String) {
        if let operationType = operations[symbol] {
            switch operationType {
            case .constant(let value):
                accumulator = value
            case .unaryOperation(let function):
                if let accumulator = accumulator {
                    self.accumulator = function(accumulator)
                }
            case .binaryOperation(let function):
                if let accumulator = accumulator {
                    pendingBinaryOperation = PendingBinaryOperation(binaryFunction: function, firstOperand: accumulator)
                    self.accumulator = nil
                }
            case .equal:
                performPendingBinaryOperation()
            }
        }
    }
    
    private mutating func performPendingBinaryOperation() {
        if let pending = pendingBinaryOperation, let accumulator = accumulator {
            self.accumulator = pending.perform(with: accumulator)
            pendingBinaryOperation = nil
        }
    }
    
    private struct PendingBinaryOperation {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
        
        func perform(with secondOperand: Double) -> Double {
            return binaryFunction(firstOperand, secondOperand)
        }
    }
    
    mutating func clear() {
        accumulator = 0.0
        pendingBinaryOperation = nil
    }
}

let formatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.maximumFractionDigits = 6
    formatter.notANumberSymbol = "Error"
    formatter.groupingSeparator = " "
    formatter.locale = Locale.current
    return formatter
}()
