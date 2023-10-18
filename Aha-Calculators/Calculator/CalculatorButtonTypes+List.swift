//
//  CalculatorButtonTypes+List.swift
//  Aha-Calculators
//
//  Created by Lin Cheng Lung on 2023/10/16.
//

import Foundation

extension CalculatorButton.Types {
    static let acButtonType: CalculatorButton.Types = .function("AC")
    static let signButtonType: CalculatorButton.Types = .function("+/-")
    static let percentButtonType: CalculatorButton.Types = .function("%")
    static let dividButtonType: CalculatorButton.Types = .operation("÷")
    static let multiplyButtonType: CalculatorButton.Types = .operation("x")
    static let minusButtonType: CalculatorButton.Types = .operation("-")
    static let plusButtonType: CalculatorButton.Types = .operation("+")
    static let equalButtonType: CalculatorButton.Types = .operation("=")
    static let oneButtonType: CalculatorButton.Types = .number("1")
    static let twoButtonType: CalculatorButton.Types = .number("2")
    static let threeButtonType: CalculatorButton.Types = .number("3")
    static let fourButtonType: CalculatorButton.Types = .number("4")
    static let fiveButtonType: CalculatorButton.Types = .number("5")
    static let sixButtonType: CalculatorButton.Types = .number("6")
    static let sevenButtonType: CalculatorButton.Types = .number("7")
    static let eightButtonType: CalculatorButton.Types = .number("8")
    static let nighButtonType: CalculatorButton.Types = .number("9")
    static let zeroButtonType: CalculatorButton.Types = .number("0")
    static let dotButtonType: CalculatorButton.Types = .number(".")
}
