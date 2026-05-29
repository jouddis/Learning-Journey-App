//
//  ActivityHistory.swift
//  Learning Journey
//
//  Created by Joud Almashgari on 26/10/2025.
//

import SwiftUI
import Foundation
import Combine


final class ActivityHistory: ObservableObject {
    private let calendar = Calendar.current
    
    // Key: Date, Value: Color (or DayStatus)
    @Published var loggedDates: [Date: Color] = [:]
    
    
    public let loggedColor = Color(.orange.opacity(0.28))
    public let freezedColor = Color(.primaryBlue.opacity(0.28))
    
    init() {

        let now = Date()
//
    }
    
    // Log activity to the historical record
    func logActivity(on date: Date, status: DayStatus) {
        let startOfDay = calendar.startOfDay(for: date)
        
        // 1. Create a mutable copy of the dictionary
        var tempDates = loggedDates
        
        // 2. Perform the mutation on the copy
        switch status {
        case .logged:
            tempDates[startOfDay] = loggedColor
        case .freezed:
            tempDates[startOfDay] = freezedColor
        case .default:
            tempDates.removeValue(forKey: startOfDay)
        }
        
        // 3. 🚀 CRITICAL: Reassign the entire dictionary back to the @Published property
        loggedDates = tempDates
    }
    
    // Function required by MonthLogSection for styling
    func colorForDate(_ date: Date) -> Color? {
        let startOfDay = calendar.startOfDay(for: date)
        return loggedDates[startOfDay]
    }
    
    // MARK: - Read-only accessors for metrics (used by ActivityViewModel)
    var learnedCount: Int {
        loggedDates.values.filter { $0 == loggedColor }.count
    }
    
    var freezedCount: Int {
        loggedDates.values.filter { $0 == freezedColor }.count
    }
    
    var allLoggedDatesSnapshot: [Date: Color] {
        loggedDates
    }
}
