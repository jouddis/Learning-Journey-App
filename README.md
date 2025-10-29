Learning Journey: Daily Activity Tracker
This project was developed as a solution for the Apple Developer Academy's challenge "Bring the user interface design to life." The primary goal was to meticulously implement the provided design and functionality while strictly adhering to best practices and architectural constraints.
🎯 APP Statement
Learning Journey empowers learners to build daily habits around a topic they care about and track their progress in a clear, rewarding way.
Built exclusively for iOS 26, it embraces Apple’s new Liquid Glass design language—where interface elements adopt translucency, softness, and clarity—to create a modern, polished, and highly functional tracking tool.
📈 Features and Functionality
A tiny iOS app that helps you track your commitment and maintain your learning streak.
✍️ Onboarding: Set your learning topic and pick a goal duration (Week/Month/Year).
🔥 Streaks: Log "Learned Today" to maintain your streak. The streak meter updates instantly upon button press.
🧊 Freeze Days: Limited "skip" days are granted based on your goal duration (2/week, 8/month, 96/year).
📆 Dynamic Calendar: The main dashboard features a weekly calendar that highlights the current day (Orange) and correctly marks logged (Primary Accent) or frozen (Teal) days.
✅ Goal Management: Update your goal via the toolbar. This action triggers a custom, centered confirmation pop-over and correctly resets the active streak and available freeze count upon user confirmation.
🔒 Strict Streak Rules: The streak automatically breaks if no activity is logged/frozen within 32 hours or if the goal is changed.
💾 History Log: Review every day of commitment in a dedicated, continuously scrolling, multi-year calendar view (Jan 2019 - Dec 2026).
🏛️ App Architecture (MVVM & Combine)
The codebase is strictly structured using the MVVM Design Pattern to maximize clarity, testability, and separation of concerns.
💻 Requirements & Deliverables
Constraints:
Built using SwiftUI.
Designed to use the Liquid Glass aesthetic.
Source code is structured using the MVVM design pattern.
System Requirements:
iOS 26+ (For NavigationStack and modern APIs)
Xcode 14+ (For modern SwiftUI syntax)
