//
//  AppHeader.swift
//  miaflix-ios
//
//  Created by Hà Nguyễn on 2/9/26.
//

import SwiftUI

struct AppHeader<
    Leading: View,
    Title: View,
    Trailing: View
>: View {
    private let leading: Leading
    private let title: Title
    private let trailing: Trailing
    
    init(
        @ViewBuilder leading: () -> Leading,
        @ViewBuilder title: () -> Title,
        @ViewBuilder trailing: () -> Trailing
    ) {
        self.leading = leading() 
        self.title = title()
        self.trailing = trailing()
    }
    
    // Title only
    init(
        @ViewBuilder title: () -> Title
    ) where Leading == EmptyView, Trailing == EmptyView {
        self.leading = EmptyView()
        self.title = title()
        self.trailing = EmptyView()
    }

    // Title + trailing
    init(
        @ViewBuilder title: () -> Title,
        @ViewBuilder trailing: () -> Trailing
    ) where Leading == EmptyView {
        self.leading = EmptyView()
        self.title = title()
        self.trailing = trailing()
    }

    // Leading + title
    init(
        @ViewBuilder leading: () -> Leading,
        @ViewBuilder title: () -> Title
    ) where Trailing == EmptyView {
        self.leading = leading()
        self.title = title()
        self.trailing = EmptyView()
    }
    
    var body: some View {
        ZStack {
            title
            
            HStack {
                leading
                Spacer()
                trailing
            }
            .padding(.horizontal, 16)
            .frame(height: 50)
        }
    }
}

#Preview {
    AppHeader {
        Button {
            // action
        } label: {
            Image(systemName: "chevron.left")
                .frame(width: 44, height: 44)
        }
        .glassEffect()
    } title: {
        Text("Miaflix")
    } trailing: {
        Button {
            // action
        } label: {
            Image(systemName: "magnifyingglass")
                .frame(width: 44, height: 44)
        }
        .glassEffect()
    }
}
