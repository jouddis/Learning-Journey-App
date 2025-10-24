//
//  OnboardingScreenView.swift
//  Learning Journey
//
//  Created by Joud Almashgari on 24/10/2025.
//

import SwiftUI

struct OnboardingScreenView: View {
    @ObservedObject var viewModel: ActivityViewModel
    
    var body: some View {
        ZStack {
            // Using Color.background from Assets
            Color.background.edgesIgnoringSafeArea(.all)
            
            VStack(alignment:.leading ) {
                
                // --- Logo ---
                HStack {
                    Spacer()
                    LogoView() // Custom component
                    Spacer()
                }
                .padding(.top, 40)
                .padding(.bottom,30)
                
                // --- Title ---
                Text("Hello Learner")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .foregroundStyle(Color.primaryText)
                
                // --- Subtitle ---
                Text("This app will help you learn everyday!")
                                    .font(.body)
                                    .foregroundStyle(Color.secondaryText)
                
                // --- Text Input Field (Learning Topic) ---
                VStack (alignment:.leading, spacing: 15) {
                    Text("I want to learn")
                        .font(.custom("SFPro-Regular", size: 22))
                        .foregroundStyle(Color.primaryText)
                        .fontWeight(.medium)
                    
                    TextField("Swift", text: $viewModel.currentGoalTopic)
                        .font(.custom("SFPro-Medium", size: 17))
                        .foregroundColor(Color.gray.opacity(0.4))
                        .accentColor(.orange)
                        .frame(height: 20)
                    
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.white.opacity(0.1))
                }.padding(.top, 20)
                
                
                
                // --- Duration Selection ---
                VStack(alignment: .leading, spacing: 10) {
                                    Text("I want to learn it in a")
                                        .font(.custom("SFPro-Regular", size: 22))
                                        .foregroundStyle(Color.primaryText)
                                        .fontWeight(.medium)
                        
                    DurationPicker(selectedDuration: $viewModel.currentGoalDuration)
                }
                .padding(.top, 15)
                
                Spacer()
                
                // --- Start Learning Button ---
                HStack{
                    Spacer()
                    StartLearningButton(viewModel: viewModel)
                    Spacer()
                }
                .padding(.bottom, 20)
            }
            .padding(.horizontal, 30)
        }
    }
}

