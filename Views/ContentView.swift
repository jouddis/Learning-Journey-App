//
//  ContentView.swift
//  Learning Journey
//
//  Created by Joud Almashgari on 16/10/2025.
//

import SwiftUI

struct ContentView: View {
    private let textStyle: Font = .custom("SFPro-Medium", size: 17).weight(.medium)
    
    @StateObject var viewModel = OnboardingViewModel()
//    @State private var selectedDuration: String = "Week"
//    @State private var learningTopic: String = "Swift"
    var body: some View {
        ZStack {
            
            Color.background.edgesIgnoringSafeArea(.all)
            
            VStack(alignment:.leading ) {
                HStack {
                    Spacer()
                    LogoView()
                    Spacer()
                }
                .padding(.top, 40)
                .padding(.bottom,30)
                
                Text("Hello Learner")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.primaryText)
                    
                
                
                Text("This app will help you learn everyday!")
                    .font(.body)
                    .foregroundStyle(Color.secondaryText)
                
                
                
                VStack (alignment:.leading, spacing: 15) {
                    Text("I want to learn")
                        .font(.custom("SFPro-Regular", size: 22))
                        .foregroundStyle(Color.primaryText)
                        .fontWeight(.medium)
                    
                    TextField("Swift", text: $viewModel.learningTopic)
                        .font(.custom("SFPro-Medium", size: 17))
                        .foregroundColor(Color.gray.opacity(0.4))
                        .accentColor(.orange)
                        .frame(height: 20)
                    
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.white.opacity(0.1))
                    
                    
                }.padding(.top, 20)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("I want to learn it in a")
                        .font(.custom("SFPro-Regular", size: 22))
                        .foregroundStyle(Color.primaryText)
                        .fontWeight(.medium)
                    
                    DurationPicker(selectedDuration: $viewModel.selectedDuration)
                    
                }
                .padding(.top, 15)
                Spacer()
                
               
                
//                Button("Start learning") {
//                    viewModel.startLearning()
//                }
//                .font(textStyle)
//                .foregroundColor(.white)
//                .frame(width: 182, height: 48 )
//                .glassEffect()
//                .background(
//                    RoundedRectangle(cornerRadius: 1000)
//                        .fill(Color.primaryOrange)
//                )
                VStack{
                    Spacer()
                    StartLearningButton(viewModel: viewModel)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea(.keyboard, edges: .bottom)
                
                
                
            }
            
        }
    }
}


#Preview {
    ContentView()
}
