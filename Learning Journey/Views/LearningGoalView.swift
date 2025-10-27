//
//  LearningGoalScreen.swift
//  Learning Journey
//
//  Created by Joud Almashgari on 24/10/2025.
//

import SwiftUI

struct LearningGoalView: View {
    @ObservedObject var viewModel: ActivityViewModel
    
    @State private var newTopic: String
    @State private var newDuration: String
    
    private let mediumTextStyle: Font = .custom("SFPro-Medium", size: 17).weight(.medium)
    
    init(viewModel: ActivityViewModel) {
        self.viewModel = viewModel
        _newTopic = State(initialValue: viewModel.currentGoalTopic)
        _newDuration = State(initialValue: viewModel.currentGoalDuration)
    }
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading, spacing: 30) {
                
                // --- Goal/Topic Input ---
                Text("I want to learn").foregroundColor(.white)
                TextField("E.g., how to make Sourdough", text: $newTopic)
                    .foregroundColor(.white)
                Rectangle().frame(height: 1).foregroundColor(.white.opacity(0.3))

                // --- Duration Selection ---
                Text("I want to learn it in a").foregroundColor(.white)
                DurationPicker(selectedDuration: $newDuration) // Custom component
                
                Spacer()
            }
            .padding(30)
            .blur(radius: viewModel.isGoalUpdateVisible ? 5 : 0)
            // 2. Pop-Over Alert Layer (Conditional Overlay)
                        if viewModel.isGoalUpdateVisible {
                            Color.black.opacity(0.4).ignoresSafeArea() // Dim the background
                            
                            // The custom pop-over view
                            GoalUpdateConfirmationView(
                                viewModel: viewModel,
                                newTopic: newTopic,
                                newDuration: newDuration
                            )
                            // Ensures the alert is centered on the screen
                            .transition(.opacity.combined(with: .scale))
                        }
        }
        // NavigationStack automatically provides the back button and title area
        .navigationTitle("Learning Goal")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                // Checkmark Button to confirm and pop back
                Button {
                    viewModel.isGoalUpdateVisible = true
//                    viewModel.updateLearningGoalConfirmed(newTopic: newTopic, newDuration: newDuration)
                } label: {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(Color(.orange))
                        .font(.title2)
                }
            }
        }
        
        }}

// --- SUB-VIEW for Confirmation Alert (Task 4) ---
struct GoalUpdateConfirmationView: View {
    @ObservedObject var viewModel: ActivityViewModel
    let newTopic: String
    let newDuration: String
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Update Learning goal").font(.headline)
            Text("If you update now, your streak will start over.")
                .font(.subheadline).foregroundColor(.gray)
            
            HStack {
                Button("Dismiss") { viewModel.isGoalUpdateVisible = false }
                    .buttonStyle(.bordered)
                
                Button("Update") {
                    viewModel.updateLearningGoal(newTopic: newTopic, newDuration: newDuration)
                }
                .buttonStyle(.borderedProminent)
                .tint(Color(.primaryOrange))
            }
        }
        .padding()
    }
}

#Preview {
    LearningGoalView(viewModel: ActivityViewModel())
}
