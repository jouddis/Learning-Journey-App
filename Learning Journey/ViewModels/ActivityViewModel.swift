//
//  OnboardingViewModel.swift
//  Learning Journey
//
//  Created by Joud Almashgari on 21/10/2025.
//
//
import Foundation
import Combine
import SwiftUI
import SwiftData

class ActivityViewModel: ObservableObject {
    // MARK: - SwiftData Integration
    @Published var currentSession: LearningSession?
    var modelContext: ModelContext?
    
    // MARK: - UI State
    @Published var currentScreen: AppScreen = .onboarding
    @Published var navPath = [NavDestination]()
    @Published var isGoalUpdateVisible: Bool = false
    @Published var isGoalCompleted: Bool = false
    
    // MARK: - Goal State
    @Published var currentGoalTopic: String = "Swift"
    @Published var currentGoalDuration: String = "Week"
    
    // MARK: - Activity State
    @Published var currentDayStatus: DayStatus = .default
    @Published var calendarDays: [CalendarDay] = []
    
    // MARK: - Tracking
    @Published var lastActivityDate: Date? = nil
    @Published var streakCount: Int = 0
    @Published var freezesUsed: Int = 0
    @Published var availableFreezes: Int = 2
    
    // MARK: - Metrics (Computed from UserDefaults)
    var daysLearned: Int {
        CalendarMarksManager.countLearnedDays()
    }
    
    var daysFreezed: Int {
        CalendarMarksManager.countFreezedDays()
    }
    
    // MARK: - Activity History (for UI reference)
    @Published var activityHistory: ActivityHistory
    
    // MARK: - Initialization
    init() {
        self.activityHistory = ActivityHistory()
    }
    
    // MARK: - 🚀 CRITICAL: Restore Session on App Launch
    func restoreSessionIfExists() {
        guard let context = modelContext else { return }
        
        do {
            // Fetch all learning sessions (should ideally have just one active)
            let descriptor = FetchDescriptor<LearningSession>()
            let sessions = try context.fetch(descriptor)
            
            if let existingSession = sessions.last {
                // Session exists! Restore it
                self.currentSession = existingSession
                self.currentGoalTopic = existingSession.topic
                self.currentGoalDuration = existingSession.duration
                self.availableFreezes = existingSession.freezeLimit
                self.freezesUsed = existingSession.freezesUsedCount
                self.streakCount = existingSession.streakDaysCount
                self.lastActivityDate = existingSession.lastLoggedDate
                self.isGoalCompleted = existingSession.isGoalCompleted
                
                // Load calendar marks from UserDefaults
                activityHistory.refresh()
                
                // 🚀 CRITICAL: Set screen to activity (not onboarding)
                self.currentScreen = .activity
            } else {
                // No session exists, stay on onboarding
                self.currentScreen = .onboarding
            }
        } catch {
            print("Error restoring session: \(error)")
            self.currentScreen = .onboarding
        }
    }
    
    // MARK: - Button State Logic
    
    /// Can log as learned if:
    /// - Day hasn't been logged yet (either learned or freezed)
    var isLogAsLearnedDisabled: Bool {
        return CalendarMarksManager.isTodayLogged()
    }
    
    /// Can log as freezed if:
    /// - Day hasn't been logged yet
    /// - AND freezes remaining > 0
    var isLogAsFreezedDisabled: Bool {
        let freezesRemaining = availableFreezes - freezesUsed
        return CalendarMarksManager.isTodayLogged() || freezesRemaining <= 0
    }
    
    // MARK: - Streak Loss Logic (32+ hours)
    
    func checkInactivityForStreakLoss() {
        guard let lastDate = lastActivityDate else { return }
        guard let session = currentSession else { return }
        
        let timeElapsed = Date().timeIntervalSince(lastDate)
        let thirtyTwoHours: TimeInterval = 32 * 60 * 60
        
        if timeElapsed > thirtyTwoHours {
            // Streak is lost
            session.streakDaysCount = 0
            saveSession()
        }
    }
    
    // MARK: - Daily Reset Logic (12 AM)
    
    var hasDayReset: Bool {
        let today = Calendar.current.startOfDay(for: Date())
        
        if let lastLogged = lastActivityDate {
            let lastLoggedDay = Calendar.current.startOfDay(for: lastLogged)
            return today > lastLoggedDay
        }
        
        return true
    }
    
    // MARK: - Logging Actions
    
