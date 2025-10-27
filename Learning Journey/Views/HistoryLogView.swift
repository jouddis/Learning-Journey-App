//
//  AllActivityView.swift
//  Learning Journey
//
//  Created by Joud Almashgari on 24/10/2025.
//

//import SwiftUI
//
//struct AllActivitiesView: View {
//    @ObservedObject var viewModel: ActivityViewModel
//    
//    var body: some View {
//        ZStack {
//            Color.black.edgesIgnoringSafeArea(.all)
//            
//            ScrollView {
//                VStack(spacing: 40) {
//                    ForEach(viewModel.historicalCalendar.keys.sorted().reversed(), id: \.self) { monthYear in
//                        MonthCalendarView(
//                            monthYear: monthYear,
//                            days: viewModel.historicalCalendar[monthYear] ?? [],
//                            viewModel: viewModel
//                        )
//                    }
//                }
//                .padding(.top)
//            }
//        }
//        .navigationTitle("All activities")
//        .navigationBarTitleDisplayMode(.inline)
//        .toolbar {
//            ToolbarItem(placement: .navigationBarLeading) {
//                Button { viewModel.currentScreen = .activity } label: { Image(systemName: "chevron.left") }
//            }
//            
//            // Button to jump to specific date using your Picker
////            ToolbarItem(placement: .navigationBarTrailing) {
////                Button { viewModel.isMonthYearPickerVisible = true } label: {
////                    Image(systemName: "calendar.badge.clock")
////                }
////            }
//        }
//        .sheet(isPresented: $viewModel.isMonthYearPickerVisible) {
//            CalendarMonthYearPicker(
//                selectedMonth: $viewModel.selectedPickerMonth,
//                selectedYear: $viewModel.selectedPickerYear,
//                onSelect: viewModel.handleMonthYearSelection
//            )
//        }
//    }
//}
//
//// --- SUB-VIEW for rendering a single Month's calendar ---
//struct MonthCalendarView: View {
//    let monthYear: String
//    let days: [CalendarDay]
//    @ObservedObject var viewModel: ActivityViewModel
//    
//    private let dayHeaders = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"]
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 10) {
//            Text(monthYear).font(.headline).foregroundColor(.white)
//            
//            HStack {
//                ForEach(dayHeaders, id: \.self) { day in
//                    Text(day).font(.caption).frame(maxWidth: .infinity).foregroundColor(.white.opacity(0.6))
//                }
//            }
//            
//            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
//                
//                ForEach(1..<31) { day in
//                    let dayData = days.first(where: { $0.day == day })
//                    let status: DayStatus = dayData?.status ?? .default
//                    
//                    ZStack {
//                        Circle()
//                            .fill(dayColor(for: status))
//                            .frame(width: 32, height: 32)
//                            .opacity(status == .default ? 0.0 : 1.0)
//                        
//                        Text("\(day)")
//                            .font(.system(size: 17, weight: .medium))
//                            .foregroundColor(status == .logged ? .black : .white)
//                    }
//                }
//            }
//        }
//        .padding(.horizontal)
//    }
//    
//    private func dayColor(for status: DayStatus) -> Color {
//        switch status {
//        case .logged: return Color("PrimaryAccent")
//        case .freezed: return Color("TealAccent")
//        case .default: return .clear
//        }
//    }
//}
//
//#Preview {
//    AllActivitiesView(viewModel: ActivityViewModel())
//}



// In HistoryLogView.swift (The new file for Task 5)

import SwiftUI

struct HistoryLogView: View {
    // 🚀 Uses ActivityViewModel (the root)
    @ObservedObject var viewModel: ActivityViewModel
    
    // Renamed local reference
    var activityHistory: ActivityHistory { viewModel.activityHistory }

    private let calendar = Calendar(identifier: .gregorian)
    private let months: [Date]

    init(viewModel: ActivityViewModel,
         from start: Date = Calendar(identifier: .gregorian)
             .date(byAdding: .year, value: -1, to: Date())!,
         to end: Date = Calendar(identifier: .gregorian)
             .date(byAdding: .year, value: 10, to: Date())!
    ) {
        self.viewModel = viewModel
        // Use a static method (no change needed here)
        self.months = HistoryLogView.buildMonths(from: start, to: end)
    }

    private static func buildMonths(from start: Date, to end: Date) -> [Date] {
        let cal = Calendar(identifier: .gregorian)
        let startMonth = cal.date(from: cal.dateComponents([.year, .month], from: start))!
        let endMonth = cal.date(from: cal.dateComponents([.year, .month], from: end))!
        var cursor = startMonth
        var result: [Date] = []
        while cursor <= endMonth {
            result.append(cursor)
            cursor = cal.date(byAdding: .month, value: 1, to: cursor)!
        }
        return result
    }

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 24) {
                    ForEach(months, id: \.self) { month in
                        // 🚀 Use the new MonthLogSection and pass the history model
                        MonthLogSection(month: month, history: activityHistory)
                            .padding(.horizontal, 16)
                            .id(month)
                    }
                }
                .padding(.vertical, 12)
            }
            // ... (onAppear scroll logic remains the same) ...
        }
        .navigationTitle("All activities")
        .navigationBarTitleDisplayMode(.inline)
        .preferredColorScheme(.dark)
        .background(Color.black.ignoresSafeArea())
    }
}

