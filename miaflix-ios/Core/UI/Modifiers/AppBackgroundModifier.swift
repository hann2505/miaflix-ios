//
//  AppBackgroundModifier.swift
//  miaflix-ios
//
//  Created by Hà Nguyễn on 3/9/26.
//

import SwiftUI

enum AppBackgroundStyle {
    case color(Color)
    case image(Image)
}

struct AppBackgroundModifier: ViewModifier {
    let style: AppBackgroundStyle
    
    func body(content: Content) -> some View {
        ZStack {
            switch style {
            case .color(let color):
                color
                    .ignoresSafeArea()

            case .image(let image):
                image
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
            }

            content
        }
    }
}

extension View {
    func appBackground(_ style: AppBackgroundStyle) -> some View {
        modifier(AppBackgroundModifier(style: style))
    }
}
