//
//  ActionViews.swift
//  Learning Journey
//
//  Created by Joud Almashgari on 24/10/2025.
//

import SwiftUI

// --- Goal Completed View (Task 3 State) ---
struct GoalCompletedView: View {
    @ObservedObject var viewModel: ActivityViewModel
    private let textStyle: Font = .custom("SFPro-Medium", size: 17).weight(.medium)
    
    var body: some View {
        VStack(spacing: 30) {
            Image(systemName: "hands.clap.fill")
                .font(.largeTitle)
                .foregroundColor(Color(.orange))
            
            Text("Will done!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text("Goal completed! Start learning again or set new learning goal")
                .font(.custom("SFPro-Medium", size: 18))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
            
            // Set new learning goal button
            Button("Set new learning goal") {
                // Navigate to the goal update screen via NavigationStack
                viewModel.goToGoalUpdate()
            }
            .padding()
            .font(textStyle)
            .foregroundColor(.white)
            .frame(width: 264, height: 48)
            .glassEffect(.clear.tint(Color(.primaryOrange)).interactive())
            .overlay(
                RoundedRectangle(cornerRadius: 1000)
                    .stroke(LinearGradient(colors: [.brown, .orange, .brown, .orange, .yellow, .orange], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1)
            )
            
            // Set same goal button
            Button("Set same learning goal and duration") {
                viewModel.setSameGoalAndDuration()
            }
            .foregroundColor(.orange)
            .font(.custom("SFPro-Medium", size: 18))
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 50)
    }
}

// --- Large Action Button View (Task 2 State) ---
// Note: This struct is included here for completeness, as it often lives alongside the completed state.
struct LargeActionButtonView: View {
    @ObservedObject var viewModel: ActivityViewModel
    
    private let buttonTextStyle: Font = .custom("Helvetica-Bold", size: 36).weight(.bold)
    
    var body: some View {
        VStack(spacing: 20) {
            // Large Circular Button Logic...
            // (You should copy the rest of the LargeActionButtonView implementation from the previous full response here)
            Text("Placeholder for Log as Learned")
        }
    }
}

#Preview {
    GoalCompletedView(viewModel: ActivityViewModel())
}

