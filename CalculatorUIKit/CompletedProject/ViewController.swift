//
//  ViewController.swift
//  CalculatorUIKit
//
//  Created by R K on 11/24/23.
//

import UIKit

final class ViewController: UIViewController {
    
    @IBOutlet private weak var display: UILabel!
    private var displayNumber: Double? {
        return Double(display.text!)
    }
    @IBOutlet private var roundButtons: [UIButton]!
    @IBOutlet private weak var addButton: OperationButton!
    @IBOutlet private weak var subtractButton: OperationButton!
    @IBOutlet private weak var multiplyButton: OperationButton!
    @IBOutlet private weak var divideButton: OperationButton!
    private lazy var operationButtons: [OperationButton] = [
        addButton, subtractButton, multiplyButton, divideButton
    ]
    private var operationButtonIsSelected: Bool {
        for button in operationButtons {
            if button.isSelection {
                return true
            }
        }
        return false
    }
    
    enum Operation {
        case add, subtract, multiply, divide, none
    }
    private var operation: Operation = .none
    private var equalsButtonTapped = false
    private var previousNumber: Double?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        roundButtonCorners()
    }
    
    private func roundButtonCorners() {
        roundButtons.forEach { button in
            button.layer.cornerRadius = button.frame.height / 2
        }
        operationButtons.forEach { button in
            button.layer.cornerRadius = button.frame.height / 2
        }
    }
    
    @IBAction private func didTapNumber(_ sender: UIButton) {
        let num = sender.tag
        if !operationButtonIsSelected {
            if displayNumber == 0 {
                display.text = "\(num)"
            } else {
                display.text! += "\(num)"
            }
        } else {
            display.text = "\(num)"
            deselectOperationButtons()
        }
    }
    
    @IBAction private func didTapDecimal() {
        let text = display.text!
        if text.last == "." {
            display.text!.removeLast()
        } else if !text.contains(".") {
            display.text! += "."
        }
    }
    
    @IBAction private func operationTapped(_ sender: OperationButton) {
        if let _ = previousNumber, !equalsButtonTapped, !operationButtonIsSelected {
            performOperation()
            previousNumber = nil
        }
        switch sender.currentTitle {
        case "+":
            operation = .add
        case "-":
            operation = .subtract
        case "X":
            operation = .multiply
        case "÷":
            operation = .divide
        default:
            return
        }
        highlightButton(sender)
        equalsButtonTapped = false
        if let displayNumber {
            previousNumber = displayNumber
        }
    }
    
    private func deselectOperationButtons() {
        operationButtons.forEach { button in
            button.isSelection = false
            button.backgroundColor = .systemOrange
            button.setTitleColor(.white, for: .normal)
        }
    }
    
    private func highlightButton(_ button: OperationButton) {
        deselectOperationButtons()
        button.backgroundColor = .white
        button.setTitleColor(.systemOrange, for: .normal)
        button.isSelection = true
    }
    
    @IBAction private func didTapEquals() {
        guard operation != .none else { return }
        performOperation()
        equalsButtonTapped = true
    }
    
    private func performOperation() {
        guard let previousNumber, let displayNumber else { return }
        var result: Double = 0
        switch operation {
        case .add:
            result = previousNumber + displayNumber
        case .subtract:
            result = previousNumber - displayNumber
        case .multiply:
            result = previousNumber * displayNumber
        case .divide:
            result = previousNumber / displayNumber
        case .none:
            return
        }
        if result.truncatingRemainder(dividingBy: 1) == 0 {
            display.text = "\(Int(result))"
        } else {
            display.text = "\(result)"
        }
    }
    
    @IBAction private func togglePositiveNegative() {
        guard var n = Double(display.text!) else { return }
        n *= -1
        display.text = "\(n)"
    }
    
    @IBAction private func didTapPercent() {
        guard var n = Double(display.text!) else { return }
        n /= 100
        display.text = "\(n)"
    }
    
    @IBAction private func allClear() {
        previousNumber = nil
        display.text = "0"
        operation = .none
        deselectOperationButtons()
    }
}

