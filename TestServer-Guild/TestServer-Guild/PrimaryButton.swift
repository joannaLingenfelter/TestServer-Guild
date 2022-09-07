//
//  PrimaryButton.swift
//  TestServer-Guild
//
//  Created by Joanna Lingenfelter on 8/31/22.
//

import SwiftUI

struct PrimaryButton<Content: View>: View {
    @Environment(\.isEnabled) private var isEnabled

    @Binding var isLoading: Bool

    let action: () -> Void
    let label: () -> Content

    init<S: StringProtocol>(_ title: S, isLoading: Binding<Bool>, action: @escaping () -> Void) where Content == Text {
        self.init(isLoading: isLoading, action: action) {
            Text(title)
        }
    }

    init(isLoading: Binding<Bool>, action: @escaping () -> Void, label: @escaping () -> Content) {
        self.label = label
        self.action = action
        _isLoading = isLoading
    }

    var body: some View {
        Button(action: action) {
            HStack(alignment: .center) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .opacity(isLoading ? 1 : 0)
                }
                label()
                    .padding(.vertical, 5)
            }
            .padding(.horizontal, 5)
        }
        .tint(.black)
        .buttonStyle(.borderedProminent)
        .disabled(!isEnabled || isLoading)
    }
}
