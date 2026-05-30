//
//  ActivityViewModel.swift
//  Learning Journey
//
//  Created by Joud Almashgari on 21/10/2025.
//
//
//  ActivityViewModel.swift
//  Learning Journey
//

import Foundation
import Combine
import SwiftUI
import SwiftData

class ActivityViewModel: ObservableObject {

    // MARK: - SwiftData
    @Published var currentSession: LearningSession?
    var modelContext: ModelContext?

    // MARK: - Navigation
    @Published var currentScreen: AppScreen = .onboarding
    @Published var navPath = [NavDestination]()
    @Published var isGoalUpdateVisible: Bool = false

    // MARK: - Goal
    @Published var currentGoalTopic: String = "Swift"
    @Published var currentGoalDuration: String = "Week"
    @Published var isGoalCompleted: Bool = false

    // MARK: - Activity
    @Published var currentDayStatus: DayStatus = .default
    @Published var freezesUsed: Int = 0
    @Published var availableFreezes: Int = 2

    // MARK: - History
    @Published var activityHistory: ActivityHistory

    // MARK: - Metrics
    var daysLearned: Int { currentSession?.streakDaysCount ?? 0 }
    var daysFreezed: Int { currentSession?.freezesUsedCount ?? 0 }

    // MARK: - Button State
    var isLogAsLearnedDisabled: Bool { currentDayStatus != .default }
    var isLogAsFreezedDisabled: Bool { currentDayStatus != .default || freezesUsed >= availableFreezes }

    // MARK: - Init
    init() {
        self.activityHistory = ActivityHistory()
    }

    // MARK: - Restore on Launch
    func restoreSessionIfExists() {
        guard let context = modelContext else { return }
        do {
            let sessions = try context.fetch(FetchDescriptor<LearningSession>())
            if let session = sessions.last {
                currentSession      = session
                currentGoalTopic    = session.topic
                currentGoalDuration = session.duration
                availableFreezes    = session.freezeLimit
                freezesUsed         = session.freezesUsedCount
                isGoalCompleted     = session.isGoalCompleted
                activityHistory.refresh()
                currentDayStatus    = todayStatus()
                currentScreen       = .activity
            } else {
                currentScreen = .onboarding
            }
        } catch {
            print("Error restoring session: \(error)")
            currentScreen = .onboarding
        }
    }

    // MARK: - Streak Loss (32+ hours)
    func checkInactivityForStreakLoss() {
        guard let lastDate = currentSession?.lastLoggedDate,
              let session  = currentSession else { return }

        guard Date().timeIntervalSince(lastDate) > 32 * 3600 else { return }

        // Reset streak counters only — calendar history is preserved intentionally.
        // The colored days on past dates are a historical record and should not disappear.
        session.streakDaysCount  = 0
        session.freezesUsedCount = 0
        session.lastLoggedDate   = nil

        freezesUsed      = 0
        isGoalCompleted  = false

        // Don't reset currentDayStatus here: if the user already logged today
        // (which triggered the 32-hour window), today's mark should stay visible.
        saveSession()
    }

    // MARK: - Logging
    func logDayAsLearned() {
        guard !isLogAsLearnedDisabled, let session = currentSession else { return }

        let today = Calendar.current.startOfDay(for: Date())
        CalendarMarksManager.logDay(today)

        session.streakDaysCount += 1
        session.lastLoggedDate   = Date()
        currentDayStatus         = .logged
        isGoalCompleted          = session.isGoalCompleted

        saveSession()
        updateActivityHistory()
    }

    func logDayAsFreezed() {
        guard !isLogAsFreezedDisabled, let session = currentSession else { return }

        let today = Calendar.current.startOfDay(for: Date())
        CalendarMarksManager.freezeDay(today)

        session.freezesUsedCount += 1
        session.lastLoggedDate    = Date()
        freezesUsed               = session.freezesUsedCount
        currentDayStatus          = .freezed

        saveSession()
        updateActivityHistory()
    }

    // MARK: - Goal Management
    func startLearning() {
        let session = LearningSession(topic: currentGoalTopic, duration: currentGoalDuration)
        currentSession   = session
        availableFreezes = session.freezeLimit
        freezesUsed      = 0
        currentDayStatus = .default
        isGoalCompleted  = false

        modelContext?.insert(session)
        saveSession()
        currentScreen = .activity
    }

    func updateLearningGoal(newTopic: String, newDuration: String) {
        guard let session = currentSession else { return }

        session.topic            = newTopic
        session.duration         = newDuration
        session.startDate        = Date()
        session.streakDaysCount  = 0
        session.freezesUsedCount = 0
        session.lastLoggedDate   = nil

        currentGoalTopic    = newTopic
        currentGoalDuration = newDuration
        availableFreezes    = session.freezeLimit
        freezesUsed         = 0
        isGoalCompleted     = false

        // FIX: Do NOT clear calendar marks here.
        // Historical logs from the previous goal are preserved as a record.
        // If today was already logged under the old goal, keep that mark visible
        // and correctly disable today's buttons for the new goal too.
        currentDayStatus = todayStatus()

        saveSession()
        isGoalUpdateVisible = false
        navPath.removeAll()
    }

    func setSameGoalAndDuration() {
        guard let session = currentSession else { return }

        session.streakDaysCount  = 0
        session.freezesUsedCount = 0
        session.lastLoggedDate   = nil

        freezesUsed     = 0
        isGoalCompleted = false

        // FIX: Same as updateLearningGoal — preserve history, restore today's status.
        currentDayStatus = todayStatus()

        saveSession()
    }

    // MARK: - Navigation
    func goToAllActivities() { navPath.append(.allActivities) }
    func goToGoalUpdate()    { navPath.append(.goalUpdate) }

    // MARK: - Calendar
    func getStatus(for date: Date) -> DayStatus {
        CalendarMarksManager.getStatus(for: date)
    }

    // MARK: - Helpers

    /// Returns today's DayStatus from UserDefaults — used after any goal reset
    /// so the button state accurately reflects whether today was already logged.
    private func todayStatus() -> DayStatus {
        CalendarMarksManager.isTodayLogged()
            ? CalendarMarksManager.getStatus(for: Date())
            : .default
    }

    private func updateActivityHistory() {
        var dates: [Date: Color] = [:]
        CalendarMarksManager.getLoggedDates().forEach  { dates[Date(timeIntervalSince1970: $0)] = activityHistory.loggedColor }
        CalendarMarksManager.getFreezedDates().forEach { dates[Date(timeIntervalSince1970: $0)] = activityHistory.freezedColor }
        activityHistory.loggedDates = dates
    }

    private func saveSession() {
        try? modelContext?.save()
    }

    // MARK: - Date Simulator (testing only)
    var simulatedDate: Date? = nil
    func advanceToNextDay() { simulatedDate = Calendar.current.date(byAdding: .day, value:  1, to: simulatedDate ?? Date()) }
    func goToPreviousDay()  { simulatedDate = Calendar.current.date(byAdding: .day, value: -1, to: simulatedDate ?? Date()) }
    func resetToRealDate()  { simulatedDate = nil }
}
