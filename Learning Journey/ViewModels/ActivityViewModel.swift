//
//  OnboardingViewModel.swift
//  Learning Journey
//
//  Created by Joud Almashgari on 21/10/2025.
//
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
}

// MARK: - ViewModel Implementation
class ActivityViewModel: ObservableObject {
    
    // ⚠️ CRITICAL FIX: The robust Combine pattern is in place.
    var activityHistory: ActivityHistory
    private var historySubscription: AnyCancellable?
    
    // 🚀 CRITICAL NEW PROPERTY
    var currentDayIsClean: Bool = true // Assume no log has happened today
    
    // --- Navigation & Goal State ---
    @Published var currentScreen: AppScreen = .onboarding
    @Published var isGoalUpdateVisible: Bool = false
    @Published var currentGoalTopic: String = "Swift"
    @Published var currentGoalDuration: String = "Month"
    @Published var isGoalCompleted: Bool = false

    // --- Activity/Logging Data ---
    @Published var availableFreezes: Int = 2
    @Published var freezesUsed: Int = 0
    @Published var currentMonth: String = "October 2025"
    @Published var currentDayStatus: DayStatus = .default
    @Published var lastActivityDate: Date = Date()
    
    private let inactivityThreshold: TimeInterval = 32 * 60 * 60
    @Published var currentStatusSetDate: Date? = nil
    
    // 🚀 CRITICAL: NavigationStack Path
    @Published var navPath = [NavDestination]()
    
    // --- Month/Year Picker State for AllActivitiesView ---
    @Published var isMonthYearPickerVisible: Bool = false
    @Published var selectedPickerMonth: Int = Calendar.current.component(.month, from: Date())
    @Published var selectedPickerYear: Int = Calendar.current.component(.year, from: Date())
    
    let durationOptions = ["Week", "Month", "Year"]

    // Mock data for calendar days (should be populated dynamically in a real app)
    @Published var calendarDays: [CalendarDay] = [
        CalendarDay(day: 20, status: .logged),
        CalendarDay(day: 21, isCurrent: true, status: .default),
        CalendarDay(day: 22),
        CalendarDay(day: 23),
        CalendarDay(day: 24, status: .logged),
        CalendarDay(day: 25, status: .freezed),
        CalendarDay(day: 26)
    ]
    
    // 🚀 FINAL FIX: Use the Model's dedicated accessors for reliable metric counts.
    var daysLearned: Int {
        return activityHistory.learnedCount
    }
        
    var daysFreezed: Int {
        return activityHistory.freezedCount
    }
    
    // MARK: - Initialization and Subscription
    
    init() {
        // 1. Initialize the Model instance
        self.activityHistory = ActivityHistory()
            
        // 2. Set initial state
        self.availableFreezes = calculateAvailableFreezes(duration: self.currentGoalDuration)
            
        
        self.currentStatusSetDate = nil // Ensure 12 AM reset logic is immediately true
            self.currentDayStatus = .default // Ensure button state is default
        // 3. 🚀 CRITICAL: Manually subscribe to the Model's objectWillChange publisher.
        historySubscription = activityHistory.objectWillChange
            .sink { [weak self] _ in
                // Forward the notification to all observers of the ActivityViewModel
                self?.objectWillChange.send()
            }
    }
    
    deinit {
        historySubscription?.cancel()
    }
    
    // MARK: - Business Logic & Computed Properties
    
    func resetStreak() {
        print("🚨 Streak Reset Triggered!")
        
        freezesUsed = 0
        currentDayStatus = .default
        
        // Reset the current day status
    
        
        // CRITICAL FIX: Reset the current status date so the system knows the day is NOT logged/freezed.
        self.currentStatusSetDate = nil
    }
    
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
    
