//
//  OnboardingViewModel.swift
//  Learning Journey
//
//  Created by Joud Almashgari on 21/10/2025.
//

import Foundation
import Combine

// ⚠️ We don't import SwiftUI here, only Foundation, keeping the logic separate!

class OnboardingViewModel: ObservableObject {
    // @Published allows the View to automatically update when these change
    @Published var learningTopic: String = "Swift"
    @Published var selectedDuration: String = "Week"
    
    // All possible duration options
    let durationOptions = ["Week", "Month", "Year"]
    
    // Business Logic Method
    func startLearning() {
        // --- This is where the magic happens (e.g., API calls, data saving) ---
        
        print("✅ User is starting to learn: \(learningTopic)")
        print("✅ Duration set to: \(selectedDuration)")
        
        // Example: save the data to a database or user defaults
        // E.g., DataManager.shared.saveUserTopic(topic: learningTopic, duration: selectedDuration)
        
        // In a real app, you would change a state variable here to trigger navigation
        // E.g., isLearningStarted = true
    }
}

// 1. Data Structure for Calendar Day Status
struct CalendarDay: Identifiable {
    let id = UUID()
    let day: Int
    var isCurrent: Bool = false
    var status: DayStatus = .default
}

enum DayStatus {
    case `default`
    case logged
    case freezed
}

class ActivityViewModel: ObservableObject {
    // ⚠️ Renamed from OnboardingViewModel for clarity, assuming it manages the main app activity

    // ... (Existing Onboarding Properties: learningTopic, selectedDuration) ...

    // MARK: - Activity/Logging Data
    @Published var daysLearned: Int = 2
    @Published var daysFreezed: Int = 1
    @Published var availableFreezes: Int = 2 // Total available freezes for the period
    @Published var freezesUsed: Int = 1    // Freezes used today/so far
    
    @Published var currentMonth: String = "October 2025"
    
    @Published var currentDayStatus: DayStatus = .default // State driving the large button
    
    // Example data for the calendar row (Mocking the 20th to 26th)
    @Published var calendarDays: [CalendarDay] = [
        CalendarDay(day: 20, status: .logged),
        CalendarDay(day: 21, isCurrent: true, status: .default), // Current day starts as Default
        CalendarDay(day: 22),
        CalendarDay(day: 23),
        CalendarDay(day: 24, status: .logged),
        CalendarDay(day: 25, status: .freezed),
        CalendarDay(day: 26)
    ]

    // MARK: - Business Logic
    var isFreezeAvailable: Bool {
        return freezesUsed < availableFreezes
    }
    
    var isLogAsLearnedDisabled: Bool {
        // Log as Learned is disabled if the day is already Logged or Freezed
        return currentDayStatus != .default
    }
    
    var isLogAsFreezedDisabled: Bool {
        // Log as Freezed is disabled if:
        // 1. The day is already Logged or Freezed, OR
        // 2. All available freezes have been used
        return currentDayStatus != .default || freezesUsed >= availableFreezes
    }
    
    func logDayAsLearned() {
        if !isLogAsLearnedDisabled {
            daysLearned += 1
            currentDayStatus = .logged
            // Update calendarDays status for the current day
            if let index = calendarDays.firstIndex(where: { $0.isCurrent }) {
                calendarDays[index].status = .logged
            }
        }
    }
    
    func logDayAsFreezed() {
        if !isLogAsFreezedDisabled {
            daysFreezed += 1
            freezesUsed += 1
            currentDayStatus = .freezed
            // Update calendarDays status for the current day
            if let index = calendarDays.firstIndex(where: { $0.isCurrent }) {
                calendarDays[index].status = .freezed
            }
        }
    }
}
