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

    init(viewModel: ActivityViewModel) {
        self.viewModel = viewModel
        _newTopic    = State(initialValue: viewModel.currentGoalTopic)
        _newDuration = State(initialValue: viewModel.currentGoalDuration)
    }

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)

            VStack(alignment: .leading, spacing: 30) {
                Text("I want to learn").foregroundColor(.white)
                TextField("E.g., how to make Sourdough", text: $newTopic)
                    .foregroundColor(.white)
                Rectangle().frame(height: 1).foregroundColor(.white.opacity(0.3))

                Text("I want to learn it in a").foregroundColor(.white)
                DurationPicker(selectedDuration: $newDuration)

                Spacer()
            }
            .padding(30)
            .blur(radius: viewModel.isGoalUpdateVisible ? 5 : 0)

            if viewModel.isGoalUpdateVisible {
                Color.black.opacity(0.4).ignoresSafeArea()

                GoalUpdateConfirmationView(
                    viewModel: viewModel,
                    newTopic: newTopic,
                    newDuration: newDuration
                )
                .transition(.opacity.combined(with: .scale))
            }
        }
        .navigationTitle("Learning Goal")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    viewModel.isGoalUpdateVisible = true
                } label: {
                    Image(systemName: "checkmark")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 36, height: 36)
                        .background(Circle().fill(Color(.primaryOrange)))
                }
                .buttonStyle(.plain)
            }
        }
    }
}

// MARK: - Confirmation Popup

struct GoalUpdateConfirmationView: View {
    @ObservedObject var viewModel: ActivityViewModel
    let newTopic: String
    let newDuration: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            Text("Update Learning goal")
                .font(.system(size: 17, weight: .bold))
                .foregroundColor(.white)

            Text("If you update now, your streak will start over.")
                .font(.system(size: 15))
                .foregroundColor(.gray)
                .fixedSize(horizontal: false, vertical: true)

            HStack(spacing: 12) {

                // Dismiss — rgba(118, 118, 128, 0.24)
                Button {
                    viewModel.isGoalUpdateVisible = false
                } label: {
                    Text("Dismiss")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 132, height: 48)
                        .background(
                            RoundedRectangle(cornerRadius: 24)
                                .fill(Color(red: 118/255, green: 118/255, blue: 128/255).opacity(0.24))
                        )
                }
                .buttonStyle(.plain)

                // Update — solid orange, no glow, no gradient
                Button {
                    viewModel.updateLearningGoal(newTopic: newTopic, newDuration: newDuration)
                } label: {
                    Text("Update")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 132, height: 48)
                        .background(
                            RoundedRectangle(cornerRadius: 24)
                                .fill(Color(red: 1, green: 146/255, blue: 48/255))
                        )
                }
                .buttonStyle(.plain)
            }
            .padding(.top, 4)
        }
        .padding(20)
        .frame(width: 300)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 34)
                    .fill(.ultraThinMaterial)
                RoundedRectangle(cornerRadius: 34)
                    .fill(LinearGradient(
                        colors: [Color.black.opacity(0.4), Color(red: 18/255, green: 18/255, blue: 18/255)],
                        startPoint: .top,
                        endPoint: .bottom
                    ))
            }
        )
        .shadow(color: Color.black.opacity(0.16), radius: 25, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 34)
                .strokeBorder(
                    LinearGradient(
                        colors: [
                            Color(red: 77/255, green: 77/255, blue: 77/255).opacity(0.6),
                            Color(red: 26/255, green: 26/255, blue: 26/255).opacity(0.8)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 0.5
                )
        )
    }
}

#Preview {
    LearningGoalView(viewModel: ActivityViewModel())
}
