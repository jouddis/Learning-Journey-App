//
//  LogActionButton.swift
//  Learning Journey
//
//  Created by Joud Almashgari on 29/05/2026.
//

import SwiftUI

struct LogActionButton: View {
    @ObservedObject var viewModel: ActivityViewModel

    // Circle size — change this one value to resize the button
    private let circleSize: CGFloat = 300

    private var backgroundColor: Color {
        switch viewModel.currentDayStatus {
        case .default: return Color(.primaryOrange)
        case .logged:  return Color(.primaryOrange).opacity(0.15)  // FIX: was Color(.red)
        case .freezed: return Color(.freeze).opacity(0.2)
        }
    }

    private var textColor: Color {
        switch viewModel.currentDayStatus {
        case .default: return .white
        case .logged:  return .orange
        case .freezed: return Color(.primaryBlue)
        }
    }

    private var buttonText: String {
        switch viewModel.currentDayStatus {
        case .default: return "Log as Learned"
        case .logged:  return "Learned Today"   // FIX: back to one line, no truncation with ZStack
        case .freezed: return "Day Freezed"
        }
    }

    var body: some View {
        Button {
            viewModel.logDayAsLearned()
        } label: {
            // FIX: ZStack with explicit circle size instead of .padding()-based sizing.
            // This means the Text is never width-constrained by the parent, so it
            // never truncates, and ZStack naturally centers it in the circle.
            ZStack {
                Circle()
                    .fill(backgroundColor.opacity(0.95))
                    .overlay(
                        Circle()
                            .strokeBorder(
                                AngularGradient(
                                    gradient: Gradient(colors: [
                                        Color.black.opacity(0.4),
                                        Color.white.opacity(0.6),
                                        Color.black.opacity(0.2),
                                        Color.white.opacity(0.9),
                                        Color.black.opacity(0.2),
                                        Color.black.opacity(0.4)
                                    ]),
                                    center: .center
                                ),
                                lineWidth: 1
                            )
                    )
                    .glassEffect(.clear.interactive())
                    .frame(width: circleSize, height: circleSize)

                Text(buttonText)
                    .bold()
                    .font(.system(size: 36))
                    .foregroundStyle(textColor)
                    .multilineTextAlignment(.center)
            }
        }
        .disabled(viewModel.isLogAsLearnedDisabled)
    }
}

#Preview {
    LogActionButton(viewModel: ActivityViewModel())
        .preferredColorScheme(.dark)
}
