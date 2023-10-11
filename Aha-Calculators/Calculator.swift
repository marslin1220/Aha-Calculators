//
//  Calculator.swift
//  Aha-Calculators
//
//  Created by Cheng Lung, Lin on 2023/10/10.
//

import Foundation
import SnapKit
import UIKit

final class Calculator: UIView {
    private enum Constant {
        static let buttonGapWidth: CGFloat = 7
        static let ratio: CGFloat = 1.15
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let height = frame.height
        let ratio = height / 609
        resultLabel.font = .systemFont(ofSize: 110 * ratio)
        formulaLabel.font = .systemFont(ofSize: 40 * ratio)
        buttonStack.spacing = Constant.buttonGapWidth * ratio
        buttonStack.arrangedSubviews
            .compactMap { $0 as? UIStackView }
            .forEach { $0.spacing = Constant.buttonGapWidth * Constant.ratio * ratio }
    }

    // MARK: - Private Methods

    private func setupUI() {
        resultLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        resultLabel
            .addToParentView(self)
            .snp.makeConstraints {
                $0.trailing.top.equalToSuperview()
            }
        resultLabel.text = "1234"

        formulaLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        formulaLabel
            .addToParentView(self)
            .snp.makeConstraints {
                $0.top.equalTo(resultLabel.snp.bottom).offset(-10)
                $0.leading.equalToSuperview()
            }
        formulaLabel.text = "1x2/3"

        buttonStack
            .addToParentView(self)
            .snp.makeConstraints {
                $0.top.equalTo(formulaLabel.snp.bottom).offset(10)
                $0.leading.trailing.bottom.equalToSuperview()
            }

        buttons.forEach { button in
            guard button != zeroButton else { return }
            button.snp.makeConstraints {
                $0.width.equalTo(button.snp.height).multipliedBy(Constant.ratio)
            }
        }
    }

    // MARK: - UI Components
    private lazy var resultLabel: UILabel = {
        $0.font = .systemFont(ofSize: 110)
        $0.textColor = .white
        return $0
    }(UILabel())

    private lazy var formulaLabel: UILabel = {
        $0.font = .systemFont(ofSize: 40)
        $0.textColor = .white
        return $0
    }(UILabel())
    private let acButton = CalculatorButton(type: .function("AC"))
    private let signButton = CalculatorButton(type: .function("+/-"))
    private let percentButton = CalculatorButton(type: .function("%"))
    private let dividButton = CalculatorButton(type: .operation("÷"))
    private let multiplyButton = CalculatorButton(type: .operation("x"))
    private let minusButton = CalculatorButton(type: .operation("-"))
    private let plusButton = CalculatorButton(type: .operation("+"))
    private let equalButton = CalculatorButton(type: .operation("="))
    private let oneButton = CalculatorButton(type: .number("1"))
    private let twoButton = CalculatorButton(type: .number("2"))
    private let threeButton = CalculatorButton(type: .number("3"))
    private let fourButton = CalculatorButton(type: .number("4"))
    private let fiveButton = CalculatorButton(type: .number("5"))
    private let sixButton = CalculatorButton(type: .number("6"))
    private let sevenButton = CalculatorButton(type: .number("7"))
    private let eightButton = CalculatorButton(type: .number("8"))
    private let nighButton = CalculatorButton(type: .number("9"))
    private let zeroButton = CalculatorButton(type: .number("0"))
    private let dotButton = CalculatorButton(type: .number("."))
    private lazy var buttons = [
        acButton,
        signButton,
        percentButton,
        dividButton,
        multiplyButton,
        minusButton,
        plusButton,
        equalButton,
        oneButton,
        twoButton,
        threeButton,
        fourButton,
        fiveButton,
        sixButton,
        sevenButton,
        eightButton,
        nighButton,
        zeroButton,
        dotButton
    ]
    private lazy var buttonStack: UIStackView = {
        $0
            .setAxis(.vertical)
            .addArrangedSubviews(
                [
                    UIStackView(arrangedSubviews: [acButton, signButton, percentButton, dividButton]),
                    UIStackView(arrangedSubviews: [sevenButton, eightButton, nighButton, multiplyButton]),
                    UIStackView(arrangedSubviews: [fourButton, fiveButton, sixButton, minusButton]),
                    UIStackView(arrangedSubviews: [oneButton, twoButton, threeButton, plusButton]),
                    UIStackView(arrangedSubviews: [zeroButton, dotButton, equalButton])
                ]
            )
            .setDistribution(.fillEqually)
    }(UIStackView())
}

// MARK: - Private Extensions

private extension UIStackView {
    func setAxis(_ axis: NSLayoutConstraint.Axis) -> UIStackView {
        self.axis = axis
        return self
    }

    func setSpacing(_ spacing: CGFloat) -> UIStackView {
        self.spacing = spacing
        return self
    }

    func addArrangedSubviews(_ subviews: [UIView]) -> UIStackView {
        subviews.forEach { addArrangedSubview($0) }
        return self
    }

    func setDistribution(_ distribution: UIStackView.Distribution) -> UIStackView {
        self.distribution = distribution
        return self
    }
}

private extension UIView {
    func addToParentView(_ parentView: UIView) -> UIView {
        parentView.addSubview(self)
        return self
    }
}

#Preview {
    Calculator()
}
