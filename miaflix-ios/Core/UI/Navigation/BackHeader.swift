//
//  BackHeader.swift
//  miaflix-ios
//
//  Created by Hà Nguyễn on 2/9/26.
//

import SwiftUI

struct BackHeader<Trailing: View>: View {
    
    @Environment(\.dismiss) private var dismiss
    
    private let title: String
    private let trailing: Trailing
    
    init(
        title: String,
        @ViewBuilder trailing: ()-> Trailing
    ) {
        self.title = title
        self.trailing = trailing()
    }
    
    var body: some View {
        AppHeader {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .frame(width: 44, height: 44)
            }
            .glassEffect()
        } title: {
            Text(title).appTypography(.h4(.semibold))
        } trailing: {
            trailing
        }
    }
}

#Preview {
    BackHeader(title: "Miaflix") {
        Button {
            // More
        } label: {
            Image(systemName: "ellipsis")
                .frame(width: 40, height: 40)
        }
        .glassEffect(.regular.interactive())
    }
}
