
//  Copyright © 2020 Sergiu. All rights reserved.
//

import Foundation


let formatter: NumberFormatter = {
       let formatter = NumberFormatter()
       formatter.numberStyle = .decimal
       formatter.maximumFractionDigits = 6
       formatter.notANumberSymbol = "Error"
       formatter.groupingSeparator = " "
       formatter.locale = Locale.current
       return formatter
   }()


struct CalculatorBrain {
    private var accumulator: Double?
    private var descriptionAccumulator: String?
    
    
    //private var internalProgram = [PropertyList]()
    
    
//    var description: String? {
//        get {
//            if pendingBinaryOperation == nil {
//                return descriptionAccumulator
//            } else {
//               return pendingBinaryOperation.de
//            }
//        }
//    }
    
    var result: Double? {
        get {
            return accumulator
        }
    }
    
    var resultIsPending: Bool {
        get {
            return pendingBinaryOperation != nil
        }
    }
    
    mutating func setOperand (_ operand: Double) {
        accumulator = operand
        if let value = accumulator {
            descriptionAccumulator = formatter.string(from: NSNumber(floatLiteral: value)) ?? ""
        }
        //internalProgram.append(operand as PropertyList)
    }
    
 
    mutating func performOperation(_ symbol: String) {
        //        //internalProgram.append(symbol as AnyObject)
        if let operationType = operations[symbol] {
            switch operationType {
            case .constant(let value):
                accumulator = value
            case.unaryOperation(let function):
                if accumulator != nil {
                    accumulator = function(accumulator!)
                }
            case .binaryOperation(let function):
                if accumulator != nil {
                    pendingBinaryOperation = PendingBinaryOperation(binaryFunction: function, firstOperand: accumulator!)
                    accumulator = nil
                }
            case .equal: performPendingBinaryOperation()
            }
        }
    }
    
    private mutating func performPendingBinaryOperation() {
        if pendingBinaryOperation != nil && accumulator != nil {
            accumulator = pendingBinaryOperation!.perform(with: accumulator!)
            pendingBinaryOperation = nil
        }
        
    }
    
    private var operations: [String: Operations] = [
         "ƞ" : Operations.constant(.pi),
         "e" : Operations.constant(M_E),
         "±" : Operations.unaryOperation({-$0}),
         "√" : Operations.unaryOperation(sqrt),
         "cos" : Operations.unaryOperation(cos),
         "sin" : Operations.unaryOperation(sin),
         "×" : Operations.binaryOperation({ $0 * $1 }),
         "÷" : Operations.binaryOperation({ $0 / $1 }),
         "+" : Operations.binaryOperation({ $0 + $1 }),
         "−" : Operations.binaryOperation({ $0 - $1 }),
         "=" : Operations.equal
     ]
     
    private enum Operations {
//        case nullaryOperation:(()-> Double, String)
        case constant(Double)
        case unaryOperation((Double)-> Double)
        case binaryOperation((Double, Double) -> Double)
        case equal
    }
    
    
    
    
    
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    private struct PendingBinaryOperation {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
//        var descriptionFunction: (String, String)-> String
//        var descriptionOperand: String

        
        func perform(with secondOperand: Double) -> Double {
            return binaryFunction(firstOperand, secondOperand)
        }
        
//        func performDescription(with secondOperand: String) -> String {
//            return descriptionFunction(descriptionOperand, secondOperand)
//        }
    }
    
    mutating func clear() {
        accumulator = 0.0
        pendingBinaryOperation = nil
    }
    
    
   
    
    //    func clear() {
    //        accumulator = 0.0
    //        pending = nil
    //        //internalProgram.removeAll()
    //    }
    
    //    typealias PropertyList = AnyObject
    //    var program: PropertyList {
    //        get {
    //            return internalProgram as CalculatorBrain.PropertyList
    //        }
    //        set {
    //            clear()
    //            if let arrayOfOp = newValue as? [AnyObject] {
    //                for op in arrayOfOp {
    //                    if op is Double {
    //                        setOperand(op as! Double)
    //                    }
    //                    else if let operation = op as? String {
    //                        performOperation(operation)
    //                    }
    //                }
    //            }
    //        }
    //    }
    
}
