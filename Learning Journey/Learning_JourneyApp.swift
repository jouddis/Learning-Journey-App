//
//  Learning_JourneyApp.swift
//  Learning Journey
//
//  Created by Joud Almashgari on 16/10/2025.
//

//import SwiftUI
//
//@main
//struct Learning_JourneyApp: App {
//    var body: some Scene {
//        WindowGroup {
//            ContentView()
//        }
//    }
//}

import SwiftUI

@main
struct LearningApp: App {
    // 1. Initialize the ActivityViewModel once for the entire app lifecycle
    @StateObject var viewModel = ActivityViewModel()
    
    var body: some Scene {
        WindowGroup {
            // 2. The ContentView acts as the Root Navigator
            ContentView(viewModel: viewModel)
        }
    }
}
