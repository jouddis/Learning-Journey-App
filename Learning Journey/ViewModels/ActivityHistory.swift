//
//  ActivityHistory.swift
//  Learning Journey
//
//  Created by Joud Almashgari on 26/10/2025.
//

//import SwiftUI
//import Foundation
//import Combine
//
//// ⚠️ This class holds the historical data and lookup logic for the calendar.
//final class ActivityHistory: ObservableObject {
//    private let calendar = Calendar.current
//    
//    
//    // Key: Date, Value: Color (or DayStatus)
//    @Published  var loggedDates: [Date: Color] = [:]
//    
//    // Define Colors using Asset Catalog names
//    private let loggedColor = Color(.orange.opacity(0.28))
//    private let freezedColor = Color(.primaryBlue.opacity(0.28))
//    
//    init() {
//        // Mock data for initial population
//        let now = Date()
//        let yesterday = calendar.date(byAdding: .day, value: -1, to: now)!
//        let lastWeek = calendar.date(byAdding: .day, value: -7, to: now)!
//        let lastMonth = calendar.date(byAdding: .month, value: -1, to: now)!
//        
//        logActivity(on: now, status: .logged)
//        logActivity(on: yesterday, status: .logged)
//        logActivity(on: lastWeek, status: .freezed)
//        logActivity(on: lastMonth, status: .logged)
//    }
//    
//    // Log activity to the historical record
//    func logActivity(on date: Date, status: DayStatus) {
//        let startOfDay = calendar.startOfDay(for: date)
//        // 1. Create a mutable copy of the dictionary
//            var tempDates = loggedDates
//        
//        // 2. Perform the mutation on the copy
//            switch status {
//            case .logged:
//                tempDates[startOfDay] = loggedColor
//            case .freezed:
//                tempDates[startOfDay] = freezedColor
//            case .default:
//                tempDates.removeValue(forKey: startOfDay)
//            }
//        
//        // 3. 🚀 CRITICAL FIX: Reassign the entire dictionary back to the @Published property.
//            // This guarantees the ObservableObject notifies all observers (like ActivityViewModel).
//            loggedDates = tempDates
//    }
//    
//    // Function required by MonthLogSection for styling
//    func colorForDate(_ date: Date) -> Color? {
//        let startOfDay = calendar.startOfDay(for: date)
//        return loggedDates[startOfDay]
//    }
//    
//    // MARK: - Read-only accessors for metrics (keeps storage private)
//    var learnedCount: Int {
//        loggedDates.values.filter { $0 == loggedColor }.count
//    }
//    
//    var freezedCount: Int {
//        loggedDates.values.filter { $0 == freezedColor }.count
//    }
//    
//    // Optional: expose a read-only snapshot if ever needed elsewhere
//    var allLoggedDatesSnapshot: [Date: Color] {
//        loggedDates
//    }
//}
import SwiftUI
import Foundation
import Combine

// ⚠️ This class holds the historical data and lookup logic for the calendar.
final class ActivityHistory: ObservableObject {
    private let calendar = Calendar.current
    
    // Key: Date, Value: Color (or DayStatus)
    @Published var loggedDates: [Date: Color] = [:]
    
    // 🚀 FIX: Make internal colors visible to the ViewModel for comparison
    public let loggedColor = Color(.orange.opacity(0.28))
    public let freezedColor = Color(.primaryBlue.opacity(0.28))
    
    init() {
        // Mock data for initial population
        let now = Date()
//        let yesterday = calendar.date(byAdding: .day, value: -1, to: now)!
//        let lastWeek = calendar.date(byAdding: .day, value: -7, to: now)!
//        let lastMonth = calendar.date(byAdding: .month, value: -1, to: now)!
//        
        // Log the mock data
//        logActivity(on: now, status: .logged)
//        logActivity(on: yesterday, status: .logged)
//        logActivity(on: lastWeek, status: .freezed)
//        logActivity(on: lastMonth, status: .logged)
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
