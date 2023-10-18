//
//  CalculatorViewModel.swift
//  Aha-Calculators
//
//  Created by Cheng Lung, Lin on 2023/10/13.
//

import Foundation

protocol CalculatorViewModelOutput: AnyObject {
    func didUpdateResult(_ result: String)
    func didUpdateFormula(_ formula: String)
}

final class CalculatorViewModel {
    static let defaultResult = "0"
    static let defaultFormula = " "

    weak var output: CalculatorViewModelOutput?

    private(set) var formulaStack = [CalculatorButton.Types]()
    private(set) var formula = CalculatorViewModel.defaultFormula {
        didSet {
            output?.didUpdateFormula(formula)
        }
    }
    private(set) var result = CalculatorViewModel.defaultResult {
        didSet {
            output?.didUpdateResult(result)
        }
    }
    private var isSignActive: Bool = false

    func didClickButton(_ button: CalculatorButton) {
        switch button.type {
        case .function:
            didClickFuntionButton(button.type)
        case .operation:
            didClickOperationButton(button.type)
        case .number:
            didClickNumberButton(button.type)
        default:
            break
        }

        updateFormula(with: formulaStack)
    }

    //MARK: - Button Handler

    private func didClickFuntionButton(_ buttonType: CalculatorButton.Types) {
        switch buttonType {
        case .acButtonType:
            didClickClearButton(buttonType)
        case .signButtonType:
            didClickSignButton(buttonType)
        case .percentButtonType:
            didClickPercentButton(buttonType)
        default:
            break
        }
    }

    private func didClickOperationButton(_ buttonType: CalculatorButton.Types) {
        switch buttonType {
        case .equalButtonType:
            didClickEqualButton(buttonType)
        case .operation:
            if .equalButtonType == formulaStack.last {
                formulaStack.removeLast()
            }
            if case .operation(_) = formulaStack.last {
                formulaStack.removeLast()
            }
            formulaStack.append(buttonType)
        default:
            break
        }
    }

    private func didClickNumberButton(_ buttonType: CalculatorButton.Types) {
        switch buttonType {
        case .dotButtonType:
            if .equalButtonType == formulaStack.last {
                formulaStack.removeLast()
            }
            if case let .number(lastNum) = formulaStack.last, !lastNum.contains(".") {
                formulaStack.removeLast()
                formulaStack.append(.number("\(lastNum)."))
            } else if case .operation = formulaStack.last {
                formulaStack.append(.number("0."))
            }

        case let .number(num):
            if .equalButtonType == formulaStack.last {
                reset()
            }
            if isSignActive {
                isSignActive = false
                formulaStack.append(.number("\(-(Int(num) ?? 0))"))
            } else if case let .number(lastNum) = formulaStack.last {
                formulaStack.removeLast()
                formulaStack.append(.number("\(lastNum)\(num)"))
            } else {
                formulaStack.append(.number(num))
            }
        default:
            break
        }
    }

    private func didClickClearButton(_ buttonType: CalculatorButton.Types) {
        reset()
    }

    private func didClickSignButton(_ buttonType: CalculatorButton.Types) {
        // Case 1: Change the sign of the current number
        // ex: "1", "+", "2", "+/-" => "1", "+", "-2"
        if case let .number(num) = formulaStack.last {
            formulaStack.removeLast()
            formulaStack.append(.number("\(-(Int(num) ?? 0))"))
            return
        }

        // Case 2: Change the coming number
        // ex: "1", "+", "+/-", "2" => "1", "+", "-2"
        // ex: "+/-", "1" => "-1"
        if formulaStack.isEmpty {
            isSignActive = true
        } else if .equalButtonType == formulaStack.last {
            let currentResult = result
            reset()
            formulaStack.append(.number(("\((-(Double(currentResult) ?? 0)).trimmedTrailingZero)")))
            updateFormula(with: formulaStack)
        } else if case .operation = formulaStack.last {
            isSignActive = true
        }
    }

