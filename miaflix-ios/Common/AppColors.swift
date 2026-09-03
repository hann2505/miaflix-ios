//
//  AppColors.swift
//  miaflix-ios
//
//  Created by Hà Nguyễn on 31/8/26.
//

import Foundation
import SwiftUI

struct AppColors {
    // MARK: - Surfaces & Background
    static let surface = Color(hex: 0x13121B)
    static let surfaceDim = Color(hex: 0x13121B)
    static let surfaceBright = Color(hex: 0x393842)
    static let surfaceContainerLowest = Color(hex: 0x0E0D16)
    static let surfaceContainerLow = Color(hex: 0x1B1B24)
    static let surfaceContainer = Color(hex: 0x1F1F28)
    static let surfaceContainerHigh = Color(hex: 0x2A2933)
    static let surfaceContainerHighest = Color(hex: 0x35343E)
    static let surfaceVariant = Color(hex: 0x35343E)
    static let surfaceDark = Color(hex: 0x050505)
    static let surfaceTint = Color(hex: 0xC3C0FF)
    static let onSurface = Color(hex: 0xE4E1EE)
    static let onSurfaceVariant = Color(hex: 0xC7C4D8)
    static let inverseSurface = Color(hex: 0xE4E1EE)
    static let inverseOnSurface = Color(hex: 0x302F39)
    static let background = Color(hex: 0x13121B)
    static let onBackground = Color(hex: 0xE4E1EE)

    // MARK: - Outline
    static let outline = Color(hex: 0x918FA1)
    static let outlineVariant = Color(hex: 0x464555)

    // MARK: - Primary
    static let primary = Color(hex: 0xC3C0FF)
    static let onPrimary = Color(hex: 0x1D00A5)
    static let primaryContainer = Color(hex: 0x4F46E5)
    static let onPrimaryContainer = Color(hex: 0xDAD7FF)
    static let inversePrimary = Color(hex: 0x4D44E3)
    static let primaryFixed = Color(hex: 0xE2DFFF)
    static let primaryFixedDim = Color(hex: 0xC3C0FF)
    static let onPrimaryFixed = Color(hex: 0x0F0069)
    static let onPrimaryFixedVariant = Color(hex: 0x3323CC)

    // MARK: - Secondary
    static let secondary = Color(hex: 0x89CEFF)
    static let onSecondary = Color(hex: 0x00344D)
    static let secondaryContainer = Color(hex: 0x00A2E6)
    static let onSecondaryContainer = Color(hex: 0x00344E)
    static let secondaryFixed = Color(hex: 0xC9E6FF)
    static let secondaryFixedDim = Color(hex: 0x89CEFF)
    static let onSecondaryFixed = Color(hex: 0x001E2F)
    static let onSecondaryFixedVariant = Color(hex: 0x004C6E)

    // MARK: - Tertiary
    static let tertiary = Color(hex: 0xFFB695)
    static let onTertiary = Color(hex: 0x571F00)
    static let tertiaryContainer = Color(hex: 0xA44100)
    static let onTertiaryContainer = Color(hex: 0xFFD2BE)
    static let tertiaryFixed = Color(hex: 0xFFDBCC)
    static let tertiaryFixedDim = Color(hex: 0xFFB695)
    static let onTertiaryFixed = Color(hex: 0x351000)
    static let onTertiaryFixedVariant = Color(hex: 0x7B2F00)

    // MARK: - Error
    static let error = Color(hex: 0xFFB4AB)
    static let onError = Color(hex: 0x690005)
    static let errorContainer = Color(hex: 0x93000A)
    static let onErrorContainer = Color(hex: 0xFFDAD6)

    // MARK: - Custom & Brand Accents
    static let deepIndigo = Color(hex: 0x1E1B4B)
    static let electricBlue = Color(hex: 0x60A5FA)
    static let glassStroke = Color(hex: 0xFFFFFF, alpha: 0.15)

    // MARK: - Semantic Namespaces
    enum Surface {
        static let base = AppColors.surface
        static let dim = AppColors.surfaceDim
        static let bright = AppColors.surfaceBright
        static let containerLowest = AppColors.surfaceContainerLowest
        static let containerLow = AppColors.surfaceContainerLow
        static let container = AppColors.surfaceContainer
        static let containerHigh = AppColors.surfaceContainerHigh
        static let containerHighest = AppColors.surfaceContainerHighest
        static let variant = AppColors.surfaceVariant
        static let dark = AppColors.surfaceDark
        static let tint = AppColors.surfaceTint
        static let on = AppColors.onSurface
        static let onVariant = AppColors.onSurfaceVariant
        static let inverse = AppColors.inverseSurface
        static let inverseOn = AppColors.inverseOnSurface
    }

