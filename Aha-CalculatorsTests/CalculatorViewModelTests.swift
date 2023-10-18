//
//  CalculatorViewModelTests.swift
//  Aha-CalculatorsTests
//
//  Created by Cheng Lung, Lin on 2023/10/17.
//

@testable import Aha_Calculators
import XCTest

final class CalculatorViewModelTests: XCTestCase {
    func test_whenClickButtons_thenFormulaIsNotEmpty() {
        // Given
        let sut = CalculatorViewModel()

        // When
        sut.didClickButton(CalculatorButton(type: .oneButtonType))
        sut.didClickButton(CalculatorButton(type: .plusButtonType))
        sut.didClickButton(CalculatorButton(type: .twoButtonType))

        // Then
        XCTAssertEqual(sut.formulaStack, [.oneButtonType, .plusButtonType, .twoButtonType])
        XCTAssertEqual(sut.resultString, CalculatorViewModel.defaultResult)
    }

    func test_whenClickClearButton_thenResetFormula() {
        // Given
        let sut = CalculatorViewModel()
        sut.didClickButton(CalculatorButton(type: .oneButtonType))
        sut.didClickButton(CalculatorButton(type: .plusButtonType))
        sut.didClickButton(CalculatorButton(type: .twoButtonType))

        // When
        sut.didClickButton(CalculatorButton(type: .acButtonType))

        // Then
        XCTAssertTrue(sut.formulaStack.isEmpty)
        XCTAssertEqual(sut.resultString, CalculatorViewModel.defaultResult)
    }

    func test_whenClickSignButton_thenChangeCurrentNumberSign() {
        // Given
        let sut = CalculatorViewModel()

        // When
        sut.didClickButton(CalculatorButton(type: .oneButtonType))
        sut.didClickButton(CalculatorButton(type: .plusButtonType))
        sut.didClickButton(CalculatorButton(type: .twoButtonType))
        sut.didClickButton(CalculatorButton(type: .signButtonType))

        // Then
        XCTAssertEqual(sut.formulaStack, [.oneButtonType, .plusButtonType, .number("-2")])
        XCTAssertEqual(sut.resultString, CalculatorViewModel.defaultResult)
    }

    func test_whenClickSignButton_thenChangeComingNumberSign() {
        // Given
        let sut = CalculatorViewModel()

        // When
        sut.didClickButton(CalculatorButton(type: .oneButtonType))
        sut.didClickButton(CalculatorButton(type: .plusButtonType))
        sut.didClickButton(CalculatorButton(type: .signButtonType))
        sut.didClickButton(CalculatorButton(type: .twoButtonType))

        // Then
        XCTAssertEqual(sut.formulaStack, [.oneButtonType, .plusButtonType, .number("-2")])
        XCTAssertEqual(sut.resultString, CalculatorViewModel.defaultResult)
    }

    func test_whenEmptyFormulaAndClickSignButton_thenChangeComingNumberSign() {
        // Given
        let sut = CalculatorViewModel()

        // When
        sut.didClickButton(CalculatorButton(type: .signButtonType))
        sut.didClickButton(CalculatorButton(type: .oneButtonType))

        // Then
        XCTAssertEqual(sut.formulaStack, [.number("-1")])
        XCTAssertEqual(sut.resultString, CalculatorViewModel.defaultResult)
    }

    func test_whenEmptyFormulaAndClickPercentButton_thenDoNothing() {
        // Given
        let sut = CalculatorViewModel()

        // When
        sut.didClickButton(CalculatorButton(type: .percentButtonType))

        // Then
        XCTAssertTrue(sut.formulaStack.isEmpty)
        XCTAssertEqual(sut.resultString, CalculatorViewModel.defaultResult)
    }

    func test_whenClickPercentButtonWithLastNumber_thenChangeLastNumber() {
        // Given
        let sut = CalculatorViewModel()
        sut.didClickButton(CalculatorButton(type: .oneButtonType))
        sut.didClickButton(CalculatorButton(type: .plusButtonType))
        sut.didClickButton(CalculatorButton(type: .twoButtonType))

        // When
        sut.didClickButton(CalculatorButton(type: .percentButtonType))

        // Then
        XCTAssertEqual(sut.formulaStack, [.oneButtonType, .plusButtonType, .number("0.02")])
        XCTAssertEqual(sut.resultString, CalculatorViewModel.defaultResult)
    }

    func test_whenClickPercentButtonWithLastOperator_thenChangeLastNumber() {
        // Given
        let sut = CalculatorViewModel()
        sut.didClickButton(CalculatorButton(type: .oneButtonType))
        sut.didClickButton(CalculatorButton(type: .plusButtonType))

        // When
        sut.didClickButton(CalculatorButton(type: .percentButtonType))

        // Then
        XCTAssertEqual(sut.formulaStack, [.number("0.01"), .plusButtonType])
        XCTAssertEqual(sut.resultString, CalculatorViewModel.defaultResult)
    }

    func test_whenClickOperator_thenAppendOperator() {
        // Given
        let sut = CalculatorViewModel()
        sut.didClickButton(CalculatorButton(type: .oneButtonType))

        // When
        sut.didClickButton(CalculatorButton(type: .plusButtonType))

        // Then
        XCTAssertEqual(sut.formulaStack, [.oneButtonType, .plusButtonType])
        XCTAssertEqual(sut.resultString, CalculatorViewModel.defaultResult)
    }

    func test_whenClickTwoOperators_thenKeepTheLastOperator() {
        // Given
        let sut = CalculatorViewModel()
        sut.didClickButton(CalculatorButton(type: .oneButtonType))
        sut.didClickButton(CalculatorButton(type: .plusButtonType))

        // When
        sut.didClickButton(CalculatorButton(type: .multiplyButtonType))

        // Then
        XCTAssertEqual(sut.formulaStack, [.oneButtonType, .multiplyButtonType])
        XCTAssertEqual(sut.resultString, CalculatorViewModel.defaultResult)
    }

