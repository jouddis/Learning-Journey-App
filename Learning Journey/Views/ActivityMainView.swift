//
//  ActivityMainView.swift
//  Learning Journey
//
//  Created by Joud Almashgari on 24/10/2025.
//


import SwiftUI

struct ActivityMainView: View {
    @ObservedObject var viewModel: ActivityViewModel

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)

            VStack(alignment: .leading) {

                // --- Top Bar ---
                HStack(alignment: .top) {
                    Text("Activity")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)

                    Spacer()

                    Button(action: viewModel.goToAllActivities) {
                        Image(systemName: "calendar")
                            .font(.title2)
                            .foregroundColor(.white)
                            .frame(width: 44, height: 44)
                            .glassEffect()
                            .clipShape(Circle())
                    }

                    Button(action: viewModel.goToGoalUpdate) {
                        Image(systemName: "pencil.and.outline")
                            .font(.title2)
                            .foregroundColor(.white)
                            .frame(width: 44, height: 44)
                            .glassEffect()
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal, 45)
                .padding(.top, 40)
                .padding(.bottom, 19)

                // --- Calendar Card ---
                HStack {
                    CalendarView(activityViewModel: viewModel)
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 30)

                Spacer()

                // --- Action Area ---
                HStack {
                    Spacer()
                    VStack(spacing: 20) {
                        if viewModel.isGoalCompleted {
                            GoalCompletedView(viewModel: viewModel).padding(.bottom,24)
                        } else {
                            
                            LogActionButton(viewModel: viewModel)

                        
                            FreezeButton(viewModel: viewModel)
                                .padding(.bottom, 14)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ignoresSafeArea(.keyboard, edges: .bottom)
                    Spacer()
                }

                Spacer()
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            viewModel.checkInactivityForStreakLoss()
        }
    }
}

#Preview {
    ActivityMainView(viewModel: ActivityViewModel())
}
