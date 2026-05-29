//
//  OnboardingViewModel.swift
//  Learning Journey
//
//  Created by Joud Almashgari on 21/10/2025.
//
//
//
//  ActivityViewModel.swift
//  Learning Journey
//
//  Created by Joud Almashgari on 21/10/2025.
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
            let descriptor = FetchDescriptor<LearningSession>()
            let sessions = try context.fetch(descriptor)
            
            if let existingSession = sessions.last {
                // Session exists — restore all state
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
                
                // FIX 2: Restore currentDayStatus so button text is correct after relaunch
                // Without this, the button would say "Log as Learned" even if today was already logged
                if CalendarMarksManager.isTodayLogged() {
                    self.currentDayStatus = CalendarMarksManager.getStatus(for: Date())
                } else {
                    self.currentDayStatus = .default
                }
                
                // Navigate to activity screen
                self.currentScreen = .activity
            } else {
                // No session yet — stay on onboarding
                self.currentScreen = .onboarding
            }
        } catch {
            print("Error restoring session: \(error)")
            self.currentScreen = .onboarding
        }
    }
    
    // MARK: - Button State Logic
    
    var isLogAsLearnedDisabled: Bool {
        return CalendarMarksManager.isTodayLogged()
    }
    
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
        
        CalendarMarksManager.logDay(normalizedToday)
        
        session.streakDaysCount += 1
        session.lastLoggedDate = today
        lastActivityDate = today
        streakCount = session.streakDaysCount
        currentDayStatus = .logged
        
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
        
        CalendarMarksManager.freezeDay(normalizedToday)
        
        session.freezesUsedCount += 1
        session.lastLoggedDate = today
        freezesUsed = session.freezesUsedCount
        lastActivityDate = today
        currentDayStatus = .freezed
        
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
        
        if let context = modelContext {
            context.insert(newSession)
            try? context.save()
        }
        
        currentScreen = .activity
    }
    
    func updateLearningGoal(newTopic: String, newDuration: String) {
        guard let session = currentSession else { return }
        
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
        
        CalendarMarksManager.clearAllMarks()
        activityHistory.clearAllMarks()
        
        saveSession()
        isGoalUpdateVisible = false
        navPath.removeAll()
    }
    
    func setSameGoalAndDuration() {
        guard let session = currentSession else { return }

        // Reset streak in SwiftData too, not just UI state
        session.streakDaysCount = 0
        session.freezesUsedCount = 0
        session.lastLoggedDate = nil

        streakCount = 0
        freezesUsed = 0
        lastActivityDate = nil
        currentDayStatus = .default
        isGoalCompleted = false

        saveSession()
    }
    
    // MARK: - Navigation
    
    func goToAllActivities() { navPath.append(.allActivities) }
    func goToGoalUpdate()    { navPath.append(.goalUpdate) }
    
    // MARK: - Helper Methods
    
    func getStatus(for date: Date) -> DayStatus {
        CalendarMarksManager.getStatus(for: date)
    }
    
    private func updateActivityHistory() {
        var loggedDates: [Date: Color] = [:]
        
        for timestamp in CalendarMarksManager.getLoggedDates() {
            loggedDates[Date(timeIntervalSince1970: timestamp)] = activityHistory.loggedColor
        }
        for timestamp in CalendarMarksManager.getFreezedDates() {
            loggedDates[Date(timeIntervalSince1970: timestamp)] = activityHistory.freezedColor
        }
        
        activityHistory.loggedDates = loggedDates
    }
    
    private func saveSession() {
        try? modelContext?.save()
    }
    
    // MARK: - Date Simulator (for testing)
    var simulatedDate: Date? = nil
    
    func advanceToNextDay() {
        let base = simulatedDate ?? Date()
        simulatedDate = Calendar.current.date(byAdding: .day, value: 1, to: base)
    }
    
    func goToPreviousDay() {
        let base = simulatedDate ?? Date()
        simulatedDate = Calendar.current.date(byAdding: .day, value: -1, to: base)
    }
    
    func resetToRealDate() {
        simulatedDate = nil
    }
}