    private func didClickPercentButton(_ buttonType: CalculatorButton.Types) {
        if formulaStack.isEmpty {
            return
        } else if .equalButtonType == formulaStack.last {
            let currentResult = result
            reset()
            formulaStack.append(.number(("\(((Double(currentResult) ?? 0) / 100).trimmedTrailingZero)")))
            updateFormula(with: formulaStack)
        } else if case let .number(num) = formulaStack.last {
            formulaStack.removeLast()
            formulaStack.append(.number("\((Double(num) ?? 0) / 100)"))
            return
        } else if formulaStack.count >= 2,
                  case .operation(_) = formulaStack.last,
                  case let .number(num) = formulaStack[formulaStack.count - 2] {
            let operation = formulaStack.last!
            formulaStack.removeLast()
            formulaStack.removeLast()
            formulaStack.append(.number("\((Double(num) ?? 0) / 100)"))
            formulaStack.append(operation)
        }
    }

    private func didClickEqualButton(_ buttonType: CalculatorButton.Types) {
        if .equalButtonType == formulaStack.last { return }
        formulaStack.append(.equalButtonType)
        result = computeCurrentResult(with: formulaStack)
    }

    private func reset() {
        formulaStack.removeAll()
        result = CalculatorViewModel.defaultResult
        formula = CalculatorViewModel.defaultFormula
        isSignActive = false
    }

    private func computeCurrentResult(with formula: [CalculatorButton.Types]) -> String {
        if let multiplyOpIndex = formula.firstIndex(of: .multiplyButtonType),
           multiplyOpIndex >= 1,
           formula.count > multiplyOpIndex + 1
        {
            var mutableFormula = formula
            let multiplyResult = (formula[multiplyOpIndex - 1].numDouble ?? 0)
                * (formula[multiplyOpIndex + 1].numDouble ?? 0)
            mutableFormula.removeSubrange((multiplyOpIndex - 1)...(multiplyOpIndex + 1))
            mutableFormula.insert(.number("\(multiplyResult)"), at: multiplyOpIndex - 1)
            return computeCurrentResult(with: mutableFormula)
        }

        if let dividOpIndex = formula.firstIndex(of: .dividButtonType),
           dividOpIndex >= 1,
           formula.count > dividOpIndex + 1
        {
            var mutableFormula = formula
            let dividResult = (formula[dividOpIndex - 1].numDouble ?? 0)
                / (formula[dividOpIndex + 1].numDouble ?? 1)
            mutableFormula.removeSubrange((dividOpIndex - 1)...(dividOpIndex + 1))
            mutableFormula.insert(.number("\(dividResult)"), at: dividOpIndex - 1)
            return computeCurrentResult(with: mutableFormula)
        }

        var result: Double?
        var lastOperater: CalculatorButton.Types?
        for element in formula {
            switch element {
            case .number:
                if result == nil {
                    result = element.numDouble
                } else if let lastOperater = lastOperater, let number = element.numDouble {
                    switch lastOperater {
                    case .plusButtonType:
                        result = (result ?? 0) + number
                    case .minusButtonType:
                        result = (result ?? 0) - number
                    case .multiplyButtonType:
                        result = (result ?? 0) * number
                    case .dividButtonType:
                        result = (result ?? 0) / number
                    default:
                        break
                    }
                }
            case .operation:
                lastOperater = element
            default:
                break
            }
        }

        return (result ?? 0).trimmedTrailingZero
    }

    private func updateFormula(with formulaStack: [CalculatorButton.Types]) {
        let currentFormula = getFormula(with: formulaStack)
        if !currentFormula.isEmpty, formula != currentFormula {
            formula = currentFormula
        }
    }

    private func getFormula(with formulaStack: [CalculatorButton.Types]) -> String {
        var formula = formulaStack.reduce(into: "") { partialResult, buttonType in
            partialResult = "\(partialResult) \(buttonType.label)"
        }

        if .equalButtonType == formulaStack.last {
            formula = "\(formula) \(result)"
        }

        return formula
    }
}

private extension CalculatorButton.Types {
    var numDouble: Double? {
        guard case let .number(num) = self else { return nil }
        return Double(num)
    }
}

private extension Double {
    var trimmedTrailingZero: String {
        String(format: "%g", self)
    }
}
