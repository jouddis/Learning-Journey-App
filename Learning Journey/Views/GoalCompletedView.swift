//
//  GoalCompletedView.swift
//  Learning Journey
//
//  Created by Joud Almashgari on 24/10/2025.
//

import SwiftUI

var clapSize: CGFloat = 55
var clapColor: Color = .orange

struct GoalCompletedView: View {
    @ObservedObject var viewModel: ActivityViewModel
    private let textStyle: Font = .custom("SFPro-Medium", size: 17).weight(.medium)
    
    var body: some View {
        VStack(spacing: 30) {
            VStack(spacing: 4){
               Image(systemName: "hands.and.sparkles.fill")
                    .symbolRenderingMode(.hierarchical)
                    .resizable()
                    .scaledToFit()
                    .frame(width: clapSize, height: clapSize)
                    .foregroundStyle(clapColor)
                
                Text("Well done!")
                    .font(.system( size: 22).bold())
                    


                Text("Goal completed! start learning again or set a new learning goal")
                    .font(.custom("SFPro-Medium", size: 18))
                    .foregroundColor(Color(.gray))
                    .padding(.bottom, 110)
                    .multilineTextAlignment(.center)
                    
                
            }
            .preferredColorScheme(.dark)


            
            Button("Set new learning goal") {
                
                viewModel.goToGoalUpdate()
            }
            .font(textStyle)
            .foregroundColor(.white)
            .frame(width: 246, height: 48)
            .glassEffect(.clear.tint(Color(.primaryOrange)).interactive())
            .overlay(
                RoundedRectangle(cornerRadius: 1000)
                    .stroke(LinearGradient(colors: [.brown, .orange, .brown, .orange, .yellow, .orange], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1)
            )
            
            
            Button("Set same learning goal and duration") {
                viewModel.setSameGoalAndDuration()
            }
            .foregroundColor(.orange)
            .font(.custom("SF Pro", size: 18).weight(.medium))
            .padding(.bottom, 16)
        }
        .frame(width:346, height:400)
        
        
    }
}


#Preview {
    GoalCompletedView(viewModel: ActivityViewModel())
}

