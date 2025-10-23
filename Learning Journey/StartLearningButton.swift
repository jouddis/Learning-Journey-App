//
//  StartLearningButton.swift
//  Learning Journey
//
//  Created by Joud Almashgari on 20/10/2025.
//
import SwiftUI

struct StartLearningButton: View {
    // Receive the view model from the parent (ContentView owns it)
    @ObservedObject var viewModel: OnboardingViewModel

    // Shared text style
    private let textStyle: Font = .custom("SFPro-Medium", size: 17).weight(.medium)
    
    var body: some View {
        VStack(alignment: .center){
            Button("Start learning") {
                viewModel.startLearning()
            }
            .font(textStyle)
            .foregroundColor(.white)
            .frame(width: 182, height: 48 )
            .glassEffect(.clear.tint(.primaryOrange.opacity(15)).interactive())
            .overlay(
                RoundedRectangle(cornerRadius: 1000)
                    .stroke(LinearGradient(colors: [.brown, .orange, .brown, .orange, .yellow, .orange], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1))
//            .background(
//                RoundedRectangle(cornerRadius: 1000)
//                    .fill(Color.primaryOrange)
           // )
        }
    }
}
