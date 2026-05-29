//
//  DataModel.swift
//  Learning Journey
//
//  Created by Joud Almashgari on 27/10/2025.
//
import Foundation
import SwiftUI
import SwiftData

// MARK: - Enums
enum DayStatus: Hashable {
    case `default`
    case logged
    case freezed
}

enum AppScreen {
    case onboarding
    case activity
}

enum NavDestination: Hashable {
    case goalUpdate
    case allActivities
}

// MARK: - SwiftData Models
@Model
final class LearningSession {
    var topic: String
    var duration: String // "Week", "Month", "Year"
    var startDate: Date
    var streakDaysCount: Int = 0
    var freezesUsedCount: Int = 0
    var lastLoggedDate: Date? = nil
    
    init(topic: String, duration: String, startDate: Date = Date()) {
        self.topic = topic
        self.duration = duration
        self.startDate = startDate
    }
    
    var freezeLimit: Int {
        switch duration {
        case "Week": return 2
        case "Month": return 8
        case "Year": return 96
        default: return 2
        }
    }
    
    var goalDaysRequired: Int {
        switch duration {
        case "Week": return 7
        case "Month": return 30
        case "Year": return 365
        default: return 7
        }
    }
    
    var isGoalCompleted: Bool {
        streakDaysCount >= goalDaysRequired
    }
}

// MARK: - Calendar Day Struct
struct CalendarDay: Identifiable {
    let id = UUID()
    let day: Int
    var isCurrent: Bool = false
    var status: DayStatus = .default
}

// MARK: - UserDefaults Helper for Calendar Marks
struct CalendarMarksManager {
    private static let loggedDatesKey = "com.learningjourney.loggedDates"
    private static let freezedDatesKey = "com.learningjourney.freezedDates"
    
    // Log a day as learned
    static func logDay(_ date: Date) {
        let normalized = Calendar.current.startOfDay(for: date)
        var logged = getLoggedDates()
        logged.insert(normalized.timeIntervalSince1970)
        UserDefaults.standard.set(Array(logged), forKey: loggedDatesKey)
    }
    
    // Freeze a day
    static func freezeDay(_ date: Date) {
        let normalized = Calendar.current.startOfDay(for: date)
        var freezed = getFreezedDates()
        freezed.insert(normalized.timeIntervalSince1970)
        UserDefaults.standard.set(Array(freezed), forKey: freezedDatesKey)
    }
    
    // Get status for a day
    static func getStatus(for date: Date) -> DayStatus {
        let normalized = Calendar.current.startOfDay(for: date)
        let timestamp = normalized.timeIntervalSince1970
        
        if getLoggedDates().contains(timestamp) {
            return .logged
        } else if getFreezedDates().contains(timestamp) {
            return .freezed
        }
        return .default
    }
    
    // Get all logged dates
    static func getLoggedDates() -> Set<TimeInterval> {
        let timestamps = UserDefaults.standard.array(forKey: loggedDatesKey) as? [TimeInterval] ?? []
        return Set(timestamps)
    }
    
    // Get all freezed dates
    static func getFreezedDates() -> Set<TimeInterval> {
        let timestamps = UserDefaults.standard.array(forKey: freezedDatesKey) as? [TimeInterval] ?? []
        return Set(timestamps)
    }
    
    // Count learned days
    static func countLearnedDays() -> Int {
        getLoggedDates().count
    }
    
    // Count freezed days
    static func countFreezedDays() -> Int {
        getFreezedDates().count
    }
    
    // Clear all marks
    static func clearAllMarks() {
        UserDefaults.standard.removeObject(forKey: loggedDatesKey)
        UserDefaults.standard.removeObject(forKey: freezedDatesKey)
    }
    
    // Check if today is already logged
    static func isTodayLogged() -> Bool {
        let today = Calendar.current.startOfDay(for: Date())
        return getStatus(for: today) != .default
    }
}
