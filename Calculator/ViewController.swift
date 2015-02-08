//
//  ViewController.swift
//  Calculator
//
//  Created by Владимир on 06.02.15.
//  Copyright (c) 2015 Kasatkin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var display: UILabel!
    var isDisplayUsing = false
    var dotWasTypedIn = false
    var brain = CalculatorBrain()
    
    @IBAction func digit(sender: UIButton) {
        var digit: String
        if sender.currentTitle! == "π" {
            digit = "\(M_PI)"
        }
        else {
            digit = sender.currentTitle!
        }
        
        if isDisplayUsing {
            if digit == "." {
                if !dotWasTypedIn {
                    dotWasTypedIn = true
                    display.text = display.text! + digit
                }
                else {
                    println("wrong extra dot")
                }
            } else {
                display.text = display.text! + digit
            }
        }
        else {
            if digit != "." {
                isDisplayUsing = true
                display.text = digit
            }
            else {
                println("you can't start from dot")
            }
        }
        // hot fix
        //displayValue = convertTextToDouble(display.text!)
    }
    
    @IBAction func operation(sender: UIButton) {
        if isDisplayUsing {
            enter()
        }
        if let operation  = sender.currentTitle {
            if let result = brain.performOperation(operation) {
                displayValue = result
            } else {
                // tell that something wrong
                displayValue = 0.0
            }
        }
    }
    
    @IBAction func enter() {
        isDisplayUsing = false
        dotWasTypedIn = false
        if let result = brain.pushOperand(displayValue){
            displayValue = result
        } else {
            // tell that something wrong
            displayValue = 0.0
        }
    }
    
    @IBAction func clear() {
        display.text = "0"
        isDisplayUsing = false
        dotWasTypedIn = false
        brain.clearStack()
    }
    
    @IBAction func backspace() {
        let buf = display.text!
        if countElements(buf) > 1 {
            display.text = buf.substringToIndex(advance(buf.startIndex, countElements(buf)-1))
        }
        else if countElements(buf) == 1 {
            display.text = "0"
            isDisplayUsing = false
            dotWasTypedIn = false
        }
    }
    
    var displayValue: Double {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            display.text = "\(newValue)"
        }
    }
    
    func convertTextToDouble(text: String) -> Double {
        return NSNumberFormatter().numberFromString(text)!.doubleValue
    }
}

