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
    private let viewModel = CalculatorViewModel()

    private enum Constant {
        static let buttonGapWidth: CGFloat = 5
        static let ratio: CGFloat = 1.15
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupAction()
        viewModel.output = self
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public interface

    var currentResult: String {
        viewModel.resultString
    }

    func reset() {
        viewModel.reset()
    }

    func setResult(_ result: String) {
        viewModel.reset()
        viewModel.setResult(result)
    }

    // MARK: - Private Methods

    private func setupUI() {
        resultLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        resultLabel.setContentHuggingPriority(.required, for: .vertical)
        resultLabel
            .addToParentView(self)
            .snp.makeConstraints {
                $0.leading.trailing.top.equalToSuperview()
            }
        resultLabel.text = CalculatorViewModel.defaultResult

        formulaLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        formulaLabel.setContentHuggingPriority(.required, for: .vertical)
        formulaLabel
            .addToParentView(self)
            .snp.makeConstraints {
                $0.top.equalTo(resultLabel.snp.bottom)
                $0.leading.trailing.equalToSuperview()
            }
        formulaLabel.text = " "

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

    private func setupAction() {
        buttons.forEach { [weak self] button in
            guard let self else { return }
            button.addTarget(self, action: #selector(didClickButton(_:)), for: .touchUpInside)
        }
    }

    // MARK: - Selectors

    @objc private func didClickButton(_ button: CalculatorButton) {
        viewModel.didClickButton(button)
    }

    // MARK: - UI Components
    private lazy var resultLabel: UILabel = {
        $0.font = .systemFont(ofSize: 65)
        $0.textColor = .white
        $0.adjustsFontSizeToFitWidth = true
        $0.textAlignment = .right
        return $0
    }(UILabel())

    private lazy var formulaLabel: UILabel = {
        $0.font = .systemFont(ofSize: 25)
        $0.textColor = .white
        $0.adjustsFontSizeToFitWidth = true
        $0.textAlignment = .left
        return $0
    }(UILabel())
    private let acButton = CalculatorButton(type: .acButtonType)
    private let signButton = CalculatorButton(type: .signButtonType)
    private let percentButton = CalculatorButton(type: .percentButtonType)
    let dividButton = CalculatorButton(type: .dividButtonType)
    private let multiplyButton = CalculatorButton(type: .multiplyButtonType)
    private let minusButton = CalculatorButton(type: .minusButtonType)
    private let plusButton = CalculatorButton(type: .plusButtonType)
    private let equalButton = CalculatorButton(type: .equalButtonType)
    private let oneButton = CalculatorButton(type: .oneButtonType)
    private let twoButton = CalculatorButton(type: .twoButtonType)
    private let threeButton = CalculatorButton(type: .threeButtonType)
    private let fourButton = CalculatorButton(type: .fourButtonType)
    private let fiveButton = CalculatorButton(type: .fiveButtonType)
    private let sixButton = CalculatorButton(type: .sixButtonType)
    private let sevenButton = CalculatorButton(type: .sevenButtonType)
    private let eightButton = CalculatorButton(type: .eightButtonType)
    private let nineButton = CalculatorButton(type: .nineButtonType)
    private let zeroButton = CalculatorButton(type: .zeroButtonType)
    private let dotButton = CalculatorButton(type: .dotButtonType)
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
        nineButton,
        zeroButton,
        dotButton
    ]
    private lazy var buttonStack: UIStackView = {
        $0
            .setAxis(.vertical)
            .setSpacing(Constant.buttonGapWidth)
            .addArrangedSubviews(
                [
                    UIStackView(arrangedSubviews: [acButton, signButton, percentButton, dividButton])
                        .setSpacing(Constant.buttonGapWidth * Constant.ratio),
                    UIStackView(arrangedSubviews: [sevenButton, eightButton, nineButton, multiplyButton])
                        .setSpacing(Constant.buttonGapWidth * Constant.ratio),
                    UIStackView(arrangedSubviews: [fourButton, fiveButton, sixButton, minusButton])
                        .setSpacing(Constant.buttonGapWidth * Constant.ratio),
                    UIStackView(arrangedSubviews: [oneButton, twoButton, threeButton, plusButton])
                        .setSpacing(Constant.buttonGapWidth * Constant.ratio),
                    UIStackView(arrangedSubviews: [zeroButton, dotButton, equalButton])
                        .setSpacing(Constant.buttonGapWidth * Constant.ratio)
                ]
            )
            .setDistribution(.fillEqually)
    }(UIStackView())
}

// MARK: - Output Extension

extension Calculator: CalculatorViewModelOutput {
    func didUpdateResult(_ result: String) {
        resultLabel.text = result
    }

    func didUpdateFormula(_ formula: String) {
        formulaLabel.text = formula
    }
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
