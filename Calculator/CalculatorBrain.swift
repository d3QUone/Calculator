//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Владимир on 06.02.15.
//  Copyright (c) 2015 Kasatkin. All rights reserved.
//

import Foundation


class CalculatorBrain {
    
    private enum Op: Printable {
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        
        var description: String {
            get {
                switch self {
                case .Operand(let operand): return "\(operand)"
                case .UnaryOperation(let symbol, _): return symbol
                case .BinaryOperation(let symbol, _): return symbol
                }
            }
        }
    }
    
    private var opStack = [Op]()
    
    private var knownOps = [String: Op]()
    
    init(){
        func learnOp(op: Op){
            knownOps[op.description] = op
        }
        learnOp(Op.BinaryOperation("×", *))
        learnOp(Op.BinaryOperation("÷") { $1 / $0 })
        learnOp(Op.BinaryOperation("+", +))
        learnOp(Op.BinaryOperation("−") { $1 - $0 })
        learnOp(Op.BinaryOperation("^", pow))
        learnOp(Op.UnaryOperation("√", sqrt))
        learnOp(Op.UnaryOperation("sin", sin))
        learnOp(Op.UnaryOperation("cos", cos))
        learnOp(Op.UnaryOperation("tan", tan))
        learnOp(Op.UnaryOperation("+/−") { -1*$0 })
    }
    
    private func evaulate(ops: [Op]) -> (result: Double?, remainingOps: [Op]) {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
                case .Operand(let operand): return (operand, remainingOps)
                case .UnaryOperation(_, let operation):
                    let operandEvaulate = evaulate(remainingOps)
                    if let operand = operandEvaulate.result {
                        return (operation(operand), operandEvaulate.remainingOps)
                    }
                case .BinaryOperation(_, let operation):
                    let op1Eval = evaulate(remainingOps)
                    if let op1result = op1Eval.result {
                        let op2Eval = evaulate(op1Eval.remainingOps)
                        if let op2result = op2Eval.result {
                            return (operation(op1result, op2result), op2Eval.remainingOps)
                        }
                }
            }
        }
        return (nil, ops)
    }
    
    func evaulate() -> Double? {
        let (result, remainder) = evaulate(opStack)
        return result
    }
    
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaulate()
    }
    
    func performOperation(symbol: String) -> Double? {
        if let operation = knownOps[symbol]{
            opStack.append(operation)
        }
        return evaulate()
    }
    
    func clearStack() {
        opStack.removeAll(keepCapacity: false)
        println("opStack clear")
    }
}