//
//  CalendarViewModel.swift
//  Learning Journey
//
//  Created by Joud Almashgari on 22/10/2025.
//
import Foundation
import Combine
import SwiftUI

final class CalendarViewModel: ObservableObject {
    // CRITICAL CHANGE: Initialize with current date
    @Published var currentDate: Date = Date()
    @Published var displayedMonth: Int = Calendar.current.component(.month, from: Date())
    @Published var displayedYear: Int = Calendar.current.component(.year, from: Date())
    
    private var calendar = Calendar.current
    private var timer: AnyCancellable?

    
    init() {
        let now = Date()
        let components = calendar.dateComponents([.month, .year], from: now)
        self.displayedMonth = components.month ?? 1
        self.displayedYear = components.year ?? 2025
        self.currentDate = now
        
        startTimer()
    }

    private func startTimer() {
        timer = Timer.publish(every: 60, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self else { return }
                self.currentDate = Date()
            }
    }

    deinit { timer?.cancel() }

    var monthName: String {
        let index = max(0, min(displayedMonth - 1, DateFormatter().monthSymbols.count - 1))
        return DateFormatter().monthSymbols[index]
    }
    
    var weekDates: [Date] {
        guard let weekInterval = calendar.dateInterval(of: .weekOfMonth, for: currentDate) else { return [] }
        return (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: weekInterval.start) }
    }

    func nextWeek() {
        guard let next = calendar.date(byAdding: .weekOfMonth, value: 1, to: currentDate) else { return }
        currentDate = next
        syncMonthYearWithCurrentDate()
    }

    func previousWeek() {
        guard let prev = calendar.date(byAdding: .weekOfMonth, value: -1, to: currentDate) else { return }
        currentDate = prev
        syncMonthYearWithCurrentDate()
    }

    func updateMonthYear(month: Int, year: Int) {
        displayedMonth = month
        displayedYear = year
        
        if let newDate = calendar.date(from: DateComponents(year: year, month: month, day: 1)) {
            currentDate = newDate
        }
    }

    private func syncMonthYearWithCurrentDate() {
        let components = calendar.dateComponents([.month, .year], from: currentDate)
        displayedMonth = components.month ?? displayedMonth
        displayedYear = components.year ?? displayedYear
    }
    
    
    func jumpToCurrentMonth() {
        let now = Date()
        let components = calendar.dateComponents([.month, .year], from: now)
        self.displayedMonth = components.month ?? 1
        self.displayedYear = components.year ?? 2025
        self.currentDate = now
    }
}
