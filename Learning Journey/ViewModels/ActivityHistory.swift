//
//  ActivityHistory.swift
//  Learning Journey
//
//  Created by Joud Almashgari on 26/10/2025.
//

import SwiftUI
import Foundation
import Combine

// ⚠️ This class holds the historical data and lookup logic for the calendar.
final class ActivityHistory: ObservableObject {
    private let calendar = Calendar.current
    
    // Key: Date, Value: Color (or DayStatus)
    @Published  var loggedDates: [Date: Color] = [:]
    
    // Define Colors using Asset Catalog names
    private let loggedColor = Color("PrimaryAccent")
    private let freezedColor = Color("TealAccent")
    
    init() {
        // Mock data for initial population
        let now = Date()
        let yesterday = calendar.date(byAdding: .day, value: -1, to: now)!
        let lastWeek = calendar.date(byAdding: .day, value: -7, to: now)!
        let lastMonth = calendar.date(byAdding: .month, value: -1, to: now)!
        
        logActivity(on: now, status: .logged)
        logActivity(on: yesterday, status: .logged)
        logActivity(on: lastWeek, status: .freezed)
        logActivity(on: lastMonth, status: .logged)
    }
    
    // Log activity to the historical record
    func logActivity(on date: Date, status: DayStatus) {
        let startOfDay = calendar.startOfDay(for: date)
        
        switch status {
        case .logged:
            loggedDates[startOfDay] = loggedColor
        case .freezed:
            loggedDates[startOfDay] = freezedColor
        case .default:
            loggedDates.removeValue(forKey: startOfDay)
        }
    }
    
    // Function required by MonthLogSection for styling
    func colorForDate(_ date: Date) -> Color? {
        let startOfDay = calendar.startOfDay(for: date)
        return loggedDates[startOfDay]
    }
    
    // MARK: - Read-only accessors for metrics (keeps storage private)
    var learnedCount: Int {
        loggedDates.values.filter { $0 == loggedColor }.count
    }
    
    var freezedCount: Int {
        loggedDates.values.filter { $0 == freezedColor }.count
    }
    
    // Optional: expose a read-only snapshot if ever needed elsewhere
    var allLoggedDatesSnapshot: [Date: Color] {
        loggedDates
    }
}
