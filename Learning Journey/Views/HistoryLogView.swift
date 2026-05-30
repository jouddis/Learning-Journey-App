//
//  HistoryLogView.swift
//  Learning Journey
//
//  Created by Joud Almashgari on 24/10/2025.
//


import SwiftUI

struct HistoryLogView: View {
    @ObservedObject var viewModel: ActivityViewModel

    var activityHistory: ActivityHistory { viewModel.activityHistory }

    private let calendar = Calendar(identifier: .gregorian)
    private let months: [Date]

    init(viewModel: ActivityViewModel) {
        self.viewModel = viewModel

        let cal = Calendar(identifier: .gregorian)

        // Start from January of the year the user first joined
        let joinYear: Int = {
            if let startDate = viewModel.currentSession?.startDate {
                return cal.component(.year, from: startDate)
            }
            return cal.component(.year, from: Date())
        }()
        let januaryOfJoinYear = cal.date(from: DateComponents(year: joinYear, month: 1, day: 1))!

        // End at June 30 of the following year so users can plan ahead
        let nextYear = cal.component(.year, from: Date()) + 1
        let endOfFirstHalfNextYear = cal.date(from: DateComponents(year: nextYear, month: 6, day: 30))!

        self.months = HistoryLogView.buildMonths(from: januaryOfJoinYear, to: endOfFirstHalfNextYear)
    }

    private static func buildMonths(from start: Date, to end: Date) -> [Date] {
        let cal = Calendar(identifier: .gregorian)
        let startMonth = cal.date(from: cal.dateComponents([.year, .month], from: start))!
        let endMonth   = cal.date(from: cal.dateComponents([.year, .month], from: end))!
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
                        MonthLogSection(month: month, history: activityHistory)
                            .padding(.horizontal, 16)
                            .id(month)
                    }
                }
                .padding(.vertical, 12)
            }
            .onAppear {
                let currentMonth = Calendar.current.date(
                    from: Calendar.current.dateComponents([.year, .month], from: Date())
                )!
                withAnimation {
                    proxy.scrollTo(currentMonth, anchor: .top)
                }
            }
        }
        .navigationTitle("All activities")
        .navigationBarTitleDisplayMode(.inline)
        .preferredColorScheme(.dark)
        .background(Color.black.ignoresSafeArea())
    }
}

// MARK: - Month Section

private struct MonthLogSection: View {
    let month: Date
    var history: ActivityHistory

    private let cal = Calendar(identifier: .gregorian)

    private var headerTitle: String {
        let f = DateFormatter()
        f.locale = .current
        f.dateFormat = "LLLL yyyy"
        return f.string(from: month)
    }

    private let weekdayHeaders = ["SUN","MON","TUE","WED","THU","FRI","SAT"]

    private var dayCells: [(day: Int?, date: Date?)] {
        let firstOfMonth  = cal.date(from: cal.dateComponents([.year, .month], from: month))!
        let daysInMonth   = cal.range(of: .day, in: .month, for: firstOfMonth)!.count
        let leadingBlanks = cal.component(.weekday, from: firstOfMonth) - 1

        var cells: [(day: Int?, date: Date?)] = []
        for _ in 0..<leadingBlanks { cells.append((nil, nil)) }
        for day in 1...daysInMonth {
            if let date = cal.date(bySetting: .day, value: day, of: firstOfMonth) {
                cells.append((day, date))
            }
        }
        let remainder = cells.count % 7
        if remainder != 0 {
            for _ in 0..<(7 - remainder) { cells.append((nil, nil)) }
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
                            if let color = history.colorForDate(date) {
                                let isLogged = color == history.loggedColor
                                Circle().fill(color).frame(width: 44, height: 44)
                                Text("\(day)")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundStyle(isLogged ? Color.orange : Color(.primaryBlue))
                            } else if Calendar.current.isDateInToday(date) {
                                Circle().fill(Color.orange).frame(width: 44, height: 44)
                                Text("\(day)").font(.system(size: 16, weight: .semibold)).foregroundStyle(.white)
                            } else {
                                Text("\(day)").font(.system(size: 16, weight: .semibold)).foregroundStyle(.white)
                                    .frame(maxWidth: .infinity, minHeight: 44)
                            }
                        } else {
                            Text(" ").frame(maxWidth: .infinity, minHeight: 44)
                        }
                    }
                    .frame(height: 44)
                }
            }

            Divider().background(Color.gray.opacity(0.9)).padding(.top, 6)
        }
    }
}

#Preview {
    HistoryLogView(viewModel: ActivityViewModel())
}
