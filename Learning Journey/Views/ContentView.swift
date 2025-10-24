//
//  ContentView.swift
//  Learning Journey
//
//  Created by Joud Almashgari on 16/10/2025.
//

import SwiftUI

// This file is the App's Root View, handling navigation between major screens.
struct ContentView: View {
    // Inject the ViewModel initialized in the App file
    @StateObject var viewModel: ActivityViewModel
    
    var body: some View {
        Group {
            // Navigation Switch based on the ViewModel's state
            switch viewModel.currentScreen {
            case .onboarding:
                // Initial goal setting screen (uses the StartLearningButton)
                OnboardingScreenView(viewModel: viewModel)
            case .activity:
                // Main activity tracking screen
                ActivityMainView(viewModel: viewModel)
            case .learningGoal:
                // Goal update screen
                LearningGoalView(viewModel: viewModel)
            case .allActivities:
                // Historical calendar
                NavigationView {
                    AllActivitiesView(viewModel: viewModel)
                }
            }
        }
        .tint(.white)
    }
}
 
#Preview {
    ContentView(viewModel: ActivityViewModel())
}
