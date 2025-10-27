//
//  OnboardingScreenView.swift
//  Learning Journey
//
//  Created by Joud Almashgari on 24/10/2025.
//

import SwiftUI

struct OnboardingScreenView: View {
    @ObservedObject var viewModel: ActivityViewModel
    private let textStyle: Font = .custom("SFPro-Medium", size: 17).weight(.medium)
    
    var body: some View {
        ZStack {
            // Using Color.background from Assets
            Color.background.edgesIgnoringSafeArea(.all)
            
            VStack(alignment:.leading ) {
                
                // --- Logo ---
                HStack {
                    Spacer()
                    ZStack {
                        Circle()
                            .fill(Color.red)
                            .frame(width: 109, height: 109)
                            .opacity(10/100)
                            .overlay(
                                Circle().stroke(
                                    AngularGradient(
                                        gradient:Gradient(
                                            colors:[Color.orange.opacity(40/100),
                                                    Color.yellow,
                                                    Color.red.opacity(50/100),
                                                    Color.brown,
                                                    Color.yellow,
                                                    Color.orange,
                                                    Color.red.opacity(40/100),
                                                    Color.red.opacity(40/100)]),
                                        center: .center)
                                    ,
                                    lineWidth: 0.4
                                )
                            )
                        Image(systemName: "flame.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 43, height: 43)
                            .foregroundColor(.orange)
                    }
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
                    VStack(alignment: .center){
                        Button("Start learning") {
                            viewModel.startLearning()
                            viewModel.currentScreen = .activity
                        }
                        .font(textStyle)
                        .foregroundColor(.white)
                        .frame(width: 182, height: 48)
                        .glassEffect(.clear.tint(Color("PrimaryOrange")).interactive())
                        .overlay(
                            RoundedRectangle(cornerRadius: 1000)
                                .stroke(LinearGradient(colors: [.brown, .orange, .brown, .orange, .yellow, .orange], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1)
                        )
                    }
                    Spacer()
                }
                .padding(.bottom, 20)
            }
            .padding(.horizontal, 30)
        }
    }
}

#Preview {
    OnboardingScreenView(viewModel: ActivityViewModel())
}
