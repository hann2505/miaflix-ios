//
//  AppTypography.swift
//  miaflix-ios
//
//  Created by Hà Nguyễn on 31/8/26.
//

import Foundation
import SwiftUI
import UIKit

enum AppTypography {
    enum Weight {
        case regular
        case medium
        case semibold
        case bold

        var fontWeight: Font.Weight {
            switch self {
            case .regular:
                return .regular
            case .medium:
                return .medium
            case .semibold:
                return .semibold
            case .bold:
                return .bold
            }
        }
    }

    enum TextStyle {
        case title1(Weight)
        case title2(Weight)
        case title3(Weight)
        case h1(Weight)
        case h2(Weight)
        case h3(Weight)
        case h4(Weight)
        case h5(Weight)
        case button1(Weight)
        case button2(Weight)
        case caption1(Weight)
        case caption2(Weight)
        case caption3(Weight)

        var size: CGFloat {
            switch self {
            case .title1:
                return 44
            case .title2:
                return 40
            case .title3:
                return 36
            case .h1:
                return 32
            case .h2:
                return 28
            case .h3:
                return 24
            case .h4:
                return 20
            case .h5:
                return 18
            case .button1:
                return 16
            case .button2:
                return 14
            case .caption1:
                return 12
            case .caption2:
                return 10
            case .caption3:
                return 8
            }
        }

        var lineHeight: CGFloat {
            switch self {
            case .title1:
                return 56
            case .title2(let weight):
                return weight == .medium ? 44 : 52
            case .title3:
                return 48
            case .h1(let weight):
                return weight == .regular ? 32 : 40
            case .h2:
                return 36
            case .h3:
                return 32
            case .h4:
                return 28
            case .h5:
                return 26
            case .button1:
                return 24
            case .button2:
                return 20
            case .caption1:
                return 16
            case .caption2:
                return 14
            case .caption3(let weight):
                return weight == .bold ? 14 : 12
            }
        }

        var weight: Weight {
            switch self {
            case .title1(let weight),
                 .title2(let weight),
                 .title3(let weight),
                 .h1(let weight),
                 .h2(let weight),
                 .h3(let weight),
                 .h4(let weight),
                 .h5(let weight),
                 .button1(let weight),
                 .button2(let weight),
                 .caption1(let weight),
                 .caption2(let weight),
                 .caption3(let weight):
                return weight
            }
        }

        var font: Font {
            if UIFont(name: "Roboto", size: size) != nil {
                return .custom("Roboto", fixedSize: size).weight(weight.fontWeight)
            }
            return .system(size: size, weight: weight.fontWeight)
        }

        var lineSpacing: CGFloat {
            max(lineHeight - size, 0)
        }
    }
}

private struct AppTypographyModifier: ViewModifier {
    let style: AppTypography.TextStyle

    func body(content: Content) -> some View {
        content
            .font(style.font)
            .lineSpacing(style.lineSpacing)
    }
}

extension View {
    func appTypography(_ style: AppTypography.TextStyle) -> some View {
        modifier(AppTypographyModifier(style: style))
    }
}
