//
//  EnhancedCalculatorViewModel.swift
//  Aha-Calculators
//
//  Created by Cheng Lung, Lin on 2023/10/12.
//

import Foundation

protocol EnhancedCalculatorViewModelOutput: AnyObject {
    var rightCalculatorResult: String { get set }
    var leftCalculatorResult: String { get set }
    func resetCalculators()
}

final class EnhancedCalculatorViewModel {
    weak var output: EnhancedCalculatorViewModelOutput?

    func didClickRightArrowButton() {
        guard let output = output else { return }
        output.rightCalculatorResult = output.leftCalculatorResult
    }

    func didClickLeftArrowButton() {
        guard let output = output else { return }
        output.leftCalculatorResult = output.rightCalculatorResult
    }

    func didClickDeleteButton() {
        output?.resetCalculators()
    }
}
