//
//  Learning_JourneyApp.swift
//  Learning Journey
//
//  Created by Joud Almashgari on 16/10/2025.
//

import SwiftUI
import SwiftData

@main
struct LearningJourneyApp: App {
    let modelContainer: ModelContainer
    @StateObject var viewModel: ActivityViewModel
    
    init() {
        // Setup SwiftData
        let schema = Schema([LearningSession.self])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            self.modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not initialize ModelContainer: \(error)")
        }
        
        // Initialize ViewModel
        let vm = ActivityViewModel()
        vm.modelContext = modelContainer.mainContext
        _viewModel = StateObject(wrappedValue: vm)
        
        // 🚀 CRITICAL: Restore session from SwiftData on app launch
        vm.restoreSessionIfExists()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: viewModel)
        }
        .modelContainer(modelContainer)
    }
}