    func updateLearningGoal(newTopic: String, newDuration: String) {
        
        // CRITICAL: Reset the streak when the goal changes
        resetStreak()

        freezesUsed = 0
        currentDayStatus = .default
        
        // Update the goal properties
        currentGoalTopic = newTopic
        currentGoalDuration = newDuration
        
        // 🚀 CRITICAL UPDATE: Recalculate and set availableFreezes
        self.availableFreezes = calculateAvailableFreezes(duration: newDuration)

        isGoalUpdateVisible = false
        isGoalCompleted = false
        
        // CRITICAL: Pop back to the root of the stack (ActivityMainView)
        navPath.removeAll()
    }
    
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
        return !hasDayReset || freezesUsed >= availableFreezes
    }
    
    func startLearning() {
        currentScreen = .activity
        // Recalculate based on the initial duration set in the OnboardingView
        self.availableFreezes = calculateAvailableFreezes(duration: self.currentGoalDuration)
    }

    func logDayAsLearned() {
        guard !isLogAsLearnedDisabled else { return }
        
        // 1. Update Time States (CRITICAL for 32hr reset and 12AM reset)
        self.lastActivityDate = Date()
        self.currentStatusSetDate = Date()
        
        // 2. Set the UI Status
        currentDayStatus = .logged
        
        // 3. Update the Model (Metrics update automatically)
        activityHistory.logActivity(on: Date(), status: .logged)
        
        // 4. Logic for goal completion
        if daysLearned >= 5 { self.isGoalCompleted = true }
        
        // 5. UI Mock Update (Forces current week calendar view to show new color)
        if let index = calendarDays.firstIndex(where: { $0.isCurrent }) {
            var tempDays = calendarDays
            tempDays[index].status = .logged
            calendarDays = tempDays
        }
    }
     
    func logDayAsFreezed() {
        guard !isLogAsFreezedDisabled else { return }
        
        // 1. Update Consumable Resource
        freezesUsed += 1
        
        // 2. Update Time States (CRITICAL for 32hr reset and 12AM reset)
        self.lastActivityDate = Date()
        self.currentStatusSetDate = Date()
        
        // 3. Set the UI Status
        currentDayStatus = .freezed
        
        // 4. Update the Model (Metrics update automatically)
        activityHistory.logActivity(on: Date(), status: .freezed)
        
        // 5. UI Mock Update (Forces current week calendar view to show new color)
        if let index = calendarDays.firstIndex(where: { $0.isCurrent }) {
            var tempDays = calendarDays
            tempDays[index].status = .freezed
            calendarDays = tempDays
        }
    }
    
    func getStatus(for date: Date) -> DayStatus {
        if let color = activityHistory.colorForDate(date) {
            if color == activityHistory.loggedColor { return .logged } // Use Model's internal colors
            if color == activityHistory.freezedColor { return .freezed } // Use Model's internal colors
        }
        return .default
    }
    
    func setSameGoalAndDuration() {
        isGoalCompleted = false
        currentDayStatus = .default
    }
    
    func handleMonthYearSelection(month: Int, year: Int) {
        print("Historical view filter set to \(month)/\(year)")
    }
    
    // MARK: - Button Enabling/Disabling Logic
    
    var hasDayReset: Bool {
        guard let setDate = currentStatusSetDate else {
            return true
        }
        
        let calendar = Calendar.current
        let startOfToday = calendar.startOfDay(for: Date())
        let startOfSetDay = calendar.startOfDay(for: setDate)
        
        return startOfToday > startOfSetDay
    }
    
    // Testing feature - simulate different days
    var simulatedDate: Date? = nil
    private let calendar1 = Calendar.current

    func advanceToNextDay() {
        let baseDate = simulatedDate ?? Date()
        simulatedDate = calendar1.date(byAdding: .day, value: 1, to: baseDate)
    }
    
    func goToPreviousDay() {
        let baseDate = simulatedDate ?? Date()
        simulatedDate = calendar1.date(byAdding: .day, value: -1, to: baseDate)
    }
    
    func resetToRealDate() {
        simulatedDate = nil
    }
}

