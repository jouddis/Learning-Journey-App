//
//  LargeActionButtonView.swift
//  Learning Journey
//
//  Created by Joud Almashgari on 21/10/2025.
//

//import SwiftUI
//
//struct LargeActionButtonView: View {
//    @ObservedObject var viewModel: ActivityViewModel
//    
//    // Shared text style
//    private let buttonTextStyle: Font = .custom("SFPro-Bold", size: 24).weight(.bold)
//    
//    var body: some View {
//        VStack(spacing: 20) {
//            
//            // --- 1. Large Circular Button ---
//            Button {
//                // Only act if the day is in the .default state
//                if viewModel.currentDayStatus == .default {
//                    viewModel.logDayAsLearned()
//                }
//            } label: {
//                Text(mainButtonText(for: viewModel.currentDayStatus))
//                    .font(buttonTextStyle)
//                    .foregroundColor(mainButtonTextColor(for: viewModel.currentDayStatus))
//                    .frame(width: 250, height: 250)
//                    .background(
//                        Circle()
//                            .fill(mainButtonColor(for: viewModel.currentDayStatus))
//                    )
//            }
//            .disabled(viewModel.isLogAsLearnedDisabled)
//
//            // --- 2. Freeze Button ---
//            Button {
//                viewModel.logDayAsFreezed()
//            } label: {
//                Text("Log as Freezed")
//            }
//            .padding(.vertical, 10)
//            .padding(.horizontal, 30)
//            .background(
//                RoundedRectangle(cornerRadius: 1000)
//                    .fill(Color.teal) // Teal background color
//            )
//            .foregroundColor(.white)
//            .font(.subheadline)
//            .opacity(viewModel.isLogAsFreezedDisabled ? 0.3 : 1.0) // Dim if freezes are used
//            .disabled(viewModel.isLogAsFreezedDisabled)
//
//            // --- 3. Freeze Status Text ---
//            Text("\(viewModel.freezesUsed) out of \(viewModel.availableFreezes) Freezes used")
//                .font(.caption)
//                .foregroundColor(.white.opacity(0.7))
//                .padding(.bottom, 20)
//        }
//    }
//    
//    // MARK: - Dynamic Text & Color Logic
//    
//    private func mainButtonColor(for status: DayStatus) -> Color {
//        switch status {
//        case .default, .logged:
//            return .primaryOrange.opacity(0.8)
//        case .freezed:
//            return .teal.opacity(0.8)
//        }
//    }
//    
//    private func mainButtonTextColor(for status: DayStatus) -> Color {
//        // Text is white for default/freezed, dark brown/black for logged
//        switch status {
//        case .logged:
//            return Color.black
//        default:
//            return Color.white
//        }
//    }
//    
//    private func mainButtonText(for status: DayStatus) -> String {
//        switch status {
//        case .logged:
//            return "Learned Today"
//        case .freezed:
//            return "Day Freezed"
//        case .default:
//            return "Log as Learned"
//        }
//    }
//}
