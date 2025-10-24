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
    
    var body: some View {
        VStack(spacing: 30) {
            Image(systemName: "hand.raised.fill")
                .font(.largeTitle)
                .foregroundColor(Color("PrimaryAccent"))
            
            Text("Will done!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text("Goal completed! Start learning again or set new learning goal")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.center)
            
            // Set new learning goal button
            Button("Set new learning goal") {
                viewModel.currentScreen = .learningGoal
            }
            .padding()
            .background(Color("PrimaryAccent"))
            .foregroundColor(.white)
            .clipShape(Capsule())
            
            // Set same goal button
            Button("Set same learning goal and duration") {
                viewModel.setSameGoalAndDuration()
            }
            .foregroundColor(.white.opacity(0.7))
            .font(.caption)
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
