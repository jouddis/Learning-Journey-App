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
        // Switch between the two top-level app states
                switch viewModel.currentScreen {
                case .onboarding:
                    OnboardingScreenView(viewModel: viewModel)
                    
                case .activity:
                    // CRITICAL: The main app content is wrapped in the NavigationStack
                    NavigationStack(path: $viewModel.navPath) {
                        
                        // Set the Root View of the stack
                        ActivityMainView(viewModel: viewModel)
                        
                        // Define all possible deep navigation destinations
                        .navigationDestination(for: NavDestination.self) { destination in
                            switch destination {
                            case .goalUpdate:
                                LearningGoalView(viewModel: viewModel)
                            case .allActivities:
                                HistoryLogView(viewModel: viewModel)
                            }
                        }
                    }
                    .tint(.white)
                }
                // LearningGoal and AllActivities are removed from the root switch
                // because they are now destinations inside the NavigationStack.
    }
}
 
#Preview {
    ContentView(viewModel: ActivityViewModel())
}
