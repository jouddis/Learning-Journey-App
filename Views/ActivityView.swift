//
//  ActivityView.swift
//  Learning Journey
//
//  Created by Joud Almashgari on 22/10/2025.
//

import SwiftUI

struct ActivityView: View {
    private let buttonTextStyle: Font = .custom("Helvetica-Bold", size: 36).weight(.bold)
    private let textStyle: Font = .custom("SFPro-Medium", size: 17).weight(.medium)
    
   // @StateObject var viewModel = OnboardingViewModel()
//    @State private var selectedDuration: String = "Week"
//    @State private var learningTopic: String = "Swift"
    var body: some View {
        ZStack {
            
            Color.background.edgesIgnoringSafeArea(.all)
            
            VStack(alignment:.leading ) {
                HStack(alignment: .top){
                    
                    Text("Activity")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.primaryText)
                    Spacer()
                    
                    
                    
                    Button(action: {
                        print("Tapped")
                    }) {
                        Image(systemName: "calendar")
                            .font(.title2)
                                    .foregroundColor(.white)
                                    .frame(width: 44, height: 44)
                                    .glassEffect() // 🪄 one line for glass!
                                    .clipShape(Circle())
                    }
                    
                    
                    Button(action: {
                        print("Tapped")
                    }) {
                        Image(systemName: "pencil.and.outline")
                            .font(.title2)
                                    .foregroundColor(.white)
                                    .frame(width: 44, height: 44)
                                    .glassEffect() // 🪄 one line for glass!
                                    .clipShape(Circle())
                    }
                }
                .padding(.bottom,19)
                
            
                VStack{
                    
                    CalendarView()
                }
                .padding(.bottom,30)
                VStack(spacing: 20){
                    
                    Button {
//                        // Only act if the day is in the .default state
//                        if viewModel.currentDayStatus == .default {
//                            viewModel.logDayAsLearned()
                        }
                    label: {
                        Text("Log as Learned")
                            .font(buttonTextStyle)
                            .foregroundColor(.white)
                            .frame(width: 250, height: 250)
                            .glassEffect(.clear.tint(.primaryOrange.opacity(15)).interactive())
//                            .background(
//                                Circle()
//                                    .fill(.accent))
                            
                    }

                    
                    
//                    Button("Log as learned") {
//                        /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/ /*@END_MENU_TOKEN@*/
//                    }
//                    .frame(width: 274, height: 274)
//                    .background(Color.accent)
                   
                }.frame(maxWidth: .infinity, maxHeight: .infinity)
                  
        
                VStack{
                    Spacer()
                    Button {
//                        viewModel.logDayAsFreezed()
                    } label: {
                        Text("Log as Freezed")
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 30)
                    .frame(width: 274, height: 48)
                    .glassEffect()
                    .background(
                        RoundedRectangle(cornerRadius: 1000)
                            .fill(Color.teal) // Teal background color
                    )
                    .foregroundColor(.white)
                    .font(.subheadline)
//                    .opacity(viewModel.isLogAsFreezedDisabled ? 0.3 : 1.0) // Dim if freezes are used
//                    .disabled(viewModel.isLogAsFreezedDisabled)
                    Text(" 1 out of 2 Freezes used")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                        .padding(.bottom, 14)
                   
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea(.keyboard, edges: .bottom)
                
               
                
            }
            
        }
    }
}




#Preview {
    ActivityView()
}
