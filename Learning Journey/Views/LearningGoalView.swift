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
                
                Text("Learning Goal")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("I want to learn").foregroundColor(.white)
                TextField("E.g., how to make Sourdough", text: $newTopic)
                    .foregroundColor(.white)
                Rectangle().frame(height: 1).foregroundColor(.white.opacity(0.3))

                Text("I want to learn it in a").foregroundColor(.white)
                
                DurationPicker(selectedDuration: $newDuration)
                
                Spacer()
                
                Button("Update Goal") {
                    viewModel.isGoalUpdateVisible = true
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color("PrimaryAccent").opacity(0.45))
                .foregroundColor(.white)
                .clipShape(Capsule())
            }
            .padding(30)
        }
        .sheet(isPresented: $viewModel.isGoalUpdateVisible) {
            GoalUpdateConfirmationView(viewModel: viewModel, newTopic: newTopic, newDuration: newDuration)
        }
    }
}

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
                .tint(Color("PrimaryAccent"))
            }
        }
        .padding()
    }
}