// 🚀 Renamed the sub-struct
private struct MonthLogSection: View {
    let month: Date
    var history: ActivityHistory // Use the concrete ActivityHistory type
    
    private let cal = Calendar(identifier: .gregorian)

    private var headerTitle: String {
        let f = DateFormatter()
        f.locale = .current
        f.dateFormat = "LLLL yyyy"
        return f.string(from: month)
    }

    private let weekdayHeaders = ["SUN","MON","TUE","WED","THU","FRI","SAT"]

    private var dayCells: [(day: Int?, date: Date?)] {
        // ... (Date calculation logic remains the same) ...
        let firstOfMonth = cal.date(from: cal.dateComponents([.year, .month], from: month))!
        let daysInMonth = cal.range(of: .day, in: .month, for: firstOfMonth)!.count
        let weekdayIndex = cal.component(.weekday, from: firstOfMonth)
        let leadingBlanks = weekdayIndex - 1

        var cells: [(day: Int?, date: Date?)] = []
        
        for _ in 0..<leadingBlanks { cells.append((day: nil, date: nil)) }
        for day in 1...daysInMonth {
            if let date = cal.date(bySetting: .day, value: day, of: firstOfMonth) {
                cells.append((day: day, date: date))
            }
        }
        let remainder = cells.count % 7
        if remainder != 0 {
            for _ in 0..<(7 - remainder) { cells.append((day: nil, date: nil)) }
        }
        return cells
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(headerTitle)
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(.white)
                .padding(.top, 4)

            HStack(spacing: 19) {
                ForEach(weekdayHeaders, id: \.self) { d in
                    Text(d)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(.gray)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }

            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: 7), spacing: 10) {
                ForEach(Array(dayCells.enumerated()), id: \.offset) { _, cell in
                    ZStack {
                        if let day = cell.day, let date = cell.date {
                            // 🚀 Use history.colorForDate() for lookup
                            if let color = history.colorForDate(date) {
                                Circle().fill(color).frame(width: 32, height: 32)
                                Text("\(day)").font(.system(size: 16, weight: .semibold)).foregroundStyle(.black)
                            } else {
                                Text("\(day)").font(.system(size: 16, weight: .semibold)).foregroundStyle(.white)
                                    .frame(maxWidth: .infinity, minHeight: 32)
                            }
                        } else {
                            Text(" ").frame(maxWidth: .infinity, minHeight: 32)
                        }
                    }
                    .frame(height: 32)
                }
            }

            Divider().background(Color.gray.opacity(0.9)).padding(.top, 6)
        }
        
    }
}

#Preview {
    HistoryLogView(viewModel: ActivityViewModel())
}
