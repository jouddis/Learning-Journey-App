//
//  ContentView.swift
//  Learning Journey
//
//  Created by Joud Almashgari on 16/10/2025.
//

import SwiftUI


struct ContentView: View {
    
    @StateObject var viewModel: ActivityViewModel
    
    var body: some View {
       
                switch viewModel.currentScreen {
                case .onboarding:
                    OnboardingScreenView(viewModel: viewModel)
                    
                case .activity:
                    
                    NavigationStack(path: $viewModel.navPath) {
                        
                       
                        ActivityMainView(viewModel: viewModel)
                        
                        
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
                
    }
}
 
#Preview {
    ContentView(viewModel: ActivityViewModel())
}
