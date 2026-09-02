//
//  HomeView.swift
//  miaflix-ios
//
//  Created by Hà Nguyễn on 2/9/26.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack(spacing: 0) {
            AppHeader {
                Text("Miaflix").appTypography(.h1(.semibold))
            } trailing: {
                Button {
                    // action
                } label: {
                    Image(systemName: "magnifyingglass")
                        .frame(width: 44, height: 44)
                }
                .glassEffect()
            }
            ScrollView {
                // Home content
            }
        }
    }
}

#Preview {
    HomeView()
}
