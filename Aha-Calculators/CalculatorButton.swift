//
//  CalculatorButton.swift
//  Aha-Calculators
//
//  Created by Cheng Lung, Lin on 2023/10/6.
//

import Foundation
import UIKit
import SnapKit

final class CalculatorButton: UIButton {
    enum Types {
        case operation(_ op: String)
        case function(_ fun: String)
        case number(_ num: String)
        case arrow(_ ar: String)
    }

    private let type: Types

    init(type: Types) {
        self.type = type
        super.init(frame: .zero)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let height = frame.height
        let ratio = height / 80
        layer.cornerRadius = 15 * ratio
        titleLabel?.font = .systemFont(ofSize: type.fontSize * ratio)
    }

    // MARK: - Private Methods

    private func setupUI() {
        setTitle()
        setBackground()
    }

    private func setTitle() {
        setTitle(type.label, for: .normal)
        titleLabel?.numberOfLines = 1
        titleLabel?.adjustsFontSizeToFitWidth = true
        setTitleColor(.white, for: .normal)
    }

    private func setBackground() {
        layer.masksToBounds = true
        backgroundColor = type.backgroundColor
    }
}

// MARK: Private Extensions

extension CalculatorButton.Types {
    var label: String {
        switch self {
        case let .operation(op):
            return op
        case let .function(fun):
            return fun
        case let .number(num):
            return num
        case let .arrow(ar):
            return ar
        }
    }

    var backgroundColor: UIColor {
        switch self {
        case .operation:
            return UIColor.rgb(r: 234, g: 164, b: 43)
        case .arrow:
            return UIColor.rgb(r: 63, g: 141, b: 84)
        case .function:
            return UIColor.rgb(r: 165, g: 165, b: 165)
        case .number:
            return UIColor.rgb(r: 50, g: 50, b: 50)
        }
    }

    var fontSize: CGFloat {
        switch self {
        case .function:
            return 50
        default:
            return 70
        }
    }
}

private extension UIColor {
    static func rgb(r: Int, g: Int, b: Int, alpha: CGFloat = 1) -> UIColor {
        UIColor(red: r.rgbInCGFloat, green: g.rgbInCGFloat, blue: b.rgbInCGFloat, alpha: alpha)
    }
}

private extension Int {
    var rgbInCGFloat: CGFloat { magnitude.rgbInCGFloat }
}

private extension UInt {
    var rgbInCGFloat: CGFloat { CGFloat(self) / 255.0 }
}

// MARK: Previews

#Preview {
    CalculatorButton(type: .operation("÷"))
}

#Preview {
    CalculatorButton(type: .function("DEL"))
}

#Preview {
    CalculatorButton(type: .arrow("➡\u{FE0E}"))
}

#Preview {
    CalculatorButton(type: .number("1"))
}
