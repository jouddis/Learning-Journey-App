//
//  OnboardingViewModel.swift
//  Learning Journey
//
//  Created by Joud Almashgari on 21/10/2025.
//

import Foundation
import Combine
import SwiftUI // Required for day status/color logic



enum NavDestination: Hashable {
    case goalUpdate
    case allActivities
}

enum AppScreen {
    case onboarding
    case activity
    // Note: .learningGoal and .allActivities are now NavDestinations,
    // but AppScreen still manages the initial app launch state.
}

// MARK: - ViewModel Implementation
class ActivityViewModel: ObservableObject {
    
    // 🚀 ADDITION 1: Simulated Date for Testing
//        @Published var simulatedDate: Date = Date()
    
    // --- Navigation & Goal State ---
    @Published var currentScreen: AppScreen = .onboarding // Starts on the onboarding screen
    @Published var isGoalUpdateVisible: Bool = false
    @Published var currentGoalTopic: String = "Swift"
    @Published var currentGoalDuration: String = "Month"
    @Published var isGoalCompleted: Bool = false

    // --- Activity/Logging Data ---
//    @Published var daysLearned: Int = 0
//    @Published var daysFreezed: Int = 0
    @Published var availableFreezes: Int = 2
    @Published var freezesUsed: Int = 0
    @Published var currentMonth: String = "October 2025"
    @Published var currentDayStatus: DayStatus = .default
    // 🚀 NEW: Property to track the last time a log or freeze occurred
        @Published var lastActivityDate: Date = Date()
        
        // 32 hours in seconds
        private let inactivityThreshold: TimeInterval = 32 * 60 * 60
    
    // 🚀 NEW: Tracks the date the current DayStatus (.logged or .freezed) was set.
        // This is distinct from lastActivityDate (which tracks streak continuity).
        @Published var currentStatusSetDate: Date? = nil
    
    
    
    // 🚀 CRITICAL: NavigationStack Path
        @Published var navPath = [NavDestination]()
    
    
    
    // --- Month/Year Picker State for AllActivitiesView ---
    @Published var isMonthYearPickerVisible: Bool = false
    @Published var selectedPickerMonth: Int = Calendar.current.component(.month, from: Date())
    @Published var selectedPickerYear: Int = Calendar.current.component(.year, from: Date())
    
    
    let durationOptions = ["Week", "Month", "Year"]

    @Published var calendarDays: [CalendarDay] = [
        CalendarDay(day: 20, status: .logged),
        CalendarDay(day: 21, isCurrent: true, status: .default),
        CalendarDay(day: 22),
        CalendarDay(day: 23),
        CalendarDay(day: 24, status: .logged),
        CalendarDay(day: 25, status: .freezed),
        CalendarDay(day: 26)
    ]
    
    
    // 🚀 CRITICAL: The Historical Data Model (renamed)
    @Published var activityHistory = ActivityHistory()
    
    // Metrics are now COMPUTED properties based on the history model
    var daysLearned: Int {
        return activityHistory.loggedDates.values.filter { $0 == Color("PrimaryAccent") }.count
//        activityHistory.learnedCount
    }
        
    var daysFreezed: Int {
        return activityHistory.loggedDates.values.filter { $0 == Color("TealAccent") }.count
//        activityHistory.freezedCount
    }
    
//    @Published var historicalCalendar: [String: [CalendarDay]] = [
//        "November 2025": [CalendarDay(day: 1, status: .default), CalendarDay(day: 7, status: .logged)],
//        "October 2025": [CalendarDay(day: 1, status: .logged), CalendarDay(day: 13, status: .freezed), CalendarDay(day: 20, status: .logged)],
//        "September 2025": [CalendarDay(day: 2, status: .logged), CalendarDay(day: 10, status: .logged), CalendarDay(day: 22, status: .freezed)],
//        "January 2025": [CalendarDay(day: 6, status: .logged), CalendarDay(day: 13, status: .freezed), CalendarDay(day: 21, status: .logged)]
//    ]

    // MARK: - Business Logic & Computed Properties
    
    // MARK: - Core Streak Reset Function
        
        // Function to perform a full streak reset
    func resetStreak() {
            print("🚨 Streak Reset Triggered!")
            
            // Reset all streak-related metrics to zero
//            daysLearned = 0
//            daysFreezed = 0
            freezesUsed = 0
            
            // Reset the current day status
            currentDayStatus = .default
            
            // NOTE: In a real app, you would also reset the calendar view status for future dates
        
        // 🚀 CRITICAL FIX: Reset the current status date so the system knows the day is NOT logged/freezed.
            self.currentStatusSetDate = nil
        }
    
    
    // 1. New function to calculate available freezes based on goal duration
        private func calculateAvailableFreezes(duration: String) -> Int {
            switch duration {
            case "Week":
                return 2
            case "Month":
                return 8
            case "Year":
                return 96
            default:
                return 0
            }
        }
        
    
    
    func goToAllActivities() {
            navPath.append(.allActivities)
        }

        func goToGoalUpdate() {
            navPath.append(.goalUpdate)
        }
        // 2. Override the goal update logic to recalculate freezes immediately
        func updateLearningGoal(newTopic: String, newDuration: String) {
            
            // CRITICAL: Reset the streak when the goal changes
                    resetStreak()



            // Reset streak/metrics
//            daysLearned = 0
//            daysFreezed = 0
            freezesUsed = 0
            currentDayStatus = .default
            
            // Update the goal properties
            currentGoalTopic = newTopic
            currentGoalDuration = newDuration
            
            // 🚀 CRITICAL UPDATE: Recalculate and set availableFreezes
            self.availableFreezes = calculateAvailableFreezes(duration: newDuration)

            isGoalUpdateVisible = false
            isGoalCompleted = false
//            currentScreen = .activity
            // CRITICAL: Pop back to the root of the stack (ActivityMainView)
                    navPath.removeAll()
        }
    