    enum PrimaryPalette {
        static let base = AppColors.primary
        static let on = AppColors.onPrimary
        static let container = AppColors.primaryContainer
        static let onContainer = AppColors.onPrimaryContainer
        static let inverse = AppColors.inversePrimary
        static let fixed = AppColors.primaryFixed
        static let fixedDim = AppColors.primaryFixedDim
        static let onFixed = AppColors.onPrimaryFixed
        static let onFixedVariant = AppColors.onPrimaryFixedVariant
    }

    enum SecondaryPalette {
        static let base = AppColors.secondary
        static let on = AppColors.onSecondary
        static let container = AppColors.secondaryContainer
        static let onContainer = AppColors.onSecondaryContainer
        static let fixed = AppColors.secondaryFixed
        static let fixedDim = AppColors.secondaryFixedDim
        static let onFixed = AppColors.onSecondaryFixed
        static let onFixedVariant = AppColors.onSecondaryFixedVariant
    }

    enum TertiaryPalette {
        static let base = AppColors.tertiary
        static let on = AppColors.onTertiary
        static let container = AppColors.tertiaryContainer
        static let onContainer = AppColors.onTertiaryContainer
        static let fixed = AppColors.tertiaryFixed
        static let fixedDim = AppColors.tertiaryFixedDim
        static let onFixed = AppColors.onTertiaryFixed
        static let onFixedVariant = AppColors.onTertiaryFixedVariant
    }

    enum ErrorPalette {
        static let base = AppColors.error
        static let on = AppColors.onError
        static let container = AppColors.errorContainer
        static let onContainer = AppColors.onErrorContainer
    }

    enum Outline {
        static let base = AppColors.outline
        static let variant = AppColors.outlineVariant
    }

    // MARK: - Legacy Compatibility
    enum Primary {
        static let c60 = Color(hex: 0x377DF1)
        static let c50 = Color(hex: 0x2D65C2)
        static let c40 = Color(hex: 0x244E94)
        static let c30 = Color(hex: 0x1A3664)
        static let c20 = Color(hex: 0x111F36)
        static let c10 = Color(hex: 0x0B121E)
    }

    enum Neutral {
        static let primary1000 = Color(hex: 0x0E0D35)
        static let white = Color(hex: 0xFFFFFF)
        static let bg1 = Color(hex: 0x070707)
        static let bg2 = Color(hex: 0x1E1E1E)
        static let bg3 = Color(hex: 0x282828)
        static let bg4 = Color(hex: 0x343434)
        static let bg5 = Color(hex: 0x424242)
        static let bg6 = Color(hex: 0x707070)
    }

    enum Secondary {
        static let info = Color(hex: 0x00C8FF)
        static let danger = Color(hex: 0xFF333C)
        static let success = Color(hex: 0x00CA53)
        static let warning = Color(hex: 0xFFEC1D)

        static let infoPastel = Color(hex: 0xE8F8FF)
        static let dangerPastel = Color(hex: 0xFFEEEC)
        static let successPastel = Color(hex: 0xE0FFE1)
        static let warningPastel = Color(hex: 0xFFF8E0)
    }

    /// Premium upsell card surface.
    static let premiumCardBackground = Color(hex: 0x041141)

    static let primaryGradient = LinearGradient(
        colors: [Color(hex: 0x3F9FFF), Color(hex: 0x166EFE)],
        startPoint: .leading,
        endPoint: .trailing
    )
}

// MARK: - Color Extension & Helpers

extension Color {
    /// Convenient namespace accessor: `Color.app.surface`
    static let app = AppColors.self

    init(hex: UInt32, alpha: Double = 1.0) {
        let red = Double((hex >> 16) & 0xFF) / 255.0
        let green = Double((hex >> 8) & 0xFF) / 255.0
        let blue = Double(hex & 0xFF) / 255.0
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: alpha)
    }

    init(hex: String, alpha: Double? = nil) {
        var formatted = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        if formatted.hasPrefix("#") {
            formatted.removeFirst()
        }
        var rgbValue: UInt64 = 0
        Scanner(string: formatted).scanHexInt64(&rgbValue)

        if formatted.count == 8 {
            let r = Double((rgbValue >> 24) & 0xFF) / 255.0
            let g = Double((rgbValue >> 16) & 0xFF) / 255.0
            let b = Double((rgbValue >> 8) & 0xFF) / 255.0
            let a = alpha ?? (Double(rgbValue & 0xFF) / 255.0)
            self.init(.sRGB, red: r, green: g, blue: b, opacity: a)
        } else {
            let r = Double((rgbValue >> 16) & 0xFF) / 255.0
            let g = Double((rgbValue >> 8) & 0xFF) / 255.0
            let b = Double(rgbValue & 0xFF) / 255.0
            self.init(.sRGB, red: r, green: g, blue: b, opacity: alpha ?? 1.0)
        }
    }
}
