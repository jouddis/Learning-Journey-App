//
//  FreezeButton.swift
//  Learning Journey
//
//  Created by Joud Almashgari on 29/05/2026.
//

import SwiftUI

struct FreezeButton: View {
    @ObservedObject var viewModel: ActivityViewModel

    private var isDisabled: Bool {
        viewModel.isLogAsFreezedDisabled
    }

    private var buttonColor: Color {
        viewModel.freezesUsed < viewModel.availableFreezes
            ? Color(.freeze)
            : Color(.freeze).opacity(0.3)
    }

    var body: some View {
        VStack(spacing: 8) {
            Button {
                viewModel.logDayAsFreezed()
            } label: {
                Text("Log as Freezed")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
            }
            .frame(width: 264, height: 48)
            .background(
                RoundedRectangle(cornerRadius: 1000)
                    .fill(buttonColor)
            )
            .glassEffect()
            .disabled(isDisabled)
            .opacity(isDisabled ? 0.3 : 1.0)

            // Freeze count — no longer needs to live in ActivityMainView
            Text("\(viewModel.freezesUsed) out of \(viewModel.availableFreezes) Freezes used")
                .font(.caption)
                .foregroundColor(.secondaryText)
        }
    }
}

#Preview {
    FreezeButton(viewModel: ActivityViewModel())
        .preferredColorScheme(.dark)
}