    // 2. Reset due to Inactivity (Needs a check function)
        func checkInactivityForStreakLoss() {
            let timeElapsed = Date().timeIntervalSince(lastActivityDate)
            
            if timeElapsed > inactivityThreshold {
                resetStreak()
            }
        }
    
    var isLogAsLearnedDisabled: Bool {
        return !hasDayReset || currentDayStatus != .default
    }
    
    var isLogAsFreezedDisabled: Bool {
//        return currentDayStatus != .default || freezesUsed >= availableFreezes
        return !hasDayReset || freezesUsed >= availableFreezes
    }
    
    // Onboarding Button Action
    // 3. Update the startLearning logic for the initial setup
        func startLearning() {
            currentScreen = .activity
            // Recalculate based on the initial duration set in the OnboardingView
            self.availableFreezes = calculateAvailableFreezes(duration: self.currentGoalDuration)
            /*currentScreen = .activity*/ // Move to the main app screen
        }

    func logDayAsLearned() {
        guard !isLogAsLearnedDisabled else { return }
        
//        daysLearned += 1
        currentDayStatus = .logged
        self.lastActivityDate = Date() // Update timestamp! 🚀
        self.currentStatusSetDate = Date() // 🚀 CRITICAL: Set the timestamp for the current status
        
        // 🚀 CRITICAL: Update the ActivityHistory model
            activityHistory.logActivity(on: Date(), status: .logged)
        
        if daysLearned >= 5 { self.isGoalCompleted = true }
        
        if let index = calendarDays.firstIndex(where: { $0.isCurrent }) {
            var tempDays = calendarDays
                    tempDays[index].status = .logged
                    calendarDays = tempDays
        }
    }
    
    func logDayAsFreezed() {
        guard !isLogAsFreezedDisabled else { return }
        
//        daysFreezed += 1
        freezesUsed += 1
        currentDayStatus = .freezed
        self.lastActivityDate = Date() // Update timestamp! 🚀
        self.currentStatusSetDate = Date() // 🚀 CRITICAL: Set the timestamp for the current status
        
        // 🚀 CRITICAL: Update the ActivityHistory model
            activityHistory.logActivity(on: Date(), status: .freezed)
        
        // Clean-up for the current day status tracker:
            if let index = calendarDays.firstIndex(where: { $0.isCurrent }) {
                var tempDays = calendarDays
                tempDays[index].status = .freezed
                calendarDays = tempDays
            }
    }
    
    
    // ⚠️ Update the status lookup function to use the new Model
        func getStatus(for date: Date) -> DayStatus {
            if let color = activityHistory.colorForDate(date) {
                if color == Color("PrimaryAccent") { return .logged }
                if color == Color("TealAccent") { return .freezed }
            }
            return .default
        }
    
    func setSameGoalAndDuration() {
        isGoalCompleted = false
//        daysLearned = 0
        // NOTE: The effective "reset" of the learned days count occurs automatically
            // when you start the next goal period, as the history moves into the past.
            // If you need to CLEAR the current day's status:
            currentDayStatus = .default
    }
    
//    func updateLearningGoal(newTopic: String, newDuration: String) {
//        // Reset streak/metrics upon goal change
//        daysLearned = 0
//        daysFreezed = 0
//        freezesUsed = 0
//        currentDayStatus = .default
//        
//        currentGoalTopic = newTopic
//        currentGoalDuration = newDuration
//        
//        isGoalUpdateVisible = false
//        isGoalCompleted = false
//        currentScreen = .activity
//    }
    
    func handleMonthYearSelection(month: Int, year: Int) {
        // Logic to jump/filter the AllActivitiesView content based on selection
        print("Historical view filter set to \(month)/\(year)")
        // You would typically filter `historicalCalendar` here or fetch new data.
        // Close the picker after selection if desired:
        // isMonthYearPickerVisible = false
    }
    
    // MARK: - Button Enabling/Disabling Logic
        
        // 🚀 CRITICAL NEW LOGIC: Check if the current day has started since the last status was set.
        var hasDayReset: Bool {
            guard let setDate = currentStatusSetDate else {
                // If status was never set, it's enabled.
                return true
            }
            
            let calendar = Calendar.current
            // A reset occurs if today's start is AFTER the day the status was last set.
            let startOfToday = calendar.startOfDay(for: Date())
            let startOfSetDay = calendar.startOfDay(for: setDate)
            
            // Buttons are enabled if the current day's start is LATER than the day the status was set.
            return startOfToday > startOfSetDay
        }
    // Testing feature - simulate different days
    var simulatedDate: Date? = nil  // Set this to test different dates
    
    private let calendar1 = Calendar.current

    // MARK: - Testing Helpers
    
    // Move to next day (for testing)
    func advanceToNextDay() {
        if let simulated = simulatedDate {
            simulatedDate = calendar1.date(byAdding: .day, value: 1, to: simulated)
        } else {
            simulatedDate = calendar1.date(byAdding: .day, value: 1, to: Date())
        }
    }
    
    // Move to previous day (for testing)
    func goToPreviousDay() {
        if let simulated = simulatedDate {
            simulatedDate = calendar1.date(byAdding: .day, value: -1, to: simulated)
        } else {
            simulatedDate = calendar1.date(byAdding: .day, value: -1, to: Date())
        }
    }
    
    // Reset to real current date
    func resetToRealDate() {
        simulatedDate = nil
    }
}
    
    

