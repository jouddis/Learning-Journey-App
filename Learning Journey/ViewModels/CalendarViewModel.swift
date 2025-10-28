//
//  CalendarViewModel.swift
//  Learning Journey
//
//  Created by Joud Almashgari on 22/10/2025.
//
//import SwiftUI
//import Combine
//
//final class CalendarViewModel: ObservableObject {
//    @Published var currentDate: Date = Date()
//    @Published var displayedMonth: Int
//    @Published var displayedYear: Int
//    
//    private var calendar = Calendar.current
//    private var timer: AnyCancellable?
//
//    init() {
//        let now = Date()
//        let components = calendar.dateComponents([.month, .year], from: now)
//        displayedMonth = components.month ?? 1
//        displayedYear = components.year ?? 2025
//        currentDate = now
//        startTimer()
//    }
//
//    private func startTimer() {
//        timer = Timer.publish(every: 60, on: .main, in: .common)
//            .autoconnect()
//            .sink { [weak self] _ in
//                guard let self else { return }
//                self.currentDate = Date()
//            }
//    }
//
//    deinit { timer?.cancel() }
//
//    var monthName: String {
//        DateFormatter().monthSymbols[displayedMonth - 1]
//    }
//
//    var weekDates: [Date] {
//        guard let weekInterval = calendar.dateInterval(of: .weekOfMonth, for: currentDate) else { return [] }
//        return (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: weekInterval.start) }
//    }
//
//    func nextWeek() {
//        guard let next = calendar.date(byAdding: .weekOfMonth, value: 1, to: currentDate) else { return }
//        currentDate = next
//        syncMonthYearWithCurrentDate()
//    }
//
//    func previousWeek() {
//        guard let prev = calendar.date(byAdding: .weekOfMonth, value: -1, to: currentDate) else { return }
//        currentDate = prev
//        syncMonthYearWithCurrentDate()
//    }
//
//    func updateMonthYear(month: Int, year: Int) {
//        displayedMonth = month
//        displayedYear = year
//        
//        if let newDate = calendar.date(from: DateComponents(year: year, month: month, day: 1)) {
//            currentDate = newDate
//        }
//    }
//
//    private func syncMonthYearWithCurrentDate() {
//        let components = calendar.dateComponents([.month, .year], from: currentDate)
//        displayedMonth = components.month ?? displayedMonth
//        displayedYear = components.year ?? displayedYear
//    }
//}


//import Foundation
//import Combine
//import SwiftUI
//
//final class CalendarViewModel: ObservableObject {
//    // ⚠️ CRITICAL CHANGE: Store the entire ActivityViewModel reference
//        private let activityViewModel: ActivityViewModel
////    // ⚠️ These metrics are passed from ActivityViewModel for display purposes only
////    let daysLearned: Int
////    let daysFreezed: Int
//    
//    @Published var currentDate: Date
//    @Published var displayedMonth: Int
//    @Published var displayedYear: Int
//    
//    private var calendar = Calendar.current
//    private var timer: AnyCancellable?
//
//    // 🚀 NEW: Computed properties that pull data directly from the observed VM
//        // These will react whenever activityViewModel updates.
//        var daysLearned: Int { return activityViewModel.daysLearned }
//        var daysFreezed: Int { return activityViewModel.daysFreezed }
//    
//    
//    
//    init(activityViewModel: ActivityViewModel) {
//            self.activityViewModel = activityViewModel // Store the reference
//            
//            let now = Date()
//            let calendar = Calendar.current
//            let components = calendar.dateComponents([.month, .year], from: now)
//            
//            // ❌ REMOVED: The problematic assignment lines are gone!
//            // self.daysLearned = initialDaysLearned
//            // self.daysFreezed = initialDaysFreezed
//            
//            self.displayedMonth = components.month ?? 1
//            self.displayedYear = components.year ?? 2025
//            self.currentDate = now
//            
//            startTimer()
//        }
//
//    private func startTimer() {
//        timer = Timer.publish(every: 60, on: .main, in: .common)
//            .autoconnect()
//            .sink { [weak self] _ in
//                guard let self else { return }
//                self.currentDate = Date()
//            }
//    }
//
//    deinit { timer?.cancel() }
//
//    var monthName: String {
//        let index = max(0, min(displayedMonth - 1, DateFormatter().monthSymbols.count - 1))
//        return DateFormatter().monthSymbols[index]
//    }
//    
//    var weekDates: [Date] {
//        guard let weekInterval = calendar.dateInterval(of: .weekOfMonth, for: currentDate) else { return [] }
//        return (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: weekInterval.start) }
//    }
//
//    func nextWeek() {
//        guard let next = calendar.date(byAdding: .weekOfMonth, value: 1, to: currentDate) else { return }
//        currentDate = next
//        syncMonthYearWithCurrentDate()
//    }
//
//    func previousWeek() {
//        guard let prev = calendar.date(byAdding: .weekOfMonth, value: -1, to: currentDate) else { return }
//        currentDate = prev
//        syncMonthYearWithCurrentDate()
//    }
//
//    func updateMonthYear(month: Int, year: Int) {
//        displayedMonth = month
//        displayedYear = year
//        
//        if let newDate = calendar.date(from: DateComponents(year: year, month: month, day: 1)) {
//            currentDate = newDate
//        }
//    }
//
//    private func syncMonthYearWithCurrentDate() {
//        let components = calendar.dateComponents([.month, .year], from: currentDate)
//        displayedMonth = components.month ?? displayedMonth
//        displayedYear = components.year ?? displayedYear
//    }
//}

import Foundation
import Combine
import SwiftUI

final class CalendarViewModel: ObservableObject {
    // CRITICAL CHANGE: Only keep the main ActivityViewModel reference.
    private let activityViewModel: ActivityViewModel
    
    @Published var currentDate: Date
    @Published var displayedMonth: Int
    @Published var displayedYear: Int
    
    private var calendar = Calendar.current
    private var timer: AnyCancellable?

    // REMOVED: daysLearned and daysFreezed properties were removed as they are redundant.
    
    init(activityViewModel: ActivityViewModel) {
        self.activityViewModel = activityViewModel // Store the reference
        
        let now = Date()
        let calendar = Calendar.current
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
                // Optional: You might want to call activityViewModel.checkInactivityForStreakLoss() here
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
}
