//
//  ActivityHistory.swift
//  Learning Journey
//
//  Created by Joud Almashgari on 26/10/2025.
//
import Foundation
import Combine
import SwiftUI

final class ActivityHistory: ObservableObject {
    private let calendar = Calendar.current
    
    @Published var loggedDates: [Date: Color] = [:]
    
    // Color definitions
    let loggedColor = Color(.orange.opacity(0.28))
    let freezedColor = Color(.primaryBlue.opacity(0.28))
    
    init() {
        loadFromUserDefaults()
    }
    
    // Load calendar marks from UserDefaults
    private func loadFromUserDefaults() {
        var tempDates: [Date: Color] = [:]
        
        // Load logged dates
        let loggedSet = CalendarMarksManager.getLoggedDates()
        for timestamp in loggedSet {
            let date = Date(timeIntervalSince1970: timestamp)
            tempDates[date] = loggedColor
        }
        
        // Load freezed dates
        let freezedSet = CalendarMarksManager.getFreezedDates()
        for timestamp in freezedSet {
            let date = Date(timeIntervalSince1970: timestamp)
            tempDates[date] = freezedColor
        }
        
        self.loggedDates = tempDates
    }
    
    // Refresh from UserDefaults
    func refresh() {
        loadFromUserDefaults()
    }
    
    // Get color for a specific date
    func colorForDate(_ date: Date) -> Color? {
        let normalized = calendar.startOfDay(for: date)
        return loggedDates[normalized]
    }
    
    // Log activity (also updates UserDefaults via CalendarMarksManager)
    func logActivity(on date: Date, status: DayStatus) {
        let normalized = calendar.startOfDay(for: date)
        var tempDates = loggedDates
        
        switch status {
        case .logged:
            tempDates[normalized] = loggedColor
            CalendarMarksManager.logDay(normalized)
        case .freezed:
            tempDates[normalized] = freezedColor
            CalendarMarksManager.freezeDay(normalized)
        case .default:
            tempDates.removeValue(forKey: normalized)
        }
        
        loggedDates = tempDates
    }
    
    // Metrics
    var learnedCount: Int {
        loggedDates.values.filter { $0 == loggedColor }.count
    }
    
    var freezedCount: Int {
        loggedDates.values.filter { $0 == freezedColor }.count
    }
    
    var allLoggedDatesSnapshot: [Date: Color] {
        loggedDates
    }
    
    // Clear all
    func clearAllMarks() {
        loggedDates.removeAll()
        CalendarMarksManager.clearAllMarks()
    }
}
