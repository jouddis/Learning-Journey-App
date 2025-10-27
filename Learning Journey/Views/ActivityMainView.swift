//
//  ActivityMainView.swift
//  Learning Journey
//
//  Created by Joud Almashgari on 24/10/2025.
//

import SwiftUI

struct ActivityMainView: View {
    @ObservedObject var viewModel: ActivityViewModel
    
    private let buttonTextStyle: Font = .custom("Helvetica-Bold", size: 36).weight(.bold)
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading) {
                // TESTING CONTROLS - Remove this section when done testing
              //                DateSimulatorView(progress: viewModel)
              //                    .padding(.top, 20)
              //                // END TESTING CONTROLS
              //
              //                Spacer()
                
                // --- Top Header Bar (Activity Title, Calendar, Goal) ---
                HStack(alignment: .top ){
                    Text("Activity")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    // Button to open All Activities (Task 5)
                    Button(action:viewModel.goToAllActivities) {
                        Image(systemName: "calendar")
                            .font(.title2)
                            .foregroundColor(.white)
                            .frame(width: 44, height: 44)
                            .glassEffect()
                            .clipShape(Circle())
                    }
                    
                    // Button to open Goal Update (Task 4)
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
                
                // --- Calendar and Metrics (Combined Component) ---
                HStack {
                    
                    CalendarView(activityViewModel: viewModel)
                   
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 30)
                
                Spacer()
                
                // --- Conditional Action Area (Task 3 & 2) ---
                HStack {
                    Spacer()
                    VStack(spacing: 20){
                        if viewModel.isGoalCompleted {
                            GoalCompletedView(viewModel: viewModel)
                        } else {
                            // Large Action Button
                            Button {
                                viewModel.logDayAsLearned()
                            } label: {
                                Text(mainButtonText(for: viewModel.currentDayStatus))
                                    .font(buttonTextStyle)
                                    .foregroundColor(mainButtonTextColor(for: viewModel.currentDayStatus))
                                    .frame(width: 250, height: 250)
                                    .glassEffect(.clear.tint(Color(mainButtonColor(for: viewModel.currentDayStatus))).interactive())
                            }
                            .disabled(viewModel.isLogAsLearnedDisabled)

                            // Freeze Button
                            Button {
                                viewModel.logDayAsFreezed()
                            } label: {
                                Text("Log as Freezed")
                            }
                            .padding(.vertical, 10)
                            .padding(.horizontal, 30)
                            .frame(width: 274, height: 48)
                            .background(
                                RoundedRectangle(cornerRadius: 1000).fill(Color(.freeze))
                            )
                            .glassEffect()
                            .foregroundColor(.white)
                            .font(.subheadline)
                            .opacity(viewModel.isLogAsFreezedDisabled ? 0.3 : 1.0)
                            .disabled(viewModel.isLogAsFreezedDisabled)
                            
                            // Freeze Status Text
                            Text("\(viewModel.freezesUsed) out of \(viewModel.availableFreezes) Freezes used")
                                .font(.caption)
                                .foregroundColor(.secondaryText)
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
                // To ensure the back button is hidden on the root view (ActivityMainView)
                .navigationBarBackButtonHidden(true)
        .onAppear {
            // 🚀 CRITICAL: Check for streak loss every time the view loads
            viewModel.checkInactivityForStreakLoss()
            
        }
       
    }
        
        
    // Dynamic Button Helpers
    private func mainButtonColor(for status: DayStatus) -> Color {
        switch status {
        case .default: return Color(.primaryOrange)
        case .logged: return Color(.primaryOrange).opacity(25/100)
        case .freezed: return Color(.freeze).opacity(2/100)
        }
    }
    
    private func mainButtonTextColor(for status: DayStatus) -> Color {
        switch status {
        case .logged:
            return .orange
        case .freezed:
            return Color(.primaryBlue)
        case .default:
            return .white
        }
    }
    
    private func mainButtonText(for status: DayStatus) -> String {
        switch status {
        case .logged: return "Learned Today"
        case .freezed: return "Day Freezed"
        case .default: return "Log as Learned"
        }
    }
}
#Preview {
    ActivityMainView(viewModel: ActivityViewModel())
}

