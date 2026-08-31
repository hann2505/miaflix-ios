//
//  AppColors.swift
//  miaflix-ios
//
//  Created by Hà Nguyễn on 31/8/26.
//

import Foundation
import SwiftUI

struct AppColors {
    enum PrimaryBlue {
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

    /// Premium upsell card surface. Deliberately outside the `PrimaryBlue` scale — that
    /// scale is desaturated blue-grey, and this is a saturated navy that reads as brand
    /// rather than as one more background step.
    static let premiumCardBackground = Color(hex: 0x041141)

    static let primaryGradient = LinearGradient(
        colors: [Color(hex: 0x3F9FFF), Color(hex: 0x166EFE)],
        startPoint: .leading,
        endPoint: .trailing
    )
}

private extension Color {
    init(hex: UInt32, alpha: Double = 1) {
        let red = Double((hex >> 16) & 0xFF) / 255
        let green = Double((hex >> 8) & 0xFF) / 255
        let blue = Double(hex & 0xFF) / 255
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: alpha)
    }
}
