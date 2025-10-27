//
//  ActivityCalendarView.swift
//  Learning Journey
//
//  Created by Joud Almashgari on 21/10/2025.
//
import SwiftUI

struct ActivityCalendarView: View {
    @ObservedObject var viewModel: ActivityViewModel
    
    // Shared text style for day numbers
    private let dayNumStyle: Font = .custom("SFPro-Medium", size: 17).weight(.medium)
    
    var body: some View {
        VStack(spacing: 15) {
            // Header: "October 2025"
            HStack {
                Text(viewModel.currentMonth)
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
                // Navigation arrows (simplified - actual logic would update viewModel.currentMonth)
                Image(systemName: "chevron.left").foregroundColor(.white.opacity(0.6))
                Text("TODAY").font(.caption).foregroundColor(.white.opacity(0.6))
                Image(systemName: "chevron.right").foregroundColor(.white.opacity(0.6))
            }
            .padding(.horizontal)
            
            // Day Row (Mon, Tue, Wed...)
            HStack {
                ForEach(["MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"], id: \.self) { day in
                    Text(day)
                        .font(.caption)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white.opacity(0.6))
                }
            }
            .padding(.horizontal)
            
            // Date Row (20, 21, 22...)
                        HStack {
                            ForEach(viewModel.calendarDays) { day in
                                ZStack {
                                    Circle()
                                        .fill(dayColor(for: day.status))
                                        .frame(width: 32, height: 32)
                                        .opacity(day.status == .default ? 0.2 : 1.0)
            
                                    Text("\(day.day)")
                                        .font(dayNumStyle)
                                        .foregroundColor(day.status == .default ? .white : .black)
                                }
                                .frame(maxWidth: .infinity)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            
                // Helper function to determine the circle color based on the day status
                private func dayColor(for status: DayStatus) -> Color {
                    switch status {
                    case .logged:
                        return .orange // Orange/Brown for Learned
                    case .freezed:
                        return .teal // Dark Teal/Blue for Freezed
                    case .default:
                        return .white // White circle (with opacity 0.2) for Default
                    }
                }
        }
        
        #Preview {
            ActivityCalendarView(viewModel: ActivityViewModel())
        }
    
