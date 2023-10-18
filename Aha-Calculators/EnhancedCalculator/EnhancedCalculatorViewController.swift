//
//  EnhancedCalculatorViewController.swift
//  Aha-Calculators
//
//  Created by Cheng Lung, Lin on 2023/10/6.
//

import UIKit
import SnapKit

final class EnhancedCalculatorViewController: UIViewController {
    private let viewModel = EnhancedCalculatorViewModel()

    private var buttonHeight: CGFloat? {
        let button = leftCalculator.dividButton
        return button.frame.height == 0 ? nil : button.frame.height
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        observeRotation()
        setupUI()
        setupAction()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setLayout()
    }

    // MARK: - Private Methods

    private func observeRotation() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(rotated),
            name: UIDevice.orientationDidChangeNotification,
            object: nil
        )
    }

    @objc private func rotated() {
        setLayout()
    }

    private func setupUI() {
        view.backgroundColor = .black
        [
            leftCalculator,
            rightCalculator,
            rightArrowButton,
            leftArrowButton,
            deleteButton
        ].forEach { view.addSubview($0) }

        setLayout()
    }

    private func setLayout() {
        guard let orientation = UIApplication.shared.connectedScenes
            .first(where: { $0 is UIWindowScene })
            .flatMap({ $0 as? UIWindowScene })?
            .interfaceOrientation else { return }

        switch orientation {
        case .portrait, .portraitUpsideDown:
            setSingleCalculatorLayout()
        default:
            setTwoCalculatorLayout()
        }
    }

    private func setSingleCalculatorLayout() {
        [
            rightCalculator,
            leftArrowButton,
            rightArrowButton,
            deleteButton
        ].forEach {
            $0.isHidden = true
            $0.snp.removeConstraints()
        }

        leftCalculator.snp.remakeConstraints {
            $0.height.equalTo(view.snp.width)
            $0.center.equalToSuperview()
        }
    }

    private func setTwoCalculatorLayout() {
        [
            rightCalculator,
            leftArrowButton,
            rightArrowButton,
            deleteButton
        ].forEach { $0.isHidden = false }
        leftCalculator.snp.remakeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        rightCalculator.snp.remakeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }

        guard let buttonHeight = buttonHeight else { return }

        leftArrowButton.snp.remakeConstraints {
            $0.leading.equalTo(leftCalculator.dividButton.snp.trailing).offset(10)
            $0.top.equalTo(leftCalculator.dividButton.snp.top)
            $0.trailing.equalTo(rightCalculator.snp.leading).offset(-10)
            $0.width.height.equalTo(buttonHeight)
            $0.centerX.equalToSuperview()
        }

        rightArrowButton.snp.remakeConstraints {
            $0.leading.equalTo(leftCalculator.dividButton.snp.trailing).offset(10)
            $0.top.equalTo(leftArrowButton.snp.bottom).offset(20)
            $0.trailing.equalTo(rightCalculator.snp.leading).offset(-10)
            $0.width.height.equalTo(buttonHeight)
            $0.centerX.equalToSuperview()
        }

        deleteButton.snp.remakeConstraints {
            $0.leading.equalTo(leftCalculator.dividButton.snp.trailing).offset(10)
            $0.bottom.equalTo(leftCalculator.snp.bottom)
            $0.trailing.equalTo(rightCalculator.snp.leading).offset(-10)
            $0.width.height.equalTo(buttonHeight)
            $0.centerX.equalToSuperview()
        }
    }

    private func setupAction() {
        rightArrowButton.addTarget(self, action: #selector(didClickRightArrowButton), for: .touchUpInside)
        leftArrowButton.addTarget(self, action: #selector(didClickLeftArrowButton), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(didClickDeleteButton), for: .touchUpInside)
    }

    // MARK: - Selectors

    @objc private func didClickRightArrowButton() {
        rightCalculator.setResult(leftCalculator.currentResult)
    }

    @objc private func didClickLeftArrowButton() {
        leftCalculator.setResult(rightCalculator.currentResult)
    }

    @objc private func didClickDeleteButton() {
        rightCalculator.reset()
        leftCalculator.reset()
    }

    // MARK: - UI Components

    private lazy var leftCalculator = Calculator()
    private lazy var rightCalculator = Calculator()
    private let rightArrowButton = CalculatorButton(type: .arrow("➡\u{FE0E}"))
    private lazy var leftArrowButton: CalculatorButton = {
        $0.titleLabel?.transform = CGAffineTransformMakeRotation(.pi)
        return $0
    }(CalculatorButton(type: .arrow("➡\u{FE0E}")))
    private let deleteButton = CalculatorButton(type: .function("DEL"))
}
