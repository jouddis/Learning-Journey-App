//
//  AllActivityView.swift
//  Learning Journey
//
//  Created by Joud Almashgari on 24/10/2025.
//

import SwiftUI

struct AllActivitiesView: View {
    @ObservedObject var viewModel: ActivityViewModel
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(spacing: 40) {
                    ForEach(viewModel.historicalCalendar.keys.sorted().reversed(), id: \.self) { monthYear in
                        MonthCalendarView(
                            monthYear: monthYear,
                            days: viewModel.historicalCalendar[monthYear] ?? [],
                            viewModel: viewModel
                        )
                    }
                }
                .padding(.top)
            }
        }
        .navigationTitle("All activities")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button { viewModel.currentScreen = .activity } label: { Image(systemName: "chevron.left") }
            }
            
            // Button to jump to specific date using your Picker
            ToolbarItem(placement: .navigationBarTrailing) {
                Button { viewModel.isMonthYearPickerVisible = true } label: {
                    Image(systemName: "calendar.badge.clock")
                }
            }
        }
        .sheet(isPresented: $viewModel.isMonthYearPickerVisible) {
            CalendarMonthYearPicker(
                selectedMonth: $viewModel.selectedPickerMonth,
                selectedYear: $viewModel.selectedPickerYear,
                onSelect: viewModel.handleMonthYearSelection
            )
        }
    }
}

// --- SUB-VIEW for rendering a single Month's calendar ---
struct MonthCalendarView: View {
    let monthYear: String
    let days: [CalendarDay]
    @ObservedObject var viewModel: ActivityViewModel
    
    private let dayHeaders = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(monthYear).font(.headline).foregroundColor(.white)
            
            HStack {
                ForEach(dayHeaders, id: \.self) { day in
                    Text(day).font(.caption).frame(maxWidth: .infinity).foregroundColor(.white.opacity(0.6))
                }
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                
                ForEach(1..<31) { day in
                    let dayData = days.first(where: { $0.day == day })
                    let status: DayStatus = dayData?.status ?? .default
                    
                    ZStack {
                        Circle()
                            .fill(dayColor(for: status))
                            .frame(width: 32, height: 32)
                            .opacity(status == .default ? 0.0 : 1.0)
                        
                        Text("\(day)")
                            .font(.system(size: 17, weight: .medium))
                            .foregroundColor(status == .logged ? .black : .white)
                    }
                }
            }
        }
        .padding(.horizontal)
    }
    
    private func dayColor(for status: DayStatus) -> Color {
        switch status {
        case .logged: return Color("PrimaryAccent")
        case .freezed: return Color("TealAccent")
        case .default: return .clear
        }
    }
}