    func test_whenClickSignAndNumber_thenChangeNumberSign() {
        // Given
        let sut = CalculatorViewModel()
        sut.didClickButton(CalculatorButton(type: .signButtonType))

        // When
        sut.didClickButton(CalculatorButton(type: .oneButtonType))

        // Then
        XCTAssertEqual(sut.formulaStack, [.number("-1")])
        XCTAssertEqual(sut.resultString, CalculatorViewModel.defaultResult)
    }

    func test_whenClickSignWithNegtiveNumber_thenChangeNumberSign() {
        // Given
        let sut = CalculatorViewModel()
        sut.didClickButton(CalculatorButton(type: .signButtonType))
        sut.didClickButton(CalculatorButton(type: .oneButtonType))

        // When
        sut.didClickButton(CalculatorButton(type: .signButtonType))

        // Then
        XCTAssertEqual(sut.formulaStack, [.oneButtonType])
        XCTAssertEqual(sut.resultString, CalculatorViewModel.defaultResult)
    }

    func test_whenClickTwoNumbers_thenAppendNumbers() {
        // Given
        let sut = CalculatorViewModel()
        sut.didClickButton(CalculatorButton(type: .oneButtonType))

        // When
        sut.didClickButton(CalculatorButton(type: .twoButtonType))

        // Then
        XCTAssertEqual(sut.formulaStack, [.number("12")])
        XCTAssertEqual(sut.resultString, CalculatorViewModel.defaultResult)
    }

    func test_whenClickNumberWithEmptyFormula_thenAppendNumber() {
        // Given
        let sut = CalculatorViewModel()

        // When
        sut.didClickButton(CalculatorButton(type: .oneButtonType))

        // Then
        XCTAssertEqual(sut.formulaStack, [.oneButtonType])
        XCTAssertEqual(sut.resultString, CalculatorViewModel.defaultResult)
    }

    func test_whenClickNumberAndDot_thenAppendDot() {
        // Given
        let sut = CalculatorViewModel()
        sut.didClickButton(CalculatorButton(type: .oneButtonType))

        // When
        sut.didClickButton(CalculatorButton(type: .dotButtonType))

        // Then
        XCTAssertEqual(sut.formulaStack, [.number("1.")])
        XCTAssertEqual(sut.resultString, CalculatorViewModel.defaultResult)
    }

    func test_whenClickNumberWithDotAndClickDot_thenDoNothing() {
        // Given
        let sut = CalculatorViewModel()
        sut.didClickButton(CalculatorButton(type: .number("1.1")))

        // When
        sut.didClickButton(CalculatorButton(type: .dotButtonType))

        // Then
        XCTAssertEqual(sut.formulaStack, [.number("1.1")])
        XCTAssertEqual(sut.resultString, CalculatorViewModel.defaultResult)
    }

    func test_whenWithOperatorAndClickDot_thenAddZeroWithDot() {
        // Given
        let sut = CalculatorViewModel()
        sut.didClickButton(CalculatorButton(type: .oneButtonType))
        sut.didClickButton(CalculatorButton(type: .plusButtonType))

        // When
        sut.didClickButton(CalculatorButton(type: .dotButtonType))

        // Then
        XCTAssertEqual(sut.formulaStack, [.oneButtonType, .plusButtonType, .number("0.")])
        XCTAssertEqual(sut.resultString, CalculatorViewModel.defaultResult)
    }

    func test_whenWithFormulaAndClickEqual_thenGetResult() {
        // Given
        let sut = CalculatorViewModel()
        sut.didClickButton(CalculatorButton(type: .oneButtonType))
        sut.didClickButton(CalculatorButton(type: .plusButtonType))
        sut.didClickButton(CalculatorButton(type: .twoButtonType))
        sut.didClickButton(CalculatorButton(type: .minusButtonType))
        sut.didClickButton(CalculatorButton(type: .twoButtonType))

        // When
        sut.didClickButton(CalculatorButton(type: .equalButtonType))

        // Then
        XCTAssertEqual(
            sut.formulaStack,
            [.oneButtonType, .plusButtonType, .twoButtonType, .minusButtonType, .twoButtonType, .equalButtonType]
        )
        XCTAssertEqual(sut.resultString, "1")
    }

    func test_whenWithMultiplyAndDividInFormulaAndClickEqual_thenGetResult() {
        // Given
        let sut = CalculatorViewModel()
        // 1 + 2 * 3 / 4 + 5
        sut.didClickButton(CalculatorButton(type: .oneButtonType))
        sut.didClickButton(CalculatorButton(type: .plusButtonType))
        sut.didClickButton(CalculatorButton(type: .twoButtonType))
        sut.didClickButton(CalculatorButton(type: .multiplyButtonType))
        sut.didClickButton(CalculatorButton(type: .threeButtonType))
        sut.didClickButton(CalculatorButton(type: .dividButtonType))
        sut.didClickButton(CalculatorButton(type: .fourButtonType))
        sut.didClickButton(CalculatorButton(type: .plusButtonType))
        sut.didClickButton(CalculatorButton(type: .fiveButtonType))

        // When
        sut.didClickButton(CalculatorButton(type: .equalButtonType))

        // Then
        XCTAssertEqual(
            sut.formulaStack,
            [
                .oneButtonType,
                .plusButtonType,
                .twoButtonType,
                .multiplyButtonType,
                .threeButtonType,
                .dividButtonType,
                .fourButtonType,
                .plusButtonType,
                .fiveButtonType,
                .equalButtonType
            ]
        )
        XCTAssertEqual(sut.resultString, "7.5")
    }
}