    func logDayAsLearned() {
        guard !isLogAsLearnedDisabled else { return }
        guard let session = currentSession else { return }
        
        let today = Date()
        let normalizedToday = Calendar.current.startOfDay(for: today)
        
        // Mark in UserDefaults
        CalendarMarksManager.logDay(normalizedToday)
        
        // Update session
        session.streakDaysCount += 1
        session.lastLoggedDate = today
        lastActivityDate = today
        streakCount = session.streakDaysCount
        currentDayStatus = .logged
        
        // Check if goal completed
        if session.isGoalCompleted {
            isGoalCompleted = true
        }
        
        saveSession()
        updateActivityHistory()
    }
    
    func logDayAsFreezed() {
        guard !isLogAsFreezedDisabled else { return }
        guard let session = currentSession else { return }
        
        let today = Date()
        let normalizedToday = Calendar.current.startOfDay(for: today)
        
        // Mark in UserDefaults
        CalendarMarksManager.freezeDay(normalizedToday)
        
        // Update session
        session.freezesUsedCount += 1
        session.lastLoggedDate = today
        freezesUsed = session.freezesUsedCount
        lastActivityDate = today
        currentDayStatus = .freezed
        
        // Note: Streak does NOT increment for freeze
        
        saveSession()
        updateActivityHistory()
    }
    
    // MARK: - Goal Management
    
    func startLearning() {
        let newSession = LearningSession(
            topic: currentGoalTopic,
            duration: currentGoalDuration
        )
        currentSession = newSession
        availableFreezes = newSession.freezeLimit
        freezesUsed = 0
        streakCount = 0
        lastActivityDate = nil
        currentDayStatus = .default
        isGoalCompleted = false
        
        // Save to SwiftData
        if let context = modelContext {
            context.insert(newSession)
            try? context.save()
        }
        
        currentScreen = .activity
    }
    
    func updateLearningGoal(newTopic: String, newDuration: String) {
        guard let session = currentSession else { return }
        
        // Reset everything for new goal
        session.topic = newTopic
        session.duration = newDuration
        session.startDate = Date()
        session.streakDaysCount = 0
        session.freezesUsedCount = 0
        session.lastLoggedDate = nil
        
        currentGoalTopic = newTopic
        currentGoalDuration = newDuration
        availableFreezes = session.freezeLimit
        freezesUsed = 0
        streakCount = 0
        lastActivityDate = nil
        currentDayStatus = .default
        isGoalCompleted = false
        
        // Clear all calendar marks
        CalendarMarksManager.clearAllMarks()
        
        saveSession()
        isGoalUpdateVisible = false
        navPath.removeAll()
    }
    
    func setSameGoalAndDuration() {
        isGoalCompleted = false
        currentDayStatus = .default
    }
    
    // MARK: - Navigation
    
    func goToAllActivities() {
        navPath.append(.allActivities)
    }
    
    func goToGoalUpdate() {
        navPath.append(.goalUpdate)
    }
    
    // MARK: - Helper Methods
    
    func getStatus(for date: Date) -> DayStatus {
        CalendarMarksManager.getStatus(for: date)
    }
    
    private func updateActivityHistory() {
        // Update the ActivityHistory object from UserDefaults
        var loggedDates: [Date: Color] = [:]
        
        let loggedSet = CalendarMarksManager.getLoggedDates()
        for timestamp in loggedSet {
            let date = Date(timeIntervalSince1970: timestamp)
            loggedDates[date] = activityHistory.loggedColor
        }
        
        let freezedSet = CalendarMarksManager.getFreezedDates()
        for timestamp in freezedSet {
            let date = Date(timeIntervalSince1970: timestamp)
            loggedDates[date] = activityHistory.freezedColor
        }
        
        activityHistory.loggedDates = loggedDates
    }
    
    private func saveSession() {
        if let context = modelContext, let session = currentSession {
            try? context.save()
        }
    }
    
    // For testing: simulate different dates
    var simulatedDate: Date? = nil
    
    func advanceToNextDay() {
        let baseDate = simulatedDate ?? Date()
        simulatedDate = Calendar.current.date(byAdding: .day, value: 1, to: baseDate)
    }
    
    func goToPreviousDay() {
        let baseDate = simulatedDate ?? Date()
        simulatedDate = Calendar.current.date(byAdding: .day, value: -1, to: baseDate)
    }
    
    func resetToRealDate() {
        simulatedDate = nil
    }
}
